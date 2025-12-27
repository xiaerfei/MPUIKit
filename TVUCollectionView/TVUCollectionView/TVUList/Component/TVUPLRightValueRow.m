//
//  TVUPLRightValueRow.m
//  TVUCollectionView
//
//  Created by erfeixia on 2025/11/15.
//

#import "TVUPLRightValueRow.h"
#import "TVUPLIconTextView.h"
#import "NSObject+BaseDataType.h"
#import "TVUPLRowData.h"
#import "Masonry.h"

NSString *const kTVUPLRowRightValue = @"RowRightValue";
NSString *const kTVUPLRowRightScale = @"RowRightScale";
NSString *const kTVUPLRightValueRow = @"TVUPLRightValueRow";
NSString *const kTVUPLRightPriority = @"TVUPLRightPriority";

@interface TVUPLRightValueRow ()
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) TVUPLIconTextView *defaultView;
@property (nonatomic, strong) UIStackView *stackView;


@property (nonatomic, strong) MASConstraint *multipliedBy;
@end

@implementation TVUPLRightValueRow
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.stackView = [[UIStackView alloc] init];
    self.stackView.axis = UILayoutConstraintAxisHorizontal;
    self.stackView.spacing = 10;
    self.stackView.alignment = UIStackViewAlignmentFill;
    self.stackView.distribution = UIStackViewDistributionFill;
    [self.plContentView addSubview:self.stackView];
    
    self.rightLabel = [[UILabel alloc] init];
    self.rightLabel.font = [UIFont systemFontOfSize:14];
    self.rightLabel.textAlignment = NSTextAlignmentRight;
    self.rightLabel.textColor = [UIColor grayColor];
    self.rightLabel.numberOfLines = 0;
    
    self.defaultView = [[TVUPLIconTextView alloc] initWithFrame:CGRectZero];
    
    [self.stackView addArrangedSubview:self.defaultView];
    [self.stackView addArrangedSubview:self.rightLabel];
    
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.plContentView);
    }];
}

- (void)updateWithData:(NSDictionary *)data {
    [self.defaultView updateWithData:data];
    self.rightLabel.text = [data[kTVUPLRowRightValue] toStringValue];
    CGFloat scale = [[data[kTVUPLRowRightScale] toStringValue] floatValue];
    TVUPLRowLayoutPriority strategy = [data[kTVUPLRightPriority] toIntegerValue];
    [self layoutLabelsWithStrategy:strategy scale:scale];
}

- (void)layoutLabelsWithStrategy:(TVUPLRowLayoutPriority)strategy
                           scale:(CGFloat)scale {

    BOOL showIndicator = self.plrow.rshowIndicator;

    /// =============================
    /// 1️⃣ 统一基本优先级（安全基线）
    /// =============================
    [self.defaultView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    [self.rightLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    /// =============================
    /// 2️⃣ 先清理掉比例模式产生的 width 约束
    ///  （避免 CustomScale 残留）
    /// =============================
    [self.multipliedBy uninstall];
    self.multipliedBy = nil;

    /// =============================
    /// 3️⃣ 根据策略切换
    /// =============================
    switch (strategy) {

        /// =====================
        /// 左侧优先展示
        /// =====================
        case TVUPLRowTitleRequired:
        {
            [self.defaultView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
            [self.rightLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
            break;
        }

        /// =====================
        /// 右侧优先展示
        /// =====================
        case TVUPLRowRightRequired:
        {
            [self.defaultView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
            [self.rightLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
            break;
        }

        /// =====================
        /// 自定义比例
        /// =====================
        case TVUPLRowCustomScale:
        {
            /// ❗避免 0 或 1 导致 ambiguous
            const CGFloat kEpsilon = 0.001;
            scale = MAX(kEpsilon, MIN(scale, 1.0 - kEpsilon));

            CGFloat ratio = (1.0 - scale) / scale;

            /// ⭐⭐ 关键点：
            /// 不再绑定 stackView.width
            /// 改成两 label 相对比例（UIStackView 不再歧义）
            [self.defaultView mas_remakeConstraints:^(MASConstraintMaker *make) {
                self.multipliedBy = make.width.equalTo(self.rightLabel.mas_width).multipliedBy(ratio);
            }];
            break;
        }
    }

    /// =============================
    /// 4️⃣ stackView 外约束
    /// =============================
    [self.stackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.plContentView);

        if (showIndicator) {
            make.right.equalTo(self.indicatorImageView.mas_left).offset(-10);
        } else {
            make.right.equalTo(self.plContentView);
        }
    }];
}




@end
