//
//  TVUStaticView.m
//  TVUCollectionView
//
//  Created by erfeixia on 2025/12/14.
//

#import "TVUStaticView.h"
#import "Masonry.h"

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
#pragma mark - Private Methods
- (void)setupSubviews {
    [self setupMainStackView];
    
    NSArray *data = @[@"第五条文本，非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常",@"Item 1", @"Item 2", @"Item 3", @"Item 4", @"Item 5",@"Item 1", @"Item 2", @"Item 3", @"Item 4", @"Item 5",@"Item 1", @"Item 2", @"Item 3", @"Item 4", @"Item 5",@"Item 1", @"Item 2", @"Item 3", @"Item 4", @"Item 5"];
    for (NSString *item in data) {
        // 创建每个 cell 的视图（比如 UILabel）
        UILabel *label = [[UILabel alloc] init];
        label.numberOfLines = 0;
        label.text = item;
        label.textAlignment = NSTextAlignmentLeft;
        label.backgroundColor = [UIColor lightGrayColor];
        label.layer.cornerRadius = 5;
        label.layer.masksToBounds = YES;
        if (item.length > 20) {
            UIStackView *stackView = [[UIStackView alloc] init];
            stackView.axis = UILayoutConstraintAxisVertical;  // 垂直排列
            stackView.spacing = 0;  // 每个项之间的间隔
            // 填充子视图
            stackView.alignment = UIStackViewAlignmentFill;
            // 填充整个空间
            stackView.distribution = UIStackViewDistributionFill;
            [stackView addArrangedSubview:label];
            [self.mainStackView addArrangedSubview:stackView];
        } else {
            // 将每个 item 添加到 stackView
            [self.mainStackView addArrangedSubview:label];
        }
    }
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



@end
