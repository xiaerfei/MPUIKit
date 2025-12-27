//
//  OtherViewController.m
//  TVUCollectionView
//
//  Created by TVUM4Pro on 2025/12/12.
//

#import "OtherViewController.h"
#import "Masonry.h"
@interface OtherViewController ()
@end

@implementation OtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self testHorizontal];
}

- (void)testHorizontal {
    UILabel *leftLabel = [UILabel new];
    leftLabel.numberOfLines = 0;
    leftLabel.text = @"左边展示";
    leftLabel.backgroundColor = UIColor.redColor;

    [leftLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    UILabel *rightLabel = [UILabel new];
    rightLabel.numberOfLines = 0;
    rightLabel.text = @"可以通过 UIStackView + UILabel 的 Hugging / Compression Resistance Priority 与 自定义 width / multiplier 约束 来实现三种策略。";
    rightLabel.backgroundColor = UIColor.greenColor;

    UIStackView *stack = [[UIStackView alloc] initWithArrangedSubviews:@[leftLabel, rightLabel]];
    stack.axis = UILayoutConstraintAxisHorizontal;
    stack.spacing = 10;
    stack.alignment = UIStackViewAlignmentFill;
    stack.distribution = UIStackViewDistributionFill;
    [self.view addSubview:stack];
    
    [stack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.left.right.equalTo(self.view);
    }];
}

- (void)testVertical {
    UILabel *leftLabel = [UILabel new];
    leftLabel.numberOfLines = 0;
    leftLabel.text = @"如果你愿意，把你 layoutLabelsWithStrategy 全函数贴出来，我可以帮你整理成 无副作用 / 无 Warning / 生产级 的最终版";
    leftLabel.backgroundColor = UIColor.redColor;

    UILabel *rightLabel = [UILabel new];
    rightLabel.numberOfLines = 0;
    rightLabel.text = @"可以通过 UIStackView + UILabel 的 Hugging / Compression Resistance Priority 与 自定义 width / multiplier 约束 来实现三种策略。";
    rightLabel.backgroundColor = UIColor.greenColor;

    UIStackView *stack = [[UIStackView alloc] initWithArrangedSubviews:@[leftLabel, rightLabel]];
    stack.axis = UILayoutConstraintAxisVertical;
    stack.spacing = 8;
    stack.alignment = UIStackViewAlignmentFill;
    stack.distribution = UIStackViewDistributionFill;
    
    UISwitch *ss = [[UISwitch alloc] init];
    UIView *cssView = [UIView new];
    [cssView addSubview:ss];
    
    [ss sizeToFit];
    
    [ss mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.centerY.equalTo(cssView);
        make.width.equalTo(@(CGRectGetWidth(ss.bounds)));
    }];
    
    UIStackView *hstack = [[UIStackView alloc] init];
    hstack.axis = UILayoutConstraintAxisHorizontal;
    hstack.spacing = 10;
    hstack.alignment = UIStackViewAlignmentFill;
    hstack.distribution = UIStackViewDistributionFill;
    [self.view addSubview:hstack];
    
    [hstack addArrangedSubview:stack];
    [hstack addArrangedSubview:cssView];
    

    [hstack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.left.right.equalTo(self.view);
    }];
}


@end
