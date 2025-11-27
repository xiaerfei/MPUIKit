//
//  TVUPLRightValueRow.m
//  TVUCollectionView
//
//  Created by erfeixia on 2025/11/15.
//

#import "TVUPLRightValueRow.h"
#import "TVUPLDefaultCellView.h"
#import "NSObject+BaseDataType.h"
#import "TVUPLRowData.h"
#import "Masonry.h"

NSString *const kTVUPLRowRightValue = @"RowRightValue";
NSString *const kTVUPLRowRightScale = @"RowRightScale";
NSString *const kTVUPLRightValueRow = @"TVUPLRightValueRow";
NSString *const kTVUPLRightPriority = @"TVUPLRightPriority";

@interface TVUPLRightValueRow ()
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) TVUPLDefaultCellView *defaultView;
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
    // 标题
    self.rightLabel = [[UILabel alloc] init];
    self.rightLabel.numberOfLines = 1;
    // 默认样式
    self.rightLabel.font = [UIFont systemFontOfSize:14];
    self.rightLabel.textAlignment = NSTextAlignmentRight;
    self.rightLabel.textColor = [UIColor grayColor];
    self.rightLabel.numberOfLines = 0;
    [self.plContentView addSubview:self.rightLabel];
    
    self.defaultView = [[TVUPLDefaultCellView alloc] initWithFrame:CGRectZero];
    [self.plContentView addSubview:self.defaultView];
    
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.plContentView);
        make.right.equalTo(self.rightLabel.mas_left).offset(-10);
    }];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.equalTo(self.plContentView);
        make.top.greaterThanOrEqualTo(self.plContentView).offset(5);
        make.bottom.lessThanOrEqualTo(self.plContentView).offset(-5);
    }];
}

- (void)updateWithData:(NSDictionary *)data {
    [self.defaultView updateWithData:data];
    self.rightLabel.text = [data[kTVUPLRowRightValue] toStringValue];
    CGFloat scale = [[data[kTVUPLRowRightValue] toStringValue] floatValue];
    TVUPLRowLayoutPriority strategy = [data[kTVUPLRightPriority] toIntegerValue];
    [self layoutLabelsWithStrategy:strategy scale:scale];
}

- (void)layoutLabelsWithStrategy:(TVUPLRowLayoutPriority)strategy scale:(CGFloat)scale {
    BOOL showIndicator = self.plrow.rshowIndicator;
    switch (strategy) {
        case TVUPLRowTitleRequired:
        {
            // titleLabel 优先展示，rightLabel 占剩余空间
            [self.defaultView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
            [self.rightLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
            [self.rightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.plContentView);
                make.top.greaterThanOrEqualTo(self.plContentView).offset(5);
                make.bottom.lessThanOrEqualTo(self.plContentView).offset(-5);
                if (showIndicator) {
                    make.right.equalTo(self.indicatorImageView.mas_left).offset(-10);
                } else {
                    make.right.equalTo(self.plContentView);
                }
            }];
            break;
        }

        case TVUPLRowRightRequired:
        {
            // rightLabel 优先展示，titleLabel 占剩余空间
            [self.rightLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
            [self.defaultView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
            [self.rightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.plContentView);
                make.top.greaterThanOrEqualTo(self.plContentView).offset(5);
                make.bottom.lessThanOrEqualTo(self.plContentView).offset(-5);
                if (showIndicator) {
                    make.right.equalTo(self.indicatorImageView.mas_left).offset(-10);
                } else {
                    make.right.equalTo(self.plContentView);
                }
            }];
            break;
        }

        case TVUPLRowCustomScale:
        {
            // 自定义比例，scale 为 titleLabel 占比
            scale = MAX(0.0, MIN(scale, 1.0)); // 限制在 0~1 之间

            [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.contentView).offset(15);
                make.width.equalTo(self.contentView.mas_width).multipliedBy(scale).priorityHigh();
            }];
            
            [self.rightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.plContentView);
                make.top.greaterThanOrEqualTo(self.plContentView).offset(5);
                make.bottom.lessThanOrEqualTo(self.plContentView).offset(-5);
                make.width.equalTo(self.plContentView.mas_width).multipliedBy(scale);
                if (showIndicator) {
                    make.right.equalTo(self.indicatorImageView.mas_left).offset(-10);
                } else {
                    make.right.equalTo(self.plContentView);
                }
            }];

            // 两者都设置抗压缩优先级为默认，避免冲突
            [self.defaultView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
            [self.rightLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
            break;
        }
    }
}


@end
