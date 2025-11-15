//
//  TVUPLDefaultRow.m
//  TVUCollectionView
//
//  Created by erfeixia on 2025/11/5.
//

#import "TVUPLDefaultRow.h"
#import "TVUPLDefaultCellView.h"
#import "Masonry.h"

NSString *const kTVUPLDefaultRow = @"TVUPLDefaultRow";

@interface TVUPLDefaultRow ()
@property (nonatomic, strong) TVUPLDefaultCellView *defaultView;
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
    self.defaultView = [[TVUPLDefaultCellView alloc] initWithFrame:CGRectZero];
    [self.plContentView addSubview:self.defaultView];
    
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.plContentView);
    }];
}

- (void)updateWithData:(NSDictionary *)data {
    [self.defaultView updateWithData:data];
    // 动态更新布局
    [self updateLayoutConstraints];
}

- (void)updateLayoutConstraints {
    BOOL showIndicator = self.plrow.rshowIndicator;
    [self.defaultView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.plContentView);
        if (showIndicator) {
            make.right.equalTo(self.indicatorImageView.mas_left);
        } else {
            make.right.equalTo(self.plContentView);
        }
    }];
}

@end
