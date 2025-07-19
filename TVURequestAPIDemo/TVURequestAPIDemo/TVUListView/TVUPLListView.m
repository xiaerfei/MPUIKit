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
@property (nonatomic, strong) NSMutableArray <TVUPLSection *> *sections;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
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
    
}
#pragma mark - Private Methods
- (void)configureUI {
    self.scrollView = [[UIScrollView alloc] init];
    [self addSubview:self.scrollView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:self.contentView];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView); // 关键：contentView 与 scrollView 边缘对齐
        make.width.equalTo(self.scrollView); // 关键：明确 contentSize.width
    }];
}
#pragma mark prepare data
- (void)prepareFetchDatas {
    if (self.fetchSectionsBlock == nil) return;
    
    NSArray <TVUPLSection *>*sections = self.fetchSectionsBlock();
    if (sections.isArray == NO || sections.count == 0) {
        return;
    }
    
    for (TVUPLSection *section in sections) {
        [self prepareForSection:section];
    }
    
    self.sections = sections.mutableCopy;
}

- (void)prepareForSection:(TVUPLSection *)section {
    if (section.rows.count == 0) return;
    section.bindView = [[UIView alloc] init];
    if (section.backgroundColor) {
        section.bindView.backgroundColor = section.backgroundColor;
    } else {
        section.bindView.backgroundColor = [UIColor clearColor];
    }
    
    if (section.cornerRadius > 0) {
        section.bindView.layer.cornerRadius  = section.cornerRadius;
        section.bindView.layer.masksToBounds = YES;
    }
    
    [self.contentView addSubview:section.bindView];
    
    for (TVUPLRow *row in section.rows) {
        row.section = section;
        [self prepareForRow:row];
        [section.bindView addSubview:row.bindView];
    }
}

- (void)prepareForRow:(TVUPLRow *)row {
    TVUPLBaseRow <TVUPLRowProtocol> *view = [self viewForRowType:row.type];
    view.type = row.type;
    view.row = row;
    row.bindView = view;
    if (row.fetchRowParameterBlock) {
        row.fetchRowParameterBlock(row);
    }

    row.lineView = [[UIView alloc] init];
    if (row.lineColor) {
        row.lineView.backgroundColor = row.lineColor;
    } else {
        row.lineView.backgroundColor = [UIColor lightGrayColor];
    }
    [view addSubview:row.lineView];
    
    row.backView = [[UIView alloc] init];
    [view insertSubview:row.backView atIndex:0];
    [row.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    [view reloadWithData:row.rowData];
}

- (TVUPLBaseRow <TVUPLRowProtocol> *)viewForRowType:(TVUPLRowType)type {
    Class cls = [self clsForRowType:type];
    if (cls == nil) return nil;

    return (TVUPLBaseRow <TVUPLRowProtocol> *)[[cls alloc] init];
}

#pragma mark layout sections
- (void)layoutSubSections {
    TVUPLSection *preSection = nil;
    NSInteger cnt = self.sections.count;
    for (int i = 0; i < cnt; i++) {
        TVUPLSection *section = self.sections[i];
        [self layoutForSection:section preSection:preSection isLastOne:i == (cnt - 1)];
        preSection = section;
    }
}

- (void)layoutForSection:(TVUPLSection *)section
              preSection:(TVUPLSection *)preSection
               isLastOne:(BOOL)isLastOne {
    UIView *bindView = section.bindView;
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
    
    TVUPLRow *preRow = nil;
    NSInteger cnt = section.rows.count;
    for (int i = 0; i < cnt; i++) {
        TVUPLRow *row = section.rows[i];
        [self layoutForRow:row preRow:preRow isLastOne:i == (cnt - 1)];
        preRow = row;
    }
}

- (void)layoutForRow:(TVUPLRow *)row
              preRow:(TVUPLRow *)preRow
           isLastOne:(BOOL)isLastOne {
    UIView *bindView = row.bindView;
    UIView *superView = bindView.superview;
    
    CGFloat top = row.insets.top + preRow.insets.bottom;
    
    [bindView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(superView).offset(row.insets.left);
        make.right.equalTo(superView).offset(-row.insets.right);
        if (preRow) {
            make.top.equalTo(preRow.bindView.mas_bottom).offset(top);
        } else {
            make.top.equalTo(superView).offset(row.insets.top);
        }
        
        if (row.height > 0) {
            make.height.mas_equalTo(row.height);
        }
        
        if (isLastOne) {
            make.bottom.equalTo(superView).offset(-row.insets.bottom);
        }
    }];
    if (isLastOne == NO && row.hiddenLine == NO) {
        [row.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(bindView).offset(row.lineInsets.left);
            make.right.equalTo(bindView).offset(-row.lineInsets.right);
            make.bottom.equalTo(bindView).offset(-row.lineInsets.bottom);
            make.height.mas_equalTo(1);
        }];
    } else {
        row.lineView.frame = CGRectZero;
    }
}
#pragma mark - Cache Row View
- (void)cacheRowViews {
    
    
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
