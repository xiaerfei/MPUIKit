//
//  TVUPLCenterTextRow.m
//  TVUAnywhere
//
//  Created by TVUM4Pro on 2025/7/21.
//

#import "TVUPLCenterTextRow.h"

@implementation TVUPLCenterTextRow
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
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.titleLabel];
        
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}
@end
