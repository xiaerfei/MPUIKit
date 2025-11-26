//
//  UIButton+CustomAnimation.m
//  Animate
//
//  Created by erfeixia on 2025/11/25.
//

#import "UIButton+CustomAnimation.h"
#import <QuartzCore/QuartzCore.h>



@implementation UIButton (CustomAnimation)
- (void)wl_addJellyAnimation {
    // 初始缩放动画（按下瞬间）
    [UIView animateWithDuration:0.12
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
        self.transform = CGAffineTransformMakeScale(0.88, 0.88);
    } completion:^(BOOL finished) {

        // 使用弹簧动画回弹（果冻效果）
        [UIView animateWithDuration:0.45
                              delay:0
             usingSpringWithDamping:0.28   // 阻尼越小越Q弹
              initialSpringVelocity:10.0    // 初速度
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}

- (void)wl_addAdvancedJellyAnimation {
    // ==== Step 1. 按下瞬间的压扁 ====
    [UIView animateWithDuration:0.1
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
        self.transform = CGAffineTransformMakeScale(0.82, 0.88);
    } completion:^(BOOL finished) {

        // ==== Step 2. 回弹 + 弹性 ====
        [UIView animateWithDuration:0.55
                              delay:0
             usingSpringWithDamping:0.33
              initialSpringVelocity:12
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];

    
    // ==== Step 3. 左右摇摆（果冻摆动） ====
    CAKeyframeAnimation *shake = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    shake.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    shake.values = @[@0, @8, @-6, @4, @-2, @0];
    shake.duration = 0.45;
    [self.layer addAnimation:shake forKey:@"wl_jelly_shake"];

    
    // ==== Step 4. 轻微 3D 旋转（软体效果） ====
    CAKeyframeAnimation *rotate = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotate.values = @[@0, @(M_PI*0.02), @(-M_PI*0.015), @(M_PI*0.01), @0];
    rotate.duration = 0.45;
    rotate.additive = YES;
    rotate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [self.layer addAnimation:rotate forKey:@"wl_jelly_rotate"];
}


- (void)wl_addLiquidWaveAnimation {

    CGFloat w = self.bounds.size.width;
    CGFloat h = self.bounds.size.height;
    CGFloat r = MIN(w, h) / 2.0;

    // 按钮圆角（建议设置成更圆的按钮效果更漂亮）
    CGFloat cornerRadius = self.layer.cornerRadius;

    // ==== 1. 创建形状图层 ====
    CAShapeLayer *waveLayer = [CAShapeLayer layer];
    waveLayer.frame = self.bounds;
    waveLayer.fillColor = [UIColor clearColor].CGColor;
    waveLayer.strokeColor = [UIColor.whiteColor colorWithAlphaComponent:0.35].CGColor;
    waveLayer.lineWidth = 4;
    waveLayer.lineCap = kCALineCapRound;

    UIBezierPath *startPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:cornerRadius];
    waveLayer.path = startPath.CGPath;
    [self.layer addSublayer:waveLayer];


    // ==== 2. 波动路径（向外扩散 + 不规则液体边缘） ====
    UIBezierPath *finalPath = [UIBezierPath bezierPath];

    CGFloat waveOffset = 6;    // 波动幅度
    NSInteger segments = 40;   // 越多越圆滑

    for (NSInteger i = 0; i <= segments; i++) {
        CGFloat t = (CGFloat)i / segments;
        CGFloat angle = t * M_PI * 2;

        CGFloat baseX = cornerRadius + (w - 2*cornerRadius) * t;
        CGFloat baseY = h / 2.0;

        // 液体波动：sin + 小幅随机
        CGFloat xNoise = sin(angle * 3) * waveOffset + (arc4random_uniform(4) - 2);
        CGFloat yNoise = cos(angle * 5) * waveOffset + (arc4random_uniform(4) - 2);

        CGFloat x = baseX + xNoise;
        CGFloat y = baseY + yNoise;

        if (i == 0)
            [finalPath moveToPoint:CGPointMake(x, y)];
        else
            [finalPath addLineToPoint:CGPointMake(x, y)];
    }
    [finalPath closePath];


    // ==== 3. 动画：从正常按钮边缘 → 液体波动边缘 ====
    CABasicAnimation *pathAni = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAni.fromValue = (__bridge id)startPath.CGPath;
    pathAni.toValue = (__bridge id)finalPath.CGPath;
    pathAni.duration = 0.28;
    pathAni.autoreverses = YES;
    pathAni.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];

    [waveLayer addAnimation:pathAni forKey:@"wl_liquid_wave"];


    // ==== 4. 透明度动画：淡入淡出（让波动更柔和） ====
    CABasicAnimation *fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fade.fromValue = @1.0;
    fade.toValue = @0.0;
    fade.duration = 0.4;
    fade.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    fade.removedOnCompletion = NO;
    fade.fillMode = kCAFillModeForwards;

    [waveLayer addAnimation:fade forKey:@"wl_liquid_fade"];


    // 自动移除图层
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
        [waveLayer removeFromSuperlayer];
    });
}

@end
