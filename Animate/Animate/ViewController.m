//
//  ViewController.m
//  Animate
//
//  Created by erfeixia on 2025/11/25.
//

#import "ViewController.h"
#import "UIButton+CustomAnimation.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(120, 200, 160, 60);
    [btn setTitle:@"点我果冻!" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:22];
    btn.backgroundColor = [UIColor systemBlueColor];
    [btn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    btn.layer.cornerRadius = 12;
    [self.view addSubview:btn];
    
    [btn addTarget:self action:@selector(onJellyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onJellyButtonClick:(UIButton *)sender {
    [sender wl_addJellyAnimation];
    
    // 你的业务逻辑...
}


@end
