//
//  CustomCell.m
//  TVUList
//
//  Created by erfeixia on 2025/8/4.
//

#import "CustomCell.h"

@implementation CustomCell

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
    // 创建文本标签
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.textLabel.font = [UIFont systemFontOfSize:16];
    self.textLabel.textColor = UIColor.whiteColor;
    [self.contentView addSubview:self.textLabel];
    
    // 添加约束
    [NSLayoutConstraint activateConstraints:@[
        [self.textLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:16],
        [self.textLabel.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
        [self.textLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-16]
    ]];
    
    // 添加底部边框作为分隔线
    UIView *separatorLine = [[UIView alloc] init];
    separatorLine.translatesAutoresizingMaskIntoConstraints = NO;
    separatorLine.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
    [self.contentView addSubview:separatorLine];
    
    [NSLayoutConstraint activateConstraints:@[
        [separatorLine.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor],
        [separatorLine.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor],
        [separatorLine.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor],
        [separatorLine.heightAnchor constraintEqualToConstant:0.5]
    ]];
}

// 支持自动布局的尺寸计算
//- (CGSize)systemLayoutSizeFittingSize:(CGSize)targetSize withHorizontalFittingPriority:(UILayoutPriority)horizontalFittingPriority verticalFittingPriority:(UILayoutPriority)verticalFittingPriority {
//    CGSize size = [super systemLayoutSizeFittingSize:targetSize withHorizontalFittingPriority:UILayoutPriorityRequired verticalFittingPriority:verticalFittingPriority];
//    return CGSizeMake(targetSize.width, size.height);
//}

@end

