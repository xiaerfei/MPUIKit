//
//  TVUPLTextRow.m
//  TVUCollectionView
//
//  Created by erfeixia on 2025/12/13.
//

#import "TVUPLTextRow.h"
#import "Masonry.h"
#import "TVUPLListConst.h"
#import "TVUPLIconTextView.h"
NSString *const kTVUPLTextRow = @"TVUPLTextRow";

@interface TVUPLTextRow ()
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) TVUPLIconTextView *defaultView;


@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UISwitch *toggleSwitch;
@end

@implementation TVUPLTextRow
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
    [self.plContentView addSubview:stack];
    
    [stack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.plContentView);
    }];
}

- (void)updateWithData:(NSDictionary *)data {
//    [self.defaultView updateWithData:data];
}

@end
