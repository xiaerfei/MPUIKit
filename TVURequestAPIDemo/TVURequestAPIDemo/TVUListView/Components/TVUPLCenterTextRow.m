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
        self.textLabel.text = [data[@"text"] toStringValue];
    } else {
        self.textLabel.text = @"";
    }
}

#pragma mark - Private Methods
- (void)configureUI {
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.textColor = [UIColor whiteColor];
    self.textLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.textLabel];
        
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
    }];
}
@end
