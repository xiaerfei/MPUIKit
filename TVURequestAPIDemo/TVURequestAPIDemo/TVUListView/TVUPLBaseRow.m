//
//  TVUPLBaseRow.m
//  TVURequestAPIDemo
//
//  Created by erfeixia on 2025/7/19.
//

#import "TVUPLBaseRow.h"
#import "TVUPLListView.h"
@interface TVUPLRow ()
@property (nonatomic, strong) UIView *backView;
@end

@interface TVUPLBaseRow () <UIGestureRecognizerDelegate>
@property (nonatomic, assign) UIGestureRecognizerState currentState;
@end

@implementation TVUPLBaseRow

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configureBaseUI];
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (self.row.unselectedStyle == NO) {
        self.row.backView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.1];
    }
    self.currentState = UIGestureRecognizerStateBegan;
    NSLog(@"sharexia: touch began");
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if (self.row.unselectedStyle == NO) {
        self.row.backView.backgroundColor = [UIColor clearColor];
    }
    NSLog(@"sharexia: touch ended");
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    if (self.row.unselectedStyle == NO) {
        self.row.backView.backgroundColor = [UIColor clearColor];
    }
    NSLog(@"sharexia: touch cancelled");
    self.currentState = UIGestureRecognizerStateCancelled;
}

#pragma mark - Private Methods
- (void)setShowIndicator:(BOOL)showIndicator {
    _showIndicator = showIndicator;
    if (showIndicator) {
        // 创建配置对象
        UIImageSymbolConfiguration *config =
        [UIImageSymbolConfiguration configurationWithPointSize:15
                                                        weight:UIImageSymbolWeightMedium
                                                         scale:UIImageSymbolScaleMedium];
        
        // 获取带配置的图标
        UIImage *icon = [UIImage systemImageNamed:@"chevron.right" withConfiguration:config];
        
        // 设置图标颜色
        UIImageView *iconView = [[UIImageView alloc] initWithImage:icon];
        iconView.tintColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
        [self addSubview:iconView];
        
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-5);
        }];
        self.indicatorImageView = iconView;
    } else {
        [self.indicatorImageView removeFromSuperview];
        self.indicatorImageView = nil;
    }
}

- (void)configureBaseUI {
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPressGesture:)];
    gesture.delegate = self;
    [self addGestureRecognizer:gesture];
}

- (void)tapPressGesture:(UIGestureRecognizer *)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateEnded:
        {
            if (self.row.unselectedStyle == NO &&
                (self.row.backView.backgroundColor != [UIColor clearColor] ||
                 self.currentState == UIGestureRecognizerStatePossible)) {
                [UIView animateWithDuration:0.25 animations:^{
                    self.row.backView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.1];
                } completion:^(BOOL finished) {
                    self.row.backView.backgroundColor = [UIColor clearColor];
                }];
            }
            if (self.currentState == UIGestureRecognizerStateBegan ||
                self.currentState == UIGestureRecognizerStatePossible) {
                if (self.row.unselected == NO &&
                    self.row.didSelectedBlock) {
                    self.row.didSelectedBlock(self.row, nil);
                }
                NSLog(@"sharexia:gesture ended");
            }
            self.currentState = UIGestureRecognizerStatePossible;
            break;
        }
        default:
        {
            if (self.row.unselectedStyle == NO) {
                self.row.backView.backgroundColor = [UIColor clearColor];
            }
            self.currentState = UIGestureRecognizerStateCancelled;
            NSLog(@"sharexia:gesture cancelled");
            break;
        }
    }
}

// 允许手势共存
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    // 如果是UIScrollView的pan手势，允许同时识别
    if ([otherGestureRecognizer.view isKindOfClass:[UIScrollView class]]) {
        return YES;
    }
    return NO;
}
@end
