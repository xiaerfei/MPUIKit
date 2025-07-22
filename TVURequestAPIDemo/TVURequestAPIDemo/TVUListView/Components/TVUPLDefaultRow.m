//
//  TVUPLDefaultRow.m
//  TVURequestAPIDemo
//
//  Created by TVUM4Pro on 2025/7/18.
//

#import "TVUPLDefaultRow.h"

@interface TVUPLDefaultRow ()
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
    if ([data isDictionary]) {
        self.textLabel.text = [data[@"text"] toStringValue];
        self.valueLabel.text = [data[@"value"] toStringValue];
    } else {
        self.textLabel.text = @"";
        self.valueLabel.text = @"";
    }
}

#pragma mark - Private Methods
- (void)configureUI {
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.textColor = [UIColor whiteColor];
    self.textLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.textLabel];
    
    self.valueLabel = [[UILabel alloc] init];
    self.valueLabel.textColor = [UIColor colorWithRed:140.0f/255.0f
                                                green:140.0f/255.0f
                                                 blue:140.0f/255.0f
                                                alpha:1];
    self.valueLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.valueLabel];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(20);
    }];
    
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-20);
    }];
}
@end
