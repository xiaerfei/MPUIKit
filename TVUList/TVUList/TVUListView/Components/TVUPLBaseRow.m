//
//  TVUPLBaseRow.m
//  TVURequestAPIDemo
//
//  Created by erfeixia on 2025/7/19.
//

#import "TVUPLBaseRow.h"
#import "TVUPLListView.h"
#import "NSObject+BaseDataType.h"
@implementation TVUPLBaseRow
#pragma mark - Private Methods
- (void)setShowIndicator:(BOOL)showIndicator {
    _showIndicator = showIndicator;
    if (showIndicator) {
        UIImage *icon = nil;
        NSString *imageName = [self.row.rowData[kTVUPLRowIndicatorImage] toStringValue];
        if (imageName.length != 0) {
            icon = [UIImage imageNamed:imageName];
        } else {
            // 创建配置对象
            UIImageSymbolConfiguration *config =
            [UIImageSymbolConfiguration configurationWithPointSize:15
                                                            weight:UIImageSymbolWeightMedium
                                                             scale:UIImageSymbolScaleMedium];
            
            // 获取带配置的图标
            icon = [UIImage systemImageNamed:@"chevron.right" withConfiguration:config];
        }
        
        // 设置图标颜色
        UIImageView *iconView = [[UIImageView alloc] initWithImage:icon];
        if (self.row.indicatorColor) {
            iconView.tintColor = self.row.indicatorColor;
        } else {
            iconView.tintColor = TVUColorWithRHedix(0xDBDBDB);
        }
        [self addSubview:iconView];
        
        [iconView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-15);
        }];
        self.indicatorImageView = iconView;
    } else {
        [self.indicatorImageView removeFromSuperview];
        self.indicatorImageView = nil;
    }
}

- (void)reloadWithData:(NSDictionary *)data {
    if ([data isDictionary] == NO || data.count == 0) {
        [self createObjectWithType:0];
        return;
    }
    
    NSString *title     = [data[kTVUPLRowTitle] toStringValue];
    NSString *subtitle  = [data[kTVUPLRowSubtitle] toStringValue];
    NSString *imageName = [data[kTVUPLRowImage] toStringValue];
    BOOL isAutoHeight = self.row.height == 0;
    
    if (title.length != 0 && subtitle.length == 0 && imageName.length == 0) {
        /// 只有 title
        [self createObjectWithType:1];
        self.titleLabel.text = title;
        
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (isAutoHeight) {
                make.top.mas_equalTo(self).offset(5);
                make.bottom.mas_equalTo(self).offset(-5);
            } else {
                make.centerY.equalTo(self);
            }
            make.left.equalTo(self).offset(20);
        }];
        
    } else if (title.length != 0 && subtitle.length != 0 && imageName.length == 0) {
        /// 有 title 和 subtitle
        [self createObjectWithType:2];
        
        self.titleLabel.text = title;
        self.subtitleLabel.text = subtitle;
        
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).offset(-5);
            make.left.equalTo(self).offset(20);
        }];
        [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(0);
            make.left.equalTo(self).offset(20);
        }];
    } else if (title.length != 0 && subtitle.length == 0 && imageName.length != 0) {
        /// 有 title 和 image
        [self createObjectWithType:3];
        self.titleLabel.text = title;
        self.LeftImageView.image = [UIImage imageNamed:imageName];
        [self.LeftImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(20);
            // 3. 等宽高，且最大尺寸等于 image.size
            make.width.equalTo(self.LeftImageView.mas_height);
            make.width.lessThanOrEqualTo(@(self.LeftImageView.image.size.width));
            make.height.lessThanOrEqualTo(@(self.LeftImageView.image.size.height));
            // 4. 高度不超过父视图高度的 60%
            make.height.lessThanOrEqualTo(self.mas_height).multipliedBy(0.6);
        }];
        
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (isAutoHeight) {
                make.top.mas_equalTo(self).offset(5);
                make.bottom.mas_equalTo(self).offset(-5);
            } else {
                make.centerY.equalTo(self);
            }
            make.left.equalTo(self.LeftImageView.mas_right).offset(5);
        }];
        
    } else if (title.length != 0 && subtitle.length != 0 && imageName.length != 0) {
        /// 有 title、subtitle 和 image
        [self createObjectWithType:4];
        self.titleLabel.text = title;
        self.subtitleLabel.text = subtitle;
        self.LeftImageView.image = [UIImage imageNamed:imageName];
        [self.LeftImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(20);
            // 3. 等宽高，且最大尺寸等于 image.size
            make.width.equalTo(self.LeftImageView.mas_height);
            make.width.lessThanOrEqualTo(@(self.LeftImageView.image.size.width));
            make.height.lessThanOrEqualTo(@(self.LeftImageView.image.size.height));
            // 4. 高度不超过父视图高度的 60%
            make.height.lessThanOrEqualTo(self.mas_height).multipliedBy(0.6);
        }];
        
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).offset(-5);
            make.left.equalTo(self.LeftImageView.mas_right).offset(5);
        }];
        [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(0);
            make.left.equalTo(self.LeftImageView.mas_right).offset(5);
        }];
    }
}

/// 0: 非法
/// 1: 只有 title
/// 2: 有 title 和 subtitle
/// 3: 有 title 和 image
/// 4: 有 title、subtitle 和 image
- (void)createObjectWithType:(NSInteger)type {
    switch (type) {
        case 0:
        {
            self.subtitleLabel.hidden = YES;
            self.LeftImageView.hidden = YES;
            self.titleLabel.text = @"";
            break;
        }
        case 1:
        {
            if (self.titleLabel == nil) {
                self.titleLabel = [self createLabelWithIsSub:NO];
            }
            self.subtitleLabel.hidden = YES;
            self.LeftImageView.hidden = YES;
            break;
        }
        case 2:
        {
            if (self.titleLabel == nil) {
                self.titleLabel = [self createLabelWithIsSub:NO];
            }
            if (self.subtitleLabel == nil) {
                self.subtitleLabel = [self createLabelWithIsSub:YES];
            }
            self.subtitleLabel.hidden = NO;
            self.LeftImageView.hidden = YES;
            break;
        }
        case 3:
        {
            if (self.titleLabel == nil) {
                self.titleLabel = [self createLabelWithIsSub:NO];
            }
            if (self.LeftImageView == nil) {
                self.LeftImageView = [self createImageView];
            }
            
            self.subtitleLabel.hidden = YES;
            self.LeftImageView.hidden = NO;
            break;
        }
        case 4:
        {
            if (self.titleLabel == nil) {
                self.titleLabel = [self createLabelWithIsSub:NO];
            }
            if (self.subtitleLabel == nil) {
                self.subtitleLabel = [self createLabelWithIsSub:YES];
            }
            if (self.LeftImageView == nil) {
                self.LeftImageView = [self createImageView];
            }

            break;
        }
            
        default:
            break;
    }
    
    
}


- (UILabel *)createLabelWithIsSub:(BOOL)isSub {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = isSub ? TVUColorWithRHedix(0x9E9E9E) : [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:isSub ? 12 : 15];
    [self addSubview:label];
    return label;
}

- (UIImageView *)createImageView {
    UIImageView *view = [[UIImageView alloc] init];
    view.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:view];
    return view;
}

@end
