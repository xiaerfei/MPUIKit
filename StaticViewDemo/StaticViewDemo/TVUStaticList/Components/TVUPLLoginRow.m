//
//  TVUPLLoginRow.m
//  StaticViewDemo
//
//  Created by erfeixia on 2026/2/7.
//

#import "TVUPLLoginRow.h"
#import "TVUPLDefaultView.h"
#import "TVUPLSection.h"
#import "Masonry.h"

NSString *const kTVUPLLoginRow = @"TVUPLLoginRow";

@interface TVUPLLoginRow ()
@property (nonatomic, strong) TVUPLDefaultView *defaultView;
@property (nonatomic, strong) UILabel *bigWordLabel;
@property (nonatomic, strong) UIStackView *hStackView;
@end

@implementation TVUPLLoginRow
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
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.axis = UILayoutConstraintAxisHorizontal;  // 垂直排列
    stackView.spacing = 10;  // 每个项之间的间隔
    stackView.alignment = UIStackViewAlignmentFill;  // 填充子视图
    stackView.distribution = UIStackViewDistributionFill;  // 填充整个空间
    self.hStackView = stackView;
    self.hStackView.mas_key = @"LoginStackView";
    [self.plContentView addSubview:self.hStackView];
    
    [self.hStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.plContentView);
    }];
    
    
    self.bigWordLabel = [[UILabel alloc] init];
    UIView *bigView = [UIView new];
    [bigView addSubview:self.bigWordLabel];
    bigView.mas_key = @"bigBackView";
    [self.hStackView addArrangedSubview:bigView];
    
    [self.bigWordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bigView);
        make.left.right.equalTo(bigView);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    

    self.defaultView = [[TVUPLDefaultView alloc] initWithFrame:CGRectZero];
    self.defaultView.mas_key = @"defaultView";
    [self.hStackView addArrangedSubview:self.defaultView];
}

- (void)updateWithData:(NSDictionary *)data {
    TVUPLLabelData *labelData = [self.plrow customForKey:kTVUPLDataKey0];
    [labelData configure:self.bigWordLabel];
    
    [self.bigWordLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(labelData.mframe.size.width));
        make.height.equalTo(@(labelData.mframe.size.height));
    }];
    
    [self.defaultView updateWithRowData:self.plrow];
}
@end
