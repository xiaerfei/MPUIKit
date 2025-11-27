//
//  ViewController.m
//  StackViewDemo
//
//  Created by erfeixia on 2025/11/8.
//

#import "ViewController.h"

// 全局宏（建议放在PCH或头文件中，若已定义可忽略）
#ifndef TVUColorWithRHedix
#define TVUColorWithRHedix(hex) [UIColor colorWithRed:((hex >> 16) & 0xFF)/255.0 green:((hex >> 8) & 0xFF)/255.0 blue:(hex & 0xFF)/255.0 alpha:1.0]
#endif

#ifndef TVUColorWithRHedixA
#define TVUColorWithRHedixA(hex) [UIColor colorWithRed:((hex >> 24) & 0xFF)/255.0 green:((hex >> 16) & 0xFF)/255.0 blue:((hex >> 8) & 0xFF)/255.0 alpha:(hex & 0xFF)/255.0]
#endif


@interface ViewController () <UITabBarDelegate>
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIButton *testButton;

@property (nonatomic, strong) UIVisualEffectView *visualEffectView;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (weak, nonatomic) IBOutlet UITabBar *tabBarTop;

@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.3];
    
    if (@available(iOS 26.0, *)) {
        // iOS 26 新增 Liquid Glass 效果
        UIGlassEffect *glassEffect = [UIGlassEffect effectWithStyle:UIGlassEffectStyleClear];
        glassEffect.tintColor = [[UIColor purpleColor] colorWithAlphaComponent:0.1];
        glassEffect.interactive = YES;
        self.visualEffectView = [[UIVisualEffectView alloc] initWithEffect:glassEffect];
        self.visualEffectView.layer.cornerRadius = 20;
        self.visualEffectView.clipsToBounds = YES;
        self.visualEffectView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.visualEffectView];
        self.visualEffectView.frame = CGRectMake(20, 100, 200, 200);
        
        
        // 使用 Liquid Glass 按钮配置
        UIButtonConfiguration *config = [UIButtonConfiguration clearGlassButtonConfiguration];
        config.title = @"喜欢";
        config.image = [UIImage systemImageNamed:@"heart"];
        
        UIButton *button = [UIButton buttonWithConfiguration:config primaryAction:nil];
        button.frame = CGRectMake(20, 100, 100, 50);
        [self.view addSubview:button];
    }
    [self clearCornerRadius:self.tabBar];
    [self clearCornerRadius:self.tabBarTop];
    
    self.tabBar.selectionIndicatorImage = nil;
    self.tabBarTop.selectionIndicatorImage = nil;
    
    self.tabBar.delegate = self;
    self.tabBarTop.delegate = self;
    
    self.tabBar.tintColor = [UIColor whiteColor];
    self.tabBarTop.tintColor = [UIColor whiteColor];
    self.tabBar.barTintColor = [UIColor clearColor];
    self.tabBarTop.barTintColor = [UIColor clearColor];
    
    if (@available(iOS 13.0, *)) {
        UITabBarAppearance *appearance = [[UITabBarAppearance alloc] init];
        [appearance configureWithOpaqueBackground];
        
        // 设置未选中背景颜色
        appearance.stackedLayoutAppearance.normal.badgeBackgroundColor = [UIColor clearColor];
        
        // 设置选中背景颜色
        appearance.stackedLayoutAppearance.selected.badgeBackgroundColor = [UIColor systemRedColor];
        
        // 如果要禁用液态玻璃效果 (iOS 26 新增)
        appearance.backgroundEffect = nil;
        appearance.shadowColor = [UIColor clearColor];
        
        // 应用到 TabBar
        self.tabBar.standardAppearance = appearance;
        self.tabBarTop.standardAppearance = appearance;
        if (@available(iOS 15.0, *)) {
            self.tabBar.scrollEdgeAppearance = appearance;
            self.tabBarTop.scrollEdgeAppearance = appearance;
        }
    }
}

- (void)clearCornerRadius:(UITabBar *)tabBar {
    tabBar.layer.cornerRadius = 0;
    tabBar.layer.masksToBounds = YES;
    
    for (UIView *view in tabBar.subviews) {
        view.layer.cornerRadius = 0;
        view.layer.masksToBounds = YES;
    }
}


- (void)configureButton {
    UIButtonConfiguration *config = [UIButtonConfiguration plainButtonConfiguration];
    // 关键：不要设置 baseForegroundColor（会覆盖富文本颜色）
    config.baseForegroundColor = [UIColor clearColor]; // 注释掉！
    config.baseBackgroundColor = [UIColor clearColor];
    NSAttributedString *normal = [self normalAttributedTitle];
    NSAttributedString *highlighted = [self highlightedAttributedTitle];
    config.attributedTitle = normal;
    self.testButton.configuration = config;
    self.testButton.configurationUpdateHandler = ^(__kindof UIButton * _Nonnull button) {
        if (button.state == UIControlStateHighlighted) {
            config.attributedTitle = highlighted;
        } else {
            config.attributedTitle = normal;
        }
        button.configuration = config;
    };
}


- (NSAttributedString *)normalAttributedTitle {
    NSMutableAttributedString *normalAttri = [[NSMutableAttributedString alloc] initWithString:@"Go to Stream Info"];
    
    NSRange rang0 = [normalAttri.string rangeOfString:@"Go to"];
    if (rang0.location == NSNotFound) return normalAttri.copy;
    
    NSRange rang1 = [normalAttri.string rangeOfString:@"Stream Info"];
    if (rang1.location == NSNotFound) return normalAttri.copy;
    
    // 配置"Go to"样式
    [normalAttri addAttributes:@{
        NSForegroundColorAttributeName : TVUColorWithRHedix(0x9E9E9E),
        NSFontAttributeName : [UIFont systemFontOfSize:14],
    } range:rang0];
    
    // 配置"Stream Info"基础样式（根据enabled状态）
    UIColor *normalColor = self.testButton.enabled ? TVUColorWithRHedix(0x2FB54E) : [UIColor grayColor];
    [normalAttri addAttributes:@{
        NSForegroundColorAttributeName : normalColor,
        NSFontAttributeName : [UIFont systemFontOfSize:14],
        NSUnderlineColorAttributeName : normalColor,
        NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle),
    } range:rang1];
    
    return normalAttri.copy;
}

- (NSAttributedString *)highlightedAttributedTitle {
    NSMutableAttributedString *highlightedAttri = [[NSMutableAttributedString alloc] initWithString:@"Go to Stream Info"];
    
    NSRange rang0 = [highlightedAttri.string rangeOfString:@"Go to"];
    if (rang0.location == NSNotFound) return highlightedAttri.copy;
    
    NSRange rang1 = [highlightedAttri.string rangeOfString:@"Stream Info"];
    if (rang1.location == NSNotFound) return highlightedAttri.copy;
    
    // 配置"Go to"样式
    [highlightedAttri addAttributes:@{
        NSForegroundColorAttributeName : TVUColorWithRHedix(0x9E9E9E),
        NSFontAttributeName : [UIFont systemFontOfSize:14],
    } range:rang0];
    
    [highlightedAttri addAttributes:@{
        NSForegroundColorAttributeName : TVUColorWithRHedixA(0x2FB54E32),
        NSUnderlineColorAttributeName : TVUColorWithRHedixA(0x2FB54E32),
        NSFontAttributeName : [UIFont systemFontOfSize:14],
        NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle),
    } range:rang1];
    
    return highlightedAttri.copy;
}


#pragma makr - UITabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    item.selectedImage = nil;
}

@end


