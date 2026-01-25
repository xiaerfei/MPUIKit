//
//  TVUPLDefaultView.m
//  StaticViewDemo
//
//  Created by erfeixia on 2025/12/14.
//

#import "TVUPLDefaultView.h"
#import "TVUPLListConst.h"
#import "TVUPLRow.h"
#import "Masonry.h"
// 布局常量（可根据需求调整）
@interface TVUPLDefaultView ()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIStackView *hStackView;
@property (nonatomic, strong) UIStackView *vStackView;
@end

@implementation TVUPLDefaultView
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
- (void)updateWithRowData:(TVUPLRow *)rowData {
    TVUPLImageData *imageData = [rowData customForKey:kTVUPLDataImage];
    [imageData configure:self.iconImageView];
    self.iconImageView.hidden = self.iconImageView.image == nil;
    if (self.iconImageView.hidden == NO) {
        CGFloat width = imageData.msize.width;
        if (width == 0) { width = 20; }
        [self.iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(width));
        }];
    }
    
    TVUPLLabelData *titleData = [rowData customForKey:kTVUPLDataTitle];
    [titleData configure:self.titleLabel];
    
    TVUPLLabelData *subtitleData = [rowData customForKey:kTVUPLDataSubtitle];
    [subtitleData configure:self.subtitleLabel];
}


#pragma mark - Private Methods
- (void)setupSubviews {
    self.hStackView = [self createStackViewWithAxis:UILayoutConstraintAxisHorizontal];
    self.hStackView.spacing = 5;
    [self addSubview:self.hStackView];
    
    // 图标
    self.iconImageView = [[UIImageView alloc] init];
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.hStackView addArrangedSubview:self.iconImageView];
    
    self.vStackView = [self createStackViewWithAxis:UILayoutConstraintAxisVertical];
    [self.hStackView addArrangedSubview:self.vStackView];
    
    UIView *backContent = [[UIView alloc] init];
    UIView *textContent = [[UIView alloc] init];
    // 标题
    self.titleLabel = [[UILabel alloc] init];
    // 默认样式
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.numberOfLines = 0;
    [textContent addSubview:self.titleLabel];
    
    
    // 副标题
    self.subtitleLabel = [[UILabel alloc] init];
    self.subtitleLabel.numberOfLines = 0;
    // 默认样式
    self.subtitleLabel.font = [UIFont systemFontOfSize:13];
    self.subtitleLabel.textColor = [UIColor grayColor];
    [textContent addSubview:self.subtitleLabel];
    
    [backContent addSubview:textContent];
    [self.vStackView addArrangedSubview:backContent];
}

- (void)setupConstraints {
    
    [self.hStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self);
    }];
    
    // 图标约束（默认大小20x20）
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@20);
    }];
    
    UIView *textContent = self.titleLabel.superview;
    UIView *backContent = textContent.superview;
    [textContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(backContent);
        make.centerY.equalTo(backContent);
        make.top.greaterThanOrEqualTo(backContent.mas_top).offset(5);
        make.bottom.lessThanOrEqualTo(backContent.mas_bottom).offset(-5);
    }];
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(textContent);
        make.bottom.equalTo(self.subtitleLabel.mas_top);
    }];
    
    [self.subtitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.left.bottom.right.equalTo(textContent);
    }];
}
#pragma mark - Private Methods
- (UIStackView *)createStackViewWithAxis:(UILayoutConstraintAxis)axis {
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.axis = axis;  // 垂直排列
    stackView.spacing = 0;  // 每个项之间的间隔
    stackView.alignment = UIStackViewAlignmentFill;  // 填充子视图
    stackView.distribution = UIStackViewDistributionFill;  // 填充整个空间
    return stackView;
}

@end
