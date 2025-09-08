//
//  TVUPLSwitchRow.m
//  TVURequestAPIDemo
//
//  Created by TVUM4Pro on 2025/7/21.
//

#import "TVUPLSwitchRow.h"
#import "TVUPLRow.h"
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
    [super reloadWithData:data];
    if ([data isDictionary] == NO) return;
    self.switchView.on = [[data[kTVUPLRowValue] toStringValue] boolValue];
    [self remakeSubtitleConstraints];
}

#pragma mark - Private Methods
- (void)configureUI {    
    self.switchView = [[UISwitch alloc] init];
    [self addSubview:self.switchView];
    
    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-15);
    }];
    
    [self.switchView addTarget:self action:@selector(switchAction:) forControlEvents:(UIControlEventValueChanged)];
}

- (void)switchAction:(UISwitch *)sender {
    if (self.row.didSelectedBlock) {
        self.row.didSelectedBlock(self.row, @{@"value" : @(sender.isOn)});        
    }
}
- (void)remakeSubtitleConstraints {
    if (self.subtitleLabel.hidden == NO) {
        BOOL showImage = (self.LeftImageView && self.LeftImageView.hidden == NO);
        [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(0);
            if (showImage) {
                make.left.equalTo(self.LeftImageView.mas_right).offset(5);
            } else {
                make.left.equalTo(self).offset(20);
            }
            make.right.equalTo(self.switchView.mas_left).offset(10);
        }];
    }
}

@end
