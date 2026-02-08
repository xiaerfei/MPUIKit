//
//  TVUPLBaseRow.m
//  StaticViewDemo
//
//  Created by erfeixia on 2025/12/14.
//

#import "TVUPLBaseRow.h"
#import "TVUPLSection.h"
#import "Masonry.h"

@interface TVUPLBaseRow ()
@property (nonatomic, strong, readwrite) UIView *plContentView;
@property (nonatomic, strong, readwrite) UIView *plBackgroundView;
@property (nonatomic, strong, readwrite) UIImageView *indicatorImageView;
@property (nonatomic, strong) UIView *heightView;
@property (nonatomic, strong) UIStackView *hBaseStackView;
@end

@implementation TVUPLBaseRow
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureBaseRowUI];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureBaseRowUI];
}
// 触摸开始（按下）
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if ([self isHeaderOrFooter]) return;
    self.plBackgroundView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.1];
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    if ([self isHeaderOrFooter]) return;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.plBackgroundView.backgroundColor = [UIColor clearColor];
    });
}
// 触摸结束（松开）
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if ([self isHeaderOrFooter]) return;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.plBackgroundView.backgroundColor = [UIColor clearColor];
    });
}

// 触摸取消（如滑动离开单元格）
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    self.plContentView.backgroundColor = [UIColor clearColor];
}
#pragma mark - Public Methods
- (void)sendEventInfo:(id)info {
    if (self.plrow.rDidSelectedBlock) {
        self.plrow.rDidSelectedBlock(self.plrow, info);
    }
}

- (void)updateWithData:(id)data { }
#pragma mark - Private Methods
- (void)configureBaseRowUI {
    UIView *line = [UIView new];
    [self addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@1);
    }];
    
    line.backgroundColor = [[UIColor lightTextColor] colorWithAlphaComponent:0.1];

    self.lineView = line;
    
    self.plBackgroundView = [[UIView alloc] init];
    self.plBackgroundView.mas_key = @"plBackgroundView";
    [self addSubview:self.plBackgroundView];
    
    [self.plBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.axis = UILayoutConstraintAxisHorizontal;  // 垂直排列
    stackView.spacing = 5;  // 每个项之间的间隔
    stackView.alignment = UIStackViewAlignmentFill;  // 填充子视图
    stackView.distribution = UIStackViewDistributionFill;  // 填充整个空间
    self.hBaseStackView = stackView;
    self.hBaseStackView.mas_key = @"hBaseStackView";
    [self.plBackgroundView addSubview:self.hBaseStackView];
    
    [self.hBaseStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.plBackgroundView);
    }];
    
    self.plContentView = [[UIView alloc] init];
    self.plContentView.mas_key = @"plContentView";
    [self.hBaseStackView addArrangedSubview:self.plContentView];
    
    
    self.indicatorImageView = [[UIImageView alloc] init];
    self.indicatorImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.indicatorImageView.image = [UIImage systemImageNamed:@"chevron.forward"];
    self.indicatorImageView.tintColor = [UIColor lightGrayColor];
    self.indicatorImageView.mas_key = @"indicator";
    [self.hBaseStackView addArrangedSubview:self.indicatorImageView];
    
    [self.indicatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@10);
    }];
    
    self.indicatorImageView.hidden = YES;
}

- (void)setPlrow:(TVUPLRow *)plrow {
    _plrow = plrow;
    TVUPLViewData *viewData = [plrow customForKey:kTVUPLDataRow];
    CGFloat left  = viewData.minsets.left;
    CGFloat right = viewData.minsets.right;
    [self.hBaseStackView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.plBackgroundView).offset(left);
        make.right.equalTo(self.plBackgroundView).offset(-right);
    }];
    self.indicatorImageView.hidden = !plrow.mshowIndicator;
}

- (BOOL)isHeaderOrFooter {
    TVUPLRowType type = self.plrow.rrowType;
    return type == TVUPLRowTypeHeader || type == TVUPLRowTypeFooter;
}

@end
