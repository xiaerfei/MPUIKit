//
//  TVUPLButtonRow.m
//  TVUIRLSDK
//
//  Created by TVUM4Pro on 2025/8/28.
//

#import "TVUPLButtonRow.h"

@implementation TVUPLButtonRow
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
    NSString *imageName = [data[kTVUPLRowValue] toStringValue];
    UIImage *image = [UIImage imageNamed:imageName];
    [self.rightButton setImage:image forState:UIControlStateNormal];
}
#pragma mark - Private Methods
- (void)configureUI {
    self.rightButton = [[UIButton alloc] init];
    [self addSubview:self.rightButton];
    
    
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-15);
    }];
}

@end
