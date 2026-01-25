//
//  TVUPLStackView.m
//  StaticViewDemo
//
//  Created by erfeixia on 2026/1/25.
//

#import "TVUPLStackView.h"
#import "Masonry.h"

@interface TVUPLStackView ()
@property (nonatomic, strong, readwrite) UIStackView *mainStackView;
@end

@implementation TVUPLStackView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureUI];
    }
    return self;
}
#pragma mark - Private Methods
- (void)configureUI {
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.axis = UILayoutConstraintAxisVertical;  // 垂直排列
    stackView.spacing = 0;  // 每个项之间的间隔
    // 填充子视图
    stackView.alignment = UIStackViewAlignmentFill;
    // 填充整个空间
    stackView.distribution = UIStackViewDistributionFill;
    
    [self addSubview:stackView];
    
    [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    self.mainStackView = stackView;
}
@end
