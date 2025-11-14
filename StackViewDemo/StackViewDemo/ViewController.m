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
    
    /*
        ( 0, 0, 20, 20)
        (14, 0, 20, 20)
        (34, 0, 20, 20)
     */
    
    
    self.view.backgroundColor = [UIColor cyanColor];
    // 1. 创建容器视图 (210x120)
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(50, 100, 48, 20)];
    containerView.backgroundColor = [UIColor clearColor]; // 白色背景便于观察
    [self.view addSubview:containerView];
    
    // 2. 创建两个圆形icon
    UIImageView *leftCircle = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    leftCircle.image = [UIImage imageNamed:@"tvu_cover_tiktok"];
//    leftCircle.layer.cornerRadius = 10.0f;
    
    
    UIImageView *rightCircle = [[UIImageView alloc] initWithFrame:CGRectMake(14, 0, 20, 20)];
    rightCircle.image = [UIImage imageNamed:@"tvu_cover_twitch"];
    
    UIImageView *thirdCircle = [[UIImageView alloc] initWithFrame:CGRectMake(28, 0, 20, 20)];
    thirdCircle.image = [UIImage imageNamed:@"tvu_cover_youtube"];
    [containerView addSubview:thirdCircle];
    [containerView addSubview:rightCircle];
    [containerView addSubview:leftCircle];
    
    // 3. 创建mask图片 - 向右的半圆弧
    UIImage *maskImage = [self createRightFacingSemiArcMaskImage];
    
    // 4. 创建CAShapeLayer作为mask
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.contents = (id)maskImage.CGImage;
    maskLayer.frame = CGRectMake(0, 0, 48, 20); // mask应用到leftCircle的bounds
    
    // 5. 应用mask到leftCircle
    containerView.layer.mask = maskLayer;

}


// 创建向右的半圆弧mask图片
- (UIImage *)createRightFacingSemiArcMaskImage {
    // 容器尺寸
    CGSize containerSize = CGSizeMake(48, 20);
    
    // 创建图形上下文
    UIGraphicsBeginImageContextWithOptions(containerSize, NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 1. 先填充白色（不透明区域）
    CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextFillRect(ctx, CGRectMake(0, 0, containerSize.width, containerSize.height));
        
    // 5. 创建完整的半圆环路径
    UIBezierPath *semiArcPath  = [self archPathWithCenter:CGPointMake(10, 10) radius:10 width:2 ctx:ctx];
    UIBezierPath *semiArcPath1 = [self archPathWithCenter:CGPointMake(24, 10) radius:10 width:2 ctx:ctx];
    
    // 6. 设置透明色（清除模式） - 让半圆弧区域透明
    CGContextSetBlendMode(ctx, kCGBlendModeClear);
    CGContextSetFillColorWithColor(ctx, [UIColor clearColor].CGColor);
    
    // 7. 填充半圆弧区域
    CGContextAddPath(ctx, semiArcPath.CGPath);
    CGContextAddPath(ctx, semiArcPath1.CGPath);
    CGContextFillPath(ctx);
    
    // 8. 获取生成的图片
    UIImage *maskImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return maskImage;
}

- (UIBezierPath *)archPathWithCenter:(CGPoint)center
                              radius:(CGFloat)radius
                               width:(CGFloat)width
                                 ctx:(CGContextRef)ctx {
    // 计算内外半径
    CGFloat outerRadius = radius + width;
    CGFloat innerRadius = radius;
    
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

    return semiArcPath;
}


@end


