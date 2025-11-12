//
//  ViewController.m
//  StackViewDemo
//
//  Created by erfeixia on 2025/11/8.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *backView;

@end

@implementation ViewController {
    CALayer *maskLayer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor cyanColor];
    // 1. 创建容器视图 (210x120)
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(50, 100, 210, 120)];
    containerView.backgroundColor = [UIColor clearColor]; // 白色背景便于观察
    [self.view addSubview:containerView];
    
    // 2. 创建两个圆形icon
    UIView *leftCircle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
    leftCircle.backgroundColor = [UIColor redColor];
    leftCircle.layer.cornerRadius = 60.0f;
    
    UIView *rightCircle = [[UIView alloc] initWithFrame:CGRectMake(90, 0, 120, 120)];
    rightCircle.backgroundColor = [UIColor blueColor];
    rightCircle.layer.cornerRadius = 60.0f;
    
    [containerView addSubview:rightCircle]; // rightCircle覆盖在leftCircle上
    [containerView addSubview:leftCircle];
    
    // 3. 创建mask图片 - 向右的半圆弧
    UIImage *maskImage = [self createRightFacingSemiArcMaskImage];
    
    // 4. 创建CAShapeLayer作为mask
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.contents = (id)maskImage.CGImage;
    maskLayer.frame = containerView.bounds; // mask应用到leftCircle的bounds
    
    // 5. 应用mask到leftCircle
    containerView.layer.mask = maskLayer;

}


// 创建向右的半圆弧mask图片
- (UIImage *)createRightFacingSemiArcMaskImage {
    // 容器尺寸
    CGSize containerSize = CGSizeMake(210, 120);
    
    // 创建图形上下文
    UIGraphicsBeginImageContextWithOptions(containerSize, NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 1. 先填充白色（不透明区域）
    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextFillRect(ctx, CGRectMake(0, 0, containerSize.width, containerSize.height));
    
    // 2. 以(60, 60)为圆心，画向右的半圆弧，宽度为10
    CGPoint center = CGPointMake(60, 60); // leftCircle的圆心
    CGFloat borderWidth = 3.0f;
    CGFloat radius = 60.0f; // 半径，可以根据需要调整
    
    // 计算内外半径
    CGFloat outerRadius = 65;
    CGFloat innerRadius = 60;
    
    // 向右的半圆弧：从 -π/2 (270度) 到 π/2 (90度)
    CGFloat startAngle = -M_PI_2; // 270度，向下
    CGFloat endAngle = M_PI_2;   // 90度，向上
    
    // 3. 创建外半圆路径
    UIBezierPath *outerArcPath = [UIBezierPath bezierPath];
    [outerArcPath addArcWithCenter:center
                          radius:outerRadius
                      startAngle:startAngle
                        endAngle:endAngle
                       clockwise:YES];
    
    // 4. 创建内半圆路径
    UIBezierPath *innerArcPath = [UIBezierPath bezierPath];
    [innerArcPath addArcWithCenter:center
                         radius:innerRadius
                     startAngle:endAngle // 注意：内路径需要反向
                       endAngle:startAngle
                      clockwise:NO];
    
    // 5. 创建完整的半圆环路径
    UIBezierPath *semiArcPath = [UIBezierPath bezierPath];
    [semiArcPath appendPath:outerArcPath];
    [semiArcPath appendPath:innerArcPath];
    [semiArcPath closePath];
    
    // 6. 设置透明色（清除模式） - 让半圆弧区域透明
    CGContextSetBlendMode(ctx, kCGBlendModeClear);
    CGContextSetFillColorWithColor(ctx, [UIColor clearColor].CGColor);
    
    // 7. 填充半圆弧区域
    CGContextAddPath(ctx, semiArcPath.CGPath);
    CGContextFillPath(ctx);
    
    // 8. 获取生成的图片
    UIImage *maskImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return maskImage;
}

@end


