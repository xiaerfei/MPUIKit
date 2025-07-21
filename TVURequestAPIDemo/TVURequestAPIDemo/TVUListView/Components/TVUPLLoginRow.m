//
//  TVUPLLoginRow.m
//  TVURequestAPIDemo
//
//  Created by TVUM4Pro on 2025/7/21.
//

#import "TVUPLLoginRow.h"

@implementation TVUPLLoginRow
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
    if ([data isDictionary] == NO) return;
    self.nameLabel.text = [data[@"name"] toStringValue];
    self.emailLabel.text = [data[@"email"] toStringValue];
    self.firstWordLabel.text = [data[@"first"] toStringValue];
}

#pragma mark - Private Methods
- (void)configureUI {
    UIView *firstWordView = [[UIView alloc] init];
    firstWordView.backgroundColor = [UIColor colorWithRed:82.0f/255.0f
                                                    green:80.0f/255.0f
                                                     blue:236.0f/255.0f
                                                    alpha:1];
    firstWordView.layer.cornerRadius = 25;
    firstWordView.layer.masksToBounds = YES;
    [self addSubview:firstWordView];
    
    self.firstWordLabel = [[UILabel alloc] init];
    self.firstWordLabel.textColor = [UIColor whiteColor];
    self.firstWordLabel.font = [UIFont systemFontOfSize:25];
    [firstWordView addSubview:self.firstWordLabel];

    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel.textColor = [UIColor whiteColor];
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.nameLabel];
    
    self.emailLabel = [[UILabel alloc] init];
    self.emailLabel.textColor = [UIColor whiteColor];
    self.emailLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.emailLabel];
    
    [firstWordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.top.equalTo(self).offset(5).priorityHigh();
        make.bottom.equalTo(self).offset(-5).priorityHigh();
        make.width.height.mas_equalTo(50).priorityHigh();
    }];
    
    [self.firstWordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(firstWordView);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(firstWordView.mas_right).offset(5);
        make.top.equalTo(firstWordView.mas_top);
        make.height.mas_equalTo(25);
    }];
    
    [self.emailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(firstWordView.mas_right).offset(5);
        make.bottom.equalTo(firstWordView.mas_bottom);
        make.height.mas_equalTo(25);
    }];
}

@end
