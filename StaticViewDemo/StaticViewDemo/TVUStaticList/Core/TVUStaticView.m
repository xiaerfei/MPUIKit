//
//  TVUStaticView.m
//  TVUCollectionView
//
//  Created by erfeixia on 2025/12/14.
//

#import "TVUStaticView.h"
#import "TVUPLStackView.h"
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
        [self prepareDataForSection:section];
        [self.mainStackView addArrangedSubview:section.contentView];
        [self prepareLayoutForSection:section];
    }
}
#pragma mark - Private Methods
- (void)setupSubviews {
    [self setupMainStackView];
}

- (void)setupMainStackView {
    self.mainStackView = [[UIStackView alloc] init];
    self.mainStackView.mas_key = @"Main";
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
#pragma mark - Section Methods
- (void)prepareDataForSection:(TVUPLSection *)section {
    if (section.contentView == nil) {
        UIView *contentView = [[UIView alloc] init];
        section.contentView = contentView;
    }
    
    if (section.backgroundView == nil) {
        UIView *backgroundView = [[UIView alloc] init];
        backgroundView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
        backgroundView.layer.cornerRadius  = 8;
        backgroundView.layer.masksToBounds = YES;
        backgroundView.mas_key = @"backgroundView";
        section.backgroundView = backgroundView;
    }
    
    if (section.stackView == nil) {
        UIStackView *stackView = [[UIStackView alloc] init];
        stackView.axis = UILayoutConstraintAxisVertical;  // 垂直排列
        stackView.spacing = 0;  // 每个项之间的间隔
        // 填充子视图
        stackView.alignment = UIStackViewAlignmentFill;
        // 填充整个空间
        stackView.distribution = UIStackViewDistributionFill;
        stackView.mas_key = @"Section";
        section.stackView = stackView;
    }
    
    if (section.backgroundView.superview == nil) {
        [section.contentView addSubview:section.backgroundView];
    }
    
    if (section.stackView.superview == nil) {
        [section.backgroundView addSubview:section.stackView];
    }
    
    for (TVUPLRow *row in section.rrows) {
        [self prepareDataForRow:row section:section];
        [self prepareLayoutForRow:row section:section];
    }
}

- (void)prepareLayoutForSection:(TVUPLSection *)section {
    [section.stackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(section.backgroundView);
    }];
    
    [section.backgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(section.contentView).offset(20);
        make.right.equalTo(section.contentView).offset(-20);
        make.top.bottom.equalTo(section.contentView);
    }];
}
#pragma mark - Row Methods
- (void)prepareDataForRow:(TVUPLRow *)row section:(TVUPLSection *)section {
    if (row.rprefetch) row.rprefetch(row);
    if (row.rowView == nil) {
        row.rowView = [[NSClassFromString(row.rIdentifier) alloc] init];
        [section.stackView addArrangedSubview:row.rowView];
    }
    row.rsection = section;
    row.rowView.plrow = row;
    [row.rowView updateWithData:row.rRowData];
}

- (void)prepareLayoutForRow:(TVUPLRow *)row section:(TVUPLSection *)section {
    [row.rowView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (row.rHeight != 0) {
            // 设置每个 item 的固定高度
            make.height.equalTo(@(row.rHeight));
        }
    }];
}


@end
