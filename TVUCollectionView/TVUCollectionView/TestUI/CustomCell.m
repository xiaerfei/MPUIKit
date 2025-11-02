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
}

- (void)updateWithData:(id)data {
    self.textLabel.text = data;
}
@end

