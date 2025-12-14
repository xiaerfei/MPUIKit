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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.plContentView.backgroundColor = [UIColor clearColor];
    });
}
// 触摸结束（松开）
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.plContentView.backgroundColor = [UIColor clearColor];
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
    
    self.plContentView = [[UIView alloc] init];
    [self addSubview:self.plContentView];
    
    [self.plContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
//    self.indicatorImageView = [[UIImageView alloc] init];
//    self.indicatorImageView.image = [UIImage systemImageNamed:@"chevron.forward"];
//    self.indicatorImageView.tintColor = [UIColor lightGrayColor];
//    [self.plContentView addSubview:self.indicatorImageView];
//    
//    [self.indicatorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.plContentView);
//        make.right.equalTo(self.plContentView).offset(-20);
//    }];
    self.indicatorImageView.hidden = YES;
}
@end
