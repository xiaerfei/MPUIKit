//
//  TVUPLRightValueRow.m
//  TVUCollectionView
//
//  Created by erfeixia on 2025/11/15.
//

#import "TVUPLRightValueRow.h"
#import "TVUPLDefaultCellView.h"
#import "NSObject+BaseDataType.h"
#import "Masonry.h"

NSString *const kTVUPLRowRightValue = @"RowRightValue";
NSString *const kTVUPLRowRightScale = @"RowRightScale";
NSString *const kTVUPLRightValueRow = @"TVUPLRightValueRow";

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
        make.width.lessThanOrEqualTo(self.plContentView).dividedBy(7.0f/10.0f);
    }];
}

- (void)updateWithData:(NSDictionary *)data {
    [self.defaultView updateWithData:data];
    self.rightLabel.text = [data[kTVUPLRowRightValue] toStringValue];
    CGFloat scale = [[data[kTVUPLRowRightValue] toStringValue] floatValue];
    [self updateLayoutConstraintsWithScale:scale];
}

- (void)updateLayoutConstraintsWithScale:(CGFloat)scale {
    BOOL showIndicator = self.plrow.rshowIndicator;
    if (scale <= 0 || scale > 1) {
        scale = 0.5;
    }
    [self.rightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.plContentView);
        make.top.greaterThanOrEqualTo(self.plContentView).offset(5);
        make.bottom.lessThanOrEqualTo(self.plContentView).offset(-5);
        make.width.equalTo(self.plContentView).dividedBy(1.0f/scale);
        if (showIndicator) {
            make.right.equalTo(self.indicatorImageView.mas_left).offset(-10);
        } else {
            make.right.equalTo(self.plContentView);
        }
    }];
}
@end
