//
//  TVUPLSwitchRow.m
//  TVURequestAPIDemo
//
//  Created by TVUM4Pro on 2025/7/21.
//

#import "TVUPLSwitchRow.h"

@implementation TVUPLSwitchRow
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
    self.textLabel.text = [data[@"text"] toStringValue];
    self.switchView.on = [[data[@"value"] toStringValue] boolValue];
}

#pragma mark - Private Methods
- (void)configureUI {
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.textColor = [UIColor whiteColor];
    self.textLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.textLabel];
    
    self.switchView = [[UISwitch alloc] init];
    [self addSubview:self.switchView];
    
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(20);
    }];
    
    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-10);
    }];
}

@end
