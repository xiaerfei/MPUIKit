//
//  TVUPLBaseRow.m
//  TVUCollectionView
//
//  Created by erfeixia on 2025/9/13.
//

#import "TVUPLBaseRow.h"
#import "TVUPLSection.h"
#import "Masonry.h"

@interface TVUPLBaseRow ()
@property (nonatomic, strong, readwrite) UIView *plContentView;
@property (nonatomic, strong, readwrite) UIImageView *indicatorImageView;
@property (nonatomic, strong) UIView *heightView;
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
    self.plContentView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.1];
}
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    self.plContentView.backgroundColor = [UIColor clearColor];
}
// 触摸结束（松开）
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    self.plContentView.backgroundColor = [UIColor clearColor];
}

// 触摸取消（如滑动离开单元格）
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    self.plContentView.backgroundColor = [UIColor clearColor];
}

- (void)sendEventInfo:(id)info {
    if (self.plrow.rDidSelectedBlock) {
        self.plrow.rDidSelectedBlock(self.plrow, info);
    }
}

- (void)updateWithData:(id)data { }

- (void)setPlrow:(TVUPLRow *)plrow {
    _plrow = plrow;
    
    CGFloat sleft  = plrow.rsection.rinsets.left;
    CGFloat sright = + plrow.rsection.rinsets.right;
    
    [self.plContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(sleft);
        make.right.equalTo(self.contentView).offset(-sright);
        make.top.bottom.equalTo(self.contentView);
    }];
    self.indicatorImageView.hidden = !plrow.rshowIndicator;
}

#pragma mark - Private Methods
- (void)configureBaseRowUI {
    self.heightView = [UIView new];
    self.heightView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.heightView];
    
    [self.heightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.contentView);
        make.width.equalTo(@1);
    }];
    
    UIView *line = [UIView new];
    [self.contentView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@1);
    }];
    
    line.backgroundColor = [[UIColor lightTextColor] colorWithAlphaComponent:0.1];

    self.lineView = line;
    
    self.plContentView = [[UIView alloc] init];
    [self.contentView addSubview:self.plContentView];
    
    [self.plContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.contentView);
    }];
    
    self.indicatorImageView = [[UIImageView alloc] init];
    self.indicatorImageView.image = [UIImage systemImageNamed:@"chevron.forward"];
    self.indicatorImageView.tintColor = [UIColor lightGrayColor];
    [self.plContentView addSubview:self.indicatorImageView];
    
    [self.indicatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.plContentView);
        make.right.equalTo(self.plContentView).offset(-20);
    }];
    self.indicatorImageView.hidden = YES;
    /// UIImageView 可能会被挤压,这里设置高优先级
    [self.indicatorImageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}

// 重写这个方法是 Self-Sizing Cells 的标准做法
- (UICollectionViewLayoutAttributes *)preferredLayoutAttributesFittingAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    // 获取 contentView 根据 Auto Layout 计算出的最合适大小
    CGSize size = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    // 更新 attributes 的 frame size
    CGRect newFrame = layoutAttributes.frame;
    if (self.plrow.rHeight == 0) {
        newFrame.size.height = size.height;
    } else {
        newFrame.size.height = self.plrow.rHeight;
    }
    layoutAttributes.frame = newFrame;
    return layoutAttributes;
}

@end
