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

@implementation TVUPLBaseRow
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
@end
