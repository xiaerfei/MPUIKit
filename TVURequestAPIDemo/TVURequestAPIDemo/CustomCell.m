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
    // 创建文本标签，类似UITableViewCell的textLabel
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.textLabel.font = [UIFont systemFontOfSize:16];
    self.textLabel.textColor = UIColor.blackColor;
    [self.contentView addSubview:self.textLabel];
    
    // 添加约束，让文本标签左对齐，有边距
    [NSLayoutConstraint activateConstraints:@[
        [self.textLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:16],
        [self.textLabel.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor],
        [self.textLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-16]
    ]];
    
    // 添加底部边框，模拟表格分隔线
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

@end

