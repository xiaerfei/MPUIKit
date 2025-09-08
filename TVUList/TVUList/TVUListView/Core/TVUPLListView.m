//
//  TVUPLListView.m
//  TVURequestAPIDemo
//
//  Created by TVUM4Pro on 2025/6/24.
//

#import "TVUPLListView.h"
#import "NSObject+BaseDataType.h"
#import "NSArray+Function.h"
#import "TVUSectionView.h"
#import "Masonry.h"

NSString *const kTVUPLRowHeight = @"RowH";
NSString *const kTVUPLRowData   = @"RowData";
NSString *const kTVUPLRowType   = @"RowType";
NSString *const kTVUPLRowKey    = @"RowKey";

@interface TVUPLListView ()
@property (nonatomic, strong) NSArray <TVUPLSection *> *sections;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSMutableArray *sectionCacheViews;
@property (nonatomic, strong) NSMutableArray *rowCacheViews;
@property (nonatomic, strong) NSMutableDictionary *rowMap;
@property (nonatomic, strong) NSMutableDictionary *sectionMap;
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
    TVUPLRow *row = [self rowForKey:key];
    if (row == nil) return;
    
    [self prepareForRow:row];
    [self layoutForSection:row.section];
}

- (TVUPLRow *)rowForKey:(NSString *)key {
    if (key.isString == NO || key.length == 0) {
        return nil;
    }
    return self.rowMap[key];
}

- (void)reloadSectionWithKey:(NSString *)key {
    TVUPLSection *section = [self sectionForKey:key];
    if (section == nil) return;
    [self reloadSection:section];
}

- (void)reloadSection:(TVUPLSection *)section {
    [self prepareForSection:section];
    [self layoutSubSections];
}

- (TVUPLSection *)sectionForKey:(NSString *)key {
    if (key.isString == NO || key.length == 0) {
        return nil;
    }
    return self.sectionMap[key];
}
#pragma mark - Private Methods
- (void)configureUI {
    self.contentView = [[UIView alloc] init];
    self.contentView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.contentView];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.width.equalTo(self);
    }];
    
    self.sectionCacheViews = [NSMutableArray array];
    self.rowCacheViews = [NSMutableArray array];
    self.rowMap = [NSMutableDictionary dictionary];
    self.sectionMap = [NSMutableDictionary dictionary];
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
        self.sectionMap[section.key] = section;
        [self prepareForSection:section];
    }
}

- (void)prepareForSection:(TVUPLSection *)section {
    if (section.fetchSectionParameterBlock != nil) {
        section.fetchSectionParameterBlock(section);
    }
    if (section.bindView == nil) {
        section.bindView = [[TVUSectionView alloc] init];
        [self.contentView addSubview:section.bindView];
    }
    section.bindView.section = section;
    section.bindView.hidden = section.hidden;
    if (section.rows.count == 0 || section.hidden) return;
    
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
    /// 添加背景 View
    if (row.backView == nil) {
        row.backView = [[UIView alloc] init];
        [view insertSubview:row.backView atIndex:0];
    }
    /// 添加 line
    if (row.lineView == nil) {
        row.lineView = [[UIView alloc] init];
        [view insertSubview:row.lineView atIndex:0];
    }
    
    if (row.fetchRowParameterBlock) {
        row.fetchRowParameterBlock(row);
    }

    if (row.lineColor) {
        row.lineView.backgroundColor = row.lineColor;
    } else {
        row.lineView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.1];
    }
    if (row.hidden == NO && row.dataByUser == NO) {
        [view reloadWithData:row.rowData];
        view.showIndicator = row.showIndicator;
    }
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
    BOOL isLastOne = [self isLastOneSection:section];
    
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
    
    if (section.hidden == YES) {
        return;
    }
    for (TVUPLRow *row in section.rows) {
        [self layoutForRow:row];
    }
}

- (TVUPLSection *)getPreSctionAtIndex:(NSUInteger)index {
    NSInteger preIndex = index - 1;
    if (preIndex < 0 || preIndex >= self.sections.count) {
        return nil;
    }
    
    for (int i = (int)preIndex; i >= 0; i--) {
        TVUPLSection *section = self.sections[i];
        if (section.hidden) continue;
        return section;
    }
    
    return nil;
}

- (BOOL)isLastOneSection:(TVUPLSection *)section {
    NSArray *sections = [self.sections filter:^BOOL(TVUPLSection *obj) {
        return obj.hidden == NO;
    }];
    return section == sections.lastObject;
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
        if (row.height > 0) {
            make.height.mas_equalTo(row.height);
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
    
    for (int i = (int)preIndex; i >= 0; i--) {
        TVUPLRow *frow = rows[i];
        if (frow.hidden) continue;
        return frow;
    }
    
    return nil;
}

- (BOOL)isLastOneRow:(TVUPLRow *)row {
    NSArray *rows = [row.section.rows filter:^BOOL(TVUPLRow *obj) {
        return obj.hidden == NO;
    }];
    return row == rows.lastObject;
}
#pragma mark - Cache Row View
- (void)cacheRowViews {
    for (UIView *subView in self.contentView.subviews) {
        [subView removeFromSuperview];
    }
    [self.rowMap removeAllObjects];
    [self.sectionMap removeAllObjects];
}

- (void)removeCacheRowViews {
    
}

#pragma mark - Components
- (Class)clsForRowType:(TVUPLRowType)type {
    static NSDictionary <NSNumber *, Class>*clsRowMap = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        clsRowMap = @{
            @(TVUPLRowTypeDefault)      : TVUPLDefaultRow.class,
            @(TVUPLRowTypeSwitch)       : TVUPLSwitchRow.class,
            @(TVUPLRowTypeLogin)        : TVUPLLoginRow.class,
            @(TVUPLRowTypeUnLogin)      : TVUPLUnLoginRow.class,
            @(TVUPLRowTypeCenterText)   : TVUPLCenterTextRow.class,
        };
    });
    return clsRowMap[@(type)];
}
@end

