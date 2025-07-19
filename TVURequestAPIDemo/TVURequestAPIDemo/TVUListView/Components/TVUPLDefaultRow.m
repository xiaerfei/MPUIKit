//
//  TVUPLDefaultRow.m
//  TVURequestAPIDemo
//
//  Created by TVUM4Pro on 2025/7/18.
//

#import "TVUPLDefaultRow.h"
#import "NSObject+BaseDataType.h"
#import "Masonry.h"

@interface TVUPLDefaultRow ()
@property (nonatomic, strong) UILabel *textLabel;
@end

@implementation TVUPLDefaultRow
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
}

#pragma mark - Private Methods
- (void)configureUI {
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.textLabel];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(20);
    }];
}
@end
