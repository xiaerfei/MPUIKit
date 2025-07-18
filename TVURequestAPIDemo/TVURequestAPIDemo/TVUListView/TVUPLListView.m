//
//  TVUPLListView.m
//  TVURequestAPIDemo
//
//  Created by TVUM4Pro on 2025/6/24.
//

#import "TVUPLListView.h"
#import "NSObject+BaseDataType.h"
#import "TVUPLCRows.h"
#import "Masonry.h"

NSString *const kTVUPLRowHeight = @"RowH";
NSString *const kTVUPLRowData   = @"RowData";
NSString *const kTVUPLRowType   = @"RowType";
NSString *const kTVUPLRowKey    = @"RowKey";

@interface TVUPLRow ()
@property (nonatomic, strong, readwrite) UIView <TVUPLRowProtocol> *bindView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, assign) CGFloat height;
@end
@implementation TVUPLRow
@end

@interface TVUPLSection ()

@end
@implementation TVUPLSection

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
    [self prepareFetchDatas];
    [self layoutSubSections];
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
    [self.contentView addSubview:section.bindView];
    
    for (TVUPLRow *row in section.rows) {
        [self prepareForRow:row];
        [section.bindView addSubview:row.bindView];
    }
}

- (void)prepareForRow:(TVUPLRow *)row {
    if (row.fetchRowParameterBlock == nil) {
        return;
    }
    NSDictionary *info = row.fetchRowParameterBlock(row);
    if (info.isDictionary == NO || info.count == 0) {
        return;
    }
    
    id data    = info[kTVUPLRowData];
    row.height = [[info[kTVUPLRowHeight] toStringValue] floatValue];
    row.key    = [info[kTVUPLRowKey] toStringValue];
    
    UIView <TVUPLRowProtocol> *view = [self viewForRowType:row.type];
    [view reloadWithData:data];
    row.bindView = view;
    
    
    row.lineView = [[UIView alloc] init];
    if (row.lineColor) {
        row.lineView.backgroundColor = row.lineColor;
    } else {
        row.lineView.backgroundColor = [UIColor lightGrayColor];
    }
    [view addSubview:row.lineView];
}

- (UIView <TVUPLRowProtocol> *)viewForRowType:(TVUPLRowType)type {
    Class cls = [self clsForRowType:type];
    if (cls == nil) return nil;

    return (UIView <TVUPLRowProtocol> *)[[cls alloc] init];
}

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
    
    [row.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bindView).offset(row.lineInsets.left);
        make.right.equalTo(bindView).offset(-row.lineInsets.right);
        make.bottom.equalTo(bindView).offset(-row.lineInsets.bottom);
        make.height.mas_equalTo(1);
    }];
}

@end
