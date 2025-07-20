//
//  TVUPLListView.m
//  TVURequestAPIDemo
//
//  Created by TVUM4Pro on 2025/6/24.
//

#import "TVUPLListView.h"
#import "NSObject+BaseDataType.h"
#import "Masonry.h"
NSString *const kTVUPLRowHeight = @"RowH";
NSString *const kTVUPLRowData   = @"RowData";
NSString *const kTVUPLRowType   = @"RowType";
NSString *const kTVUPLRowKey    = @"RowKey";

@interface TVUPLRow ()
@property (nonatomic, assign, readwrite) TVUPLRowType type;
@property (nonatomic,   copy, readwrite) NSString *key;
@property (nonatomic, strong, readwrite) TVUPLBaseRow <TVUPLRowProtocol> *bindView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, weak) TVUPLSection *section;
@end
@implementation TVUPLRow
- (instancetype)initWithType:(TVUPLRowType)type
                         key:(NSString *)key {
    self = [super init];
    if (self) {
        self.type = type;
        self.key  = key;
    }
    return self;
}
@end

@interface TVUPLSection ()
@property (nonatomic, strong) NSMutableArray <TVUPLRow *> *rows;
@property (nonatomic, assign) NSUInteger index;
@end
@implementation TVUPLSection
- (instancetype)init {
    self = [super init];
    if (self) {
        self.rows = [NSMutableArray array];
    }
    return self;
}
- (void)addRow:(TVUPLRow *)row {
    if (row != nil && [self.rows containsObject:row] == NO) {
        [self.rows addObject:row];
    }
}
@end

@interface TVUPLListView ()
@property (nonatomic, strong) NSArray <TVUPLSection *> *sections;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSMutableArray *sectionCacheViews;
@property (nonatomic, strong) NSMutableArray *rowCacheViews;
@property (nonatomic, strong) NSMutableDictionary *rowMap;
@end

@implementation TVUPLListView
- (instancetype)init {
    self = [super init];
    if (self) {
        [self configureUI];
    }
    return self;
}

#pragma mark - Public Methods
- (void)reload {
    [self cacheRowViews];
    [self prepareFetchDatas];
    [self layoutSubSections];
    [self removeCacheRowViews];
}

- (void)reloadRowWithKey:(NSString *)key {
    TVUPLRow *row = self.rowMap[key];
    [self prepareForRow:row];
    [self layoutForRow:row];
}
#pragma mark - Private Methods
- (void)configureUI {
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.contentView];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self); // 关键：contentView 与 scrollView 边缘对齐
        make.width.equalTo(self); // 关键：明确 contentSize.width
    }];
    
    self.sectionCacheViews = [NSMutableArray array];
    self.rowCacheViews = [NSMutableArray array];
    self.rowMap = [NSMutableDictionary dictionary];
}
#pragma mark prepare data
- (void)prepareFetchDatas {
    if (self.fetchSectionsBlock == nil) return;
    NSArray <TVUPLSection *>*sections = self.fetchSectionsBlock();
    if (sections.isArray == NO || sections.count == 0) {
        return;
    }
    self.sections = [sections copy];
    for (int i = 0; i < sections.count; i++) {
        TVUPLSection *section = sections[i];
        section.index = i;
        [self prepareForSection:section];
    }
}

- (void)prepareForSection:(TVUPLSection *)section {
    if (section.rows.count == 0) return;
    if (section.bindView == nil) {
        section.bindView = [[UIView alloc] init];
        [self.contentView addSubview:section.bindView];
    }
    
    if (section.backgroundColor) {
        section.bindView.backgroundColor = section.backgroundColor;
    } else {
        section.bindView.backgroundColor = [UIColor clearColor];
    }
    
    if (section.cornerRadius > 0) {
        section.bindView.layer.cornerRadius  = section.cornerRadius;
        section.bindView.layer.masksToBounds = YES;
    } else {
        section.bindView.layer.cornerRadius  = 0;
        section.bindView.layer.masksToBounds = NO;
    }
    
    for (int i = 0; i < section.rows.count; i++) {
        TVUPLRow *row = section.rows[i];
        row.index = i;
        row.section = section;
        self.rowMap[row.key] = row;
        [self prepareForRow:row];
    }
}

- (void)prepareForRow:(TVUPLRow *)row {
    TVUPLBaseRow <TVUPLRowProtocol> *view = row.bindView;
    if (view == nil) {
        view = [self viewForRowType:row.type];
        row.bindView = view;
        [row.section.bindView addSubview:view];
    }
    view.type = row.type;
    view.row = row;
    if (row.fetchRowParameterBlock) {
        row.fetchRowParameterBlock(row);
    }

    if (row.lineView == nil) {
        row.lineView = [[UIView alloc] init];
        [view addSubview:row.lineView];
    }
    if (row.lineColor) {
        row.lineView.backgroundColor = row.lineColor;
    } else {
        row.lineView.backgroundColor = [UIColor lightGrayColor];
    }
    
    if (row.backView == nil) {
        row.backView = [[UIView alloc] init];
        [view insertSubview:row.backView atIndex:0];
    }
    [view reloadWithData:row.rowData];
}

- (TVUPLBaseRow <TVUPLRowProtocol> *)viewForRowType:(TVUPLRowType)type {
    Class cls = [self clsForRowType:type];
    if (cls == nil) return nil;

    return (TVUPLBaseRow <TVUPLRowProtocol> *)[[cls alloc] init];
}

#pragma mark layout sections
- (void)layoutSubSections {
    for (TVUPLSection *section in self.sections) {
        [self layoutForSection:section];
    }
}

- (void)layoutForSection:(TVUPLSection *)section {
    UIView *bindView = section.bindView;
    
    TVUPLSection *preSection = [self getPreSctionAtIndex:section.index];
    BOOL isLastOne = [self isLastOneSectionAtIndex:section.index];
    
    CGFloat top = section.insets.top + preSection.insets.bottom;
    [bindView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(section.insets.left);
        if (preSection) {
            make.top.equalTo(preSection.bindView.mas_bottom).offset(top);
        } else {
            make.top.equalTo(self.contentView).offset(top);
        }
        make.right.equalTo(self.contentView).offset(-section.insets.right);
        
        if (isLastOne) {
            make.bottom.equalTo(self.contentView).offset(-section.insets.bottom);
        }
    }];
    
    for (TVUPLRow *row in section.rows) {
        [self layoutForRow:row];
    }
}

- (TVUPLSection *)getPreSctionAtIndex:(NSUInteger)index {
    NSInteger preIndex = index - 1;
    if (preIndex < 0 || preIndex >= self.sections.count) {
        return nil;
    }
    return self.sections[preIndex];
}

- (BOOL)isLastOneSectionAtIndex:(NSUInteger)index {
    return index == (self.sections.count - 1);
}

- (void)layoutForRow:(TVUPLRow *)row {
    UIView *bindView = row.bindView;
    UIView *superView = bindView.superview;
    
    TVUPLRow *preRow = [self getPreRow:row];
    BOOL isLastOne = [self isLastOneRow:row];
    
    bindView.hidden = row.hidden;
    CGFloat top = row.hidden ? 0 : (row.insets.top + preRow.insets.bottom);
    
    [bindView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView).offset(row.insets.left);
        make.right.equalTo(superView).offset(-row.insets.right);
        if (preRow) {
            make.top.equalTo(preRow.bindView.mas_bottom).offset(top);
        } else {
            make.top.equalTo(superView).offset(row.insets.top);
        }
        if (row.hidden) {
            make.height.mas_equalTo(0).priority(UILayoutPriorityRequired);
        } else {
            if (row.height > 0) {
                make.height.mas_equalTo(row.height);
            }
        }
        
        if (isLastOne) {
            make.bottom.equalTo(superView).offset(-row.insets.bottom);
        }
    }];
    if (row.hidden == NO &&
        isLastOne == NO &&
        row.hiddenLine == NO) {
        [row.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bindView).offset(row.lineInsets.left);
            make.right.equalTo(bindView).offset(-row.lineInsets.right);
            make.bottom.equalTo(bindView).offset(-row.lineInsets.bottom);
            make.height.mas_equalTo(1);
        }];
    } else {
        row.lineView.frame = CGRectZero;
    }
    [row.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(bindView);
    }];
}

- (TVUPLRow *)getPreRow:(TVUPLRow *)row {
    NSInteger preIndex = row.index - 1;
    NSArray *rows = row.section.rows;
    if (preIndex < 0 || preIndex >= rows.count) {
        return nil;
    }
    return rows[preIndex];
}

- (BOOL)isLastOneRow:(TVUPLRow *)row {
    NSArray *rows = row.section.rows;
    return row.index == (rows.count - 1);
}
#pragma mark - Cache Row View
- (void)cacheRowViews {
    for (UIView *subView in self.contentView.subviews) {
        [subView removeFromSuperview];
    }
}

- (void)removeCacheRowViews {
    
}

#pragma mark - Components
- (Class)clsForRowType:(TVUPLRowType)type {
    static NSDictionary <NSNumber *, Class>*clsRowMap = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        clsRowMap = @{
            @(TVUPLRowTypeDefault) :  TVUPLDefaultRow.class
        };
    });
    return clsRowMap[@(type)];
}
@end
