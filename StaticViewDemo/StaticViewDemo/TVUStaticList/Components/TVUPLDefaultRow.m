//
//  TVUPLDefaultRow.m
//  StaticViewDemo
//
//  Created by erfeixia on 2025/12/14.
//

#import "TVUPLDefaultRow.h"
#import "TVUPLDefaultView.h"
#import "TVUPLSection.h"
#import "Masonry.h"

NSString *const kTVUPLDefaultRow = @"TVUPLDefaultRow";

@interface TVUPLDefaultRow ()
@property (nonatomic, strong) TVUPLDefaultView *defaultView;
@end

@implementation TVUPLDefaultRow
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.defaultView = [[TVUPLDefaultView alloc] initWithFrame:CGRectZero];
    [self.plContentView addSubview:self.defaultView];
    
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.plContentView);
    }];
}

- (void)updateWithData:(NSDictionary *)data {
    [self.defaultView updateWithRowData:self.plrow];
}
@end
