//
//  TVUPLIndicatorRow.m
//  TVURequestAPIDemo
//
//  Created by TVUM4Pro on 2025/7/21.
//

#import "TVUPLIndicatorRow.h"

@implementation TVUPLIndicatorRow
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
    self.textLabel.text  = [data[@"text"] toStringValue];
    self.valueLabel.text = [data[@"value"] toStringValue];
}
#pragma mark - Private Methods
- (void)configureUI {
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.textLabel];
    
    self.valueLabel = [[UILabel alloc] init];
    self.valueLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:self.valueLabel];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(20);
    }];
    
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-30);
    }];
}

@end
