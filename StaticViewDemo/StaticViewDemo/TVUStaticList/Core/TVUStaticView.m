//
//  TVUStaticView.m
//  TVUCollectionView
//
//  Created by erfeixia on 2025/12/14.
//

#import "TVUStaticView.h"
#import "TVUPLBaseRow.h"
#import "Masonry.h"



NSString *const kTVUPLDefaultRow = @"TVUPLDefaultRow";

NSString *const kTVUPLRowLoginBigWord = @"RowLoginBigWord";
NSString *const kTVUPLLoginRow        = @"TVUPLLoginRow";

NSString *const kTVUPLRowRightValue = @"RowRightValue";
NSString *const kTVUPLRowRightScale = @"RowRightScale";
NSString *const kTVUPLRightValueRow = @"TVUPLRightValueRow";
NSString *const kTVUPLRightPriority = @"TVUPLRightPriority";

// Switch相关常量实现
NSString *const kTVUPLRowSwitchOn       = @"RowSwitchOn";
NSString *const kTVUPLRowSwitchEnabled  = @"RowSwitchEnabled";

NSString *const kTVUPLSwitchRow         = @"TVUPLSwitchRow";

// 常量实现
NSString *const kTVUPLRowTitle          = @"RowTitle";
NSString *const kTVUPLRowTitleFont      = @"RowTitleFont";
NSString *const kTVUPLRowTitleColor     = @"RowTitleColor";
NSString *const kTVUPLRowTitleAlignment = @"RowTitleAlignment";
NSString *const kTVUPLRowTitleNumberOfLines = @"RowTitleNumberOfLines";

NSString *const kTVUPLRowSubtitle       = @"RowSubtitle";
NSString *const kTVUPLRowSubtitleFont   = @"RowSubtitleFont";
NSString *const kTVUPLRowSubtitleColor  = @"RowSubtitleColor";

NSString *const kTVUPLRowIcon           = @"RowIcon";
NSString *const kTVUPLRowSystemIcon     = @"RowSystemIcon";
NSString *const kTVUPLRowIconTintColor  = @"RowIconTintColor";
NSString *const kTVUPLRowIconSize       = @"RowIconSize";

@interface TVUStaticView ()
@property (nonatomic, strong) UIStackView *mainStackView;
@property (nonatomic,   copy) void(^rprefetch)(TVUStaticView *list);
@property (nonatomic, strong) NSArray <TVUPLSection *>*rsections;
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
        [self prepareSection:section];
        [self.mainStackView addArrangedSubview:section.stackView];
    }
}
#pragma mark - Private Methods
- (void)setupSubviews {
    [self setupMainStackView];
}

- (void)setupMainStackView {
    self.mainStackView = [[UIStackView alloc] init];
    [self addSubview:self.mainStackView];
    self.mainStackView.axis = UILayoutConstraintAxisVertical;  // 垂直排列
    self.mainStackView.spacing = 10;  // 每个项之间的间隔
    self.mainStackView.alignment = UIStackViewAlignmentFill;  // 填充子视图
    self.mainStackView.distribution = UIStackViewDistributionFill;  // 填充整个空间
    // 使用 Masonry 设置 stackView 的约束，使其宽度与 UIScrollView 一致
    [self.mainStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
        make.width.equalTo(self.mas_width);
    }];
}

- (void)prepareSection:(TVUPLSection *)section {
    if (section.stackView == nil) {
        UIStackView *stackView = [[UIStackView alloc] init];
        stackView.axis = UILayoutConstraintAxisVertical;  // 垂直排列
        stackView.spacing = 0;  // 每个项之间的间隔
        // 填充子视图
        stackView.alignment = UIStackViewAlignmentFill;
        // 填充整个空间
        stackView.distribution = UIStackViewDistributionFill;
        section.stackView = stackView;
    }
    
    for (TVUPLRow *row in section.rrows) {
        if (row.rprefetch) row.rprefetch(row);
        TVUPLBaseRow *cell =
        [[NSClassFromString(row.rIdentifier) alloc] init];
        [section.stackView addArrangedSubview:cell];
        // 设置每个 item 的高度
        if (row.rHeight != 0) {
            [cell mas_makeConstraints:^(MASConstraintMaker *make) {
                // 设置每个 item 的固定高度
                make.height.equalTo(@(row.rHeight));
            }];
        }
        row.rsection = section;
        cell.plrow = row;
        [cell updateWithData:row.rRowData];
    }
}

@end
