//
//  TVUPLDefaultView.m
//  TVUCollectionView
//
//  Created by erfeixia on 2025/11/15.
//

#import "TVUPLDefaultCellView.h"
#import "Masonry.h"

// 常量实现
NSString *const kTVUPLRowTitle          = @"RowTitle";
NSString *const kTVUPLRowTitleFont      = @"RowTitleFont";
NSString *const kTVUPLRowTitleColor     = @"RowTitleColor";
NSString *const kTVUPLRowTitleAlignment = @"RowTitleAlignment";
NSString *const kTVUPLRowTitleNumberOfLines = @"RowTitleNumberOfLines";

NSString *const kTVUPLRowSubtitle       = @"RowSubtitle";
NSString *const kTVUPLRowSubtitleFont   = @"RowSubtitleFont";
NSString *const kTVUPLRowSubtitleColor  = @"RowSubtitleColor";

NSString *const kTVUPLRowIcon           = @"RowIcon";
NSString *const kTVUPLRowSystemIcon     = @"RowSystemIcon";
NSString *const kTVUPLRowIconTintColor  = @"RowIconTintColor";
NSString *const kTVUPLRowIconSize       = @"RowIconSize";

// 布局常量（可根据需求调整）
static const CGFloat kIconLeftMargin = 0;      // 图标左边距
static const CGFloat kIconTitleSpacing = 10;    // 图标与标题间距
static const CGFloat kTitleRightMargin = 0;    // 标题右边距
static const CGFloat kTitleSubtitleSpacing = 0; // 标题与副标题间距
static const CGFloat kContentVerticalMargin = 5; // 内容上下边距



@interface TVUPLDefaultCellView ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@end


@implementation TVUPLDefaultCellView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupSubviews];
        [self setupConstraints];
    }
    return self;
}
#pragma mark - Public Methods
- (void)updateWithData:(NSDictionary *)data {
    // 1. 更新图标
    id iconValue = data[kTVUPLRowIcon];
    UIImage *iconImage = nil;
    if (iconValue) {
        iconImage = [self imageWithObj:iconValue isSystem:NO];
    } else {
        iconValue = data[kTVUPLRowSystemIcon];
        iconImage = [self imageWithObj:iconValue isSystem:YES];
    }
    UIColor *tintColor = data[kTVUPLRowIconTintColor];
    self.iconImageView.tintColor = [tintColor isKindOfClass:UIColor.class] ? tintColor : nil;
    self.iconImageView.image = iconImage;
    self.iconImageView.hidden = (iconImage == nil);
    
    // 2. 更新图标大小（默认20x20）
    NSValue *iconSizeValue = data[kTVUPLRowIconSize];
    CGSize iconSize = CGSizeMake(20, 20);
    if (iconSizeValue && [iconSizeValue isKindOfClass:[NSValue class]]) {
        CGSize tempSize = iconSizeValue.CGSizeValue;
        if (tempSize.width > 0 && tempSize.height > 0) {
            iconSize = tempSize;
        }
    }
    [self.iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(iconSize.width));
        make.height.equalTo(@(iconSize.height));
    }];
    
    // 3. 更新标题
    self.titleLabel.text = data[kTVUPLRowTitle];
    self.titleLabel.textAlignment = (NSTextAlignment)[data[kTVUPLRowTitleAlignment] integerValue];
    self.titleLabel.numberOfLines = [data[kTVUPLRowTitleAlignment] integerValue];
    // 标题字体（默认15）
    id titleFont = data[kTVUPLRowTitleFont];
    if ([titleFont isKindOfClass:[UIFont class]]) {
        self.titleLabel.font = data[kTVUPLRowTitleFont];
    } else if ([titleFont isKindOfClass:NSNumber.class]) {
        self.titleLabel.font = [UIFont systemFontOfSize:[titleFont floatValue]];
    } else {
        self.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    
    // 标题颜色（默认白色）
    if (data[kTVUPLRowTitleColor] && [data[kTVUPLRowTitleColor] isKindOfClass:[UIColor class]]) {
        self.titleLabel.textColor = data[kTVUPLRowTitleColor];
    } else {
        self.titleLabel.textColor = [UIColor whiteColor];
    }
    
    // 4. 更新副标题
    NSString *subtitle = data[kTVUPLRowSubtitle];
    self.subtitleLabel.text = subtitle;
    self.subtitleLabel.hidden = (subtitle.length == 0);
    
    // 副标题字体（默认13）
    if (data[kTVUPLRowSubtitleFont] && [data[kTVUPLRowSubtitleFont] isKindOfClass:[UIFont class]]) {
        self.subtitleLabel.font = data[kTVUPLRowSubtitleFont];
    } else {
        self.subtitleLabel.font = [UIFont systemFontOfSize:13];
    }
    
    // 副标题颜色（默认灰色）
    if (data[kTVUPLRowSubtitleColor] && [data[kTVUPLRowSubtitleColor] isKindOfClass:[UIColor class]]) {
        self.subtitleLabel.textColor = data[kTVUPLRowSubtitleColor];
    } else {
        self.subtitleLabel.textColor = [UIColor grayColor];
    }
    
    // 5. 动态更新布局
    [self updateLayoutConstraints];
}
#pragma mark - Private Methods
- (void)setupSubviews {
    // 图标
    self.iconImageView = [[UIImageView alloc] init];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.iconImageView];
    
    // 标题
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.numberOfLines = 1;
    // 默认样式
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.numberOfLines = 0;
    [self addSubview:self.titleLabel];
    
    // 副标题
    self.subtitleLabel = [[UILabel alloc] init];
    self.subtitleLabel.numberOfLines = 0;
    // 默认样式
    self.subtitleLabel.font = [UIFont systemFontOfSize:13];
    self.subtitleLabel.textColor = [UIColor grayColor];
    [self addSubview:self.subtitleLabel];
}

- (void)setupConstraints {
    // 图标约束（默认大小20x20）
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(kIconLeftMargin);
        make.centerY.equalTo(self);
        make.width.height.equalTo(@20);
    }];
    
    // 标题约束（初始状态，后续会根据内容动态调整）
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(kIconTitleSpacing);
        make.right.lessThanOrEqualTo(self).offset(-kTitleRightMargin);
        make.centerY.equalTo(self);
    }];
    
    // 副标题约束（初始隐藏状态）
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.titleLabel);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(kTitleSubtitleSpacing);
    }];
    self.subtitleLabel.hidden = YES;
}

- (void)updateLayoutConstraints {
    BOOL hasIcon = (self.iconImageView.image != nil);
    BOOL hasSubtitle = (self.subtitleLabel.text.length > 0);
    
    // 清除之前的约束
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {}];
    [self.subtitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {}];
    
    if (!hasIcon && !hasSubtitle) {
        // 情况1: 无图标 + 无副标题 → 只显示标题（居中）
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(kIconLeftMargin);
            make.centerY.equalTo(self);
            make.right.lessThanOrEqualTo(self).offset(-kTitleRightMargin);
            make.top.greaterThanOrEqualTo(self).offset(kContentVerticalMargin);
            make.bottom.lessThanOrEqualTo(self).offset(-kContentVerticalMargin);
        }];
    } else if (hasIcon && !hasSubtitle) {
        // 情况2: 有图标 + 无副标题 → 图标和标题上下居中
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageView.mas_right).offset(kIconTitleSpacing);
            make.centerY.equalTo(self);
            make.right.lessThanOrEqualTo(self).offset(-kTitleRightMargin);
            make.top.greaterThanOrEqualTo(self).offset(kContentVerticalMargin);
            make.bottom.lessThanOrEqualTo(self).offset(-kContentVerticalMargin);
        }];
    } else if (hasIcon && hasSubtitle) {
        // 情况3: 有图标 + 有副标题 → 正常显示（标题在上，副标题在下）
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageView.mas_right).offset(kIconTitleSpacing);
            make.right.lessThanOrEqualTo(self).offset(-kTitleRightMargin);
            make.top.greaterThanOrEqualTo(self).offset(kContentVerticalMargin);
            make.bottom.equalTo(self.mas_centerY);
        }];
        
        [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.titleLabel);
            make.top.equalTo(self.titleLabel.mas_bottom);
            make.bottom.lessThanOrEqualTo(self).offset(-kContentVerticalMargin);
        }];
    } else {
        // 情况4: 无图标 + 有副标题 → 标题在上，副标题在下（左对齐）
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(kIconLeftMargin);
            make.right.lessThanOrEqualTo(self).offset(-kTitleRightMargin);
            make.top.greaterThanOrEqualTo(self).offset(kContentVerticalMargin);
            make.bottom.equalTo(self.mas_centerY);
        }];
        
        [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.titleLabel);
            make.top.equalTo(self.titleLabel.mas_bottom);
            make.bottom.lessThanOrEqualTo(self).offset(-kContentVerticalMargin);
        }];
    }
    // 强制更新布局
    [self layoutIfNeeded];
}

- (UIImage *)imageWithObj:(id)obj isSystem:(BOOL)isSystem {
    if ([obj isKindOfClass:[UIImage class]]) {
        return obj;
    } else if ([obj isKindOfClass:[NSString class]]) {
        return isSystem ? [UIImage systemImageNamed:obj] : [UIImage imageNamed:obj];
    }
    return nil;
}


@end
