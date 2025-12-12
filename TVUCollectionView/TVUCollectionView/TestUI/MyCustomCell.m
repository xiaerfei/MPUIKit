//
//  MyCustomCell.m
//  TVUCollectionView
//
//  Created by TVUM4Pro on 2025/12/12.
//

#import "MyCustomCell.h"

@interface MyCustomCell ()

@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation MyCustomCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // 设置 cell 的背景色方便观察
        self.contentView.backgroundColor = [UIColor clearColor];
        // 初始化并配置 Label
        self.contentLabel = [[UILabel alloc] init];
        self.contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.contentLabel.numberOfLines = 0; // 允许多行显示
        self.contentLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.contentView.bounds); // 必须设置，以支持多行计算高度

        [self.contentView addSubview:self.contentLabel];

        // 添加 Auto Layout 约束
        [NSLayoutConstraint activateConstraints:@[
            // 约束 Label 到 contentView 的上下左右，并设置一定的边距
            [self.contentLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:10],
            [self.contentLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:10],
            [self.contentLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-10],
            [self.contentLabel.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-10]
        ]];
    }
    return self;
}

- (void)configureWithText:(NSString *)text {
    self.contentLabel.text = text;
    // 关键步骤：更新 preferredMaxLayoutWidth，它应等于最终 cell 的宽度减去水平边距
    CGFloat cellWidth = [UIScreen mainScreen].bounds.size.width;
    self.contentLabel.preferredMaxLayoutWidth = cellWidth - 20; // 屏幕宽度 - 左右边距 (10 + 10)
}

// 确保在 layoutSubviews 中更新 preferredMaxLayoutWidth 以适应旋转等情况
- (void)layoutSubviews {
    [super layoutSubviews];
    // 这个方法可以确保在 cell 布局时 preferredMaxLayoutWidth 是正确的
    CGFloat cellWidth = [UIScreen mainScreen].bounds.size.width;
    self.contentLabel.preferredMaxLayoutWidth = cellWidth - 20;
}

// 重写这个方法是 Self-Sizing Cells 的标准做法
- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    // 获取 contentView 根据 Auto Layout 计算出的最合适大小
    CGSize size = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    // 更新 attributes 的 frame size
    CGRect newFrame = layoutAttributes.frame;
    newFrame.size.height = size.height;
    layoutAttributes.frame = newFrame;
    return layoutAttributes;
}

@end
