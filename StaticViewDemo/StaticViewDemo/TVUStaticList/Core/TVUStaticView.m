//
//  TVUStaticView.m
//  TVUCollectionView
//
//  Created by erfeixia on 2025/12/14.
//

#import "TVUStaticView.h"
#import "TVUPLBaseRow.h"
#import "Masonry.h"

@interface TVUStaticView ()
@property (nonatomic, strong) UIStackView *mainStackView;
@property (nonatomic,   copy) void(^rprefetch)(TVUStaticView *list);
@property (nonatomic, strong) NSArray <TVUPLSection *>*rsections;
@property (nonatomic, strong) NSMutableDictionary <NSString *, TVUPLSection *>*sectionDict;
@property (nonatomic, strong) NSMutableDictionary <NSString *, TVUPLRow *>*rowDict;
@end

@implementation TVUStaticView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}
#pragma mark - Public Methods
- (TVUStaticView *(^)(void(^)(TVUStaticView *list)))prefetch {
    return ^(void(^block)(TVUStaticView *list)) {
        self.rprefetch = block;
        return self;
    };
}

- (TVUStaticView *(^)(NSArray <TVUPLSection *>*sections))sections {
    return ^(NSArray *sections) {
        self.rsections = sections;
        return self;
    };
}

- (void)reload {
    
    NSArray<UIView *> *arrangedSubviews = self.mainStackView.arrangedSubviews;
    for (UIView *item in arrangedSubviews) {
        [self.mainStackView removeArrangedSubview:item];
    }
    
    if (self.rprefetch) self.rprefetch(self);
    
    for (TVUPLSection *section in self.rsections) {
        if (section.rprefetch) section.rprefetch(section);
        [self prepareDataForSection:section];
        [self prepareLayoutForSection:section];
    }
}

- (void)reloadSectionForKey:(NSString *)key {
    if (key.length == 0) return;
    
    TVUPLSection *section = self.sectionDict[key];
    if (section == nil) return;
    
    if (section.rprefetch) section.rprefetch(section);
    [self prepareDataForSection:section];
    [self prepareLayoutForSection:section];
}

- (void)reloadRowForKey:(NSString *)key {
    if (key.length == 0) return;
    
    TVUPLRow *row = self.rowDict[key];
    if (row == nil) return;
    
    if (row.rprefetch) row.rprefetch(row);
    
    [self prepareDataForRow:row
                    section:row.rsection
                     forRow:row.rrowType == TVUPLRowTypeDefault];
    [self prepareLayoutForRow:row section:row.rsection];
}
#pragma mark - Private Methods
- (void)setupSubviews {
    self.sectionDict = @{}.mutableCopy;
    self.rowDict = @{}.mutableCopy;
    [self setupMainStackView];
}

- (void)setupMainStackView {
    self.mainStackView = [self createStackWithSpacing:10];
    self.mainStackView.mas_key = @"Main";
    [self addSubview:self.mainStackView];
    // 使用 Masonry 设置 stackView 的约束，使其宽度与 UIScrollView 一致
    [self.mainStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
        make.width.equalTo(self.mas_width);
    }];
}
#pragma mark - Section Methods
- (void)prepareDataForSection:(TVUPLSection *)section {
    if (section.rkey) {
        self.sectionDict[section.rkey] = section;
    }
    
    if (section.contentView == nil) {
        section.contentView = [[UIView alloc] init];
        [self.mainStackView addArrangedSubview:section.contentView];
    }
    
    if (section.stackView == nil) {
        section.stackView = [self createStackWithSpacing:0];
        section.stackView.mas_key = @"SectionStackView";
        [section.contentView addSubview:section.stackView];
    }
    
    if (section.header) {
        [self prepareDataForRow:section.header section:section forRow:NO];
        [self prepareLayoutForRow:section.header section:section];
    }
    
    if (section.backgroundView == nil) {
        section.backgroundView = [[UIView alloc] init];
        section.backgroundView.mas_key = @"BackgroundView";
        [section.stackView addArrangedSubview:section.backgroundView];
    }
    
    
    if (section.rowsStackView == nil) {
        section.rowsStackView = [self createStackWithSpacing:0];
        section.rowsStackView.mas_key = @"RowsStackView";
        [section.backgroundView addSubview:section.rowsStackView];
    }

    [self configureSectionData:section];
    
    for (TVUPLRow *row in section.rrows) {
        [self prepareDataForRow:row section:section forRow:YES];
        [self prepareLayoutForRow:row section:section];
    }
    
    if (section.footer) {
        [self prepareDataForRow:section.footer section:section forRow:NO];
        [self prepareLayoutForRow:section.footer section:section];
    }
}

- (void)prepareLayoutForSection:(TVUPLSection *)section {
    TVUPLViewData *viewData = [section customForKey:kTVUPLDataSection];
    CGFloat left  = viewData.minsets.left;
    CGFloat right = viewData.minsets.right;
    
    [section.stackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(section.contentView).offset(left);
        make.right.equalTo(section.contentView).offset(-right);
        make.top.bottom.equalTo(section.contentView);
    }];
    
    [section.rowsStackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}

- (void)configureSectionData:(TVUPLSection *)section {
    TVUPLViewData *viewData = [section customForKey:kTVUPLDataSection];
    section.backgroundView.backgroundColor =
    viewData.mbackgroundColor ? viewData.mbackgroundColor : [UIColor clearColor];
    
    section.backgroundView.layer.cornerRadius  = viewData.mcornerRadius;
    section.backgroundView.layer.masksToBounds = viewData.mcornerRadius != 0;
    
    section.contentView.hidden = viewData.mhidden;
}

#pragma mark - Row Methods
- (void)prepareDataForRow:(TVUPLRow *)row section:(TVUPLSection *)section forRow:(BOOL)forRow {
    if (row.rprefetch) row.rprefetch(row);
    if (row.rowView == nil) {
        row.rowView = [[NSClassFromString(row.midentifier) alloc] init];
        if (forRow) {
            [section.rowsStackView addArrangedSubview:row.rowView];
        } else {
            [section.stackView addArrangedSubview:row.rowView];
        }
    }
    row.rowView.hidden = row.rhidden;
    row.rsection = section;
    row.rowView.plrow = row;
    [row.rowView updateWithData:row.rRowData];
    
    if (row.mkey) {
        self.rowDict[row.mkey] = row;
    }
}

- (void)prepareLayoutForRow:(TVUPLRow *)row section:(TVUPLSection *)section {
    [row.rowView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (row.rHeight != 0) {
            // 设置每个 item 的固定高度
            make.height.equalTo(@(row.rHeight));
        }
    }];
}

#pragma mark - Private Methods
- (UIStackView *)createStackWithSpacing:(CGFloat)spacing {
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.axis = UILayoutConstraintAxisVertical;  // 垂直排列
    stackView.spacing = spacing;  // 每个项之间的间隔
    stackView.alignment = UIStackViewAlignmentFill;  // 填充子视图
    stackView.distribution = UIStackViewDistributionFill;  // 填充整个空间
    return stackView;
}
@end
