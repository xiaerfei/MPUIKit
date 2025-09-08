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
    [super reloadWithData:data];
    if ([data isDictionary]) {
        self.valueLabel.text = [data[kTVUPLRowValue] toStringValue];
        [self remakeValueConstraints];
    } else {
        self.valueLabel.text = @"";
    }
}

#pragma mark - Private Methods
- (void)configureUI {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.titleLabel];
    
    self.valueLabel = [[UILabel alloc] init];
    self.valueLabel.textColor = [UIColor colorWithRed:140.0f/255.0f
                                                green:140.0f/255.0f
                                                 blue:140.0f/255.0f
                                                alpha:1];
    self.valueLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.valueLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(20);
    }];
    
    [self.valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-30);
    }];
}

- (void)remakeValueConstraints {
    if (self.indicatorImageView) {
        [self.valueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self.indicatorImageView.mas_left).offset(-10);
        }];
    }
}

@end
