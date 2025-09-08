//
//  TVUPLUnLoginRow.m
//  TVURequestAPIDemo
//
//  Created by TVUM4Pro on 2025/7/21.
//

#import "TVUPLUnLoginRow.h"

@implementation TVUPLUnLoginRow
@synthesize didSelectedBlock;

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configureUI];
    }
    return self;
}

#pragma mark - TVUPLRowProtocol
- (void)reloadWithData:(nonnull id)data {
    if ([data isDictionary]) {
        self.titleLabel.text = [data[kTVUPLRowTitle] toStringValue];
    } else {
        self.titleLabel.text = @"";
    }
}

#pragma mark - Private Methods
- (void)configureUI {
    // 创建配置对象
    UIImageSymbolConfiguration *config =
    [UIImageSymbolConfiguration configurationWithPointSize:15
                                                    weight:UIImageSymbolWeightRegular
                                                     scale:UIImageSymbolScaleLarge];
    
    // 获取带配置的图标
    UIImage *icon = [UIImage systemImageNamed:@"person.circle" withConfiguration:config];
    
    // 设置图标颜色
    self.unLoginImageView = [[UIImageView alloc] initWithImage:icon];
    self.unLoginImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.unLoginImageView.tintColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8];
    [self addSubview:self.unLoginImageView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.titleLabel];
    
    [self.unLoginImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self).offset(5).priorityHigh();
        make.bottom.equalTo(self).offset(-5).priorityHigh();
        make.width.height.mas_equalTo(50).priorityHigh();
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.unLoginImageView.mas_right).offset(5);
    }];
}


@end
