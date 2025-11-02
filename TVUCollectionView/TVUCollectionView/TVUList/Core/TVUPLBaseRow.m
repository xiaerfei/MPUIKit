//
//  TVUPLBaseRow.m
//  TVUCollectionView
//
//  Created by erfeixia on 2025/9/13.
//

#import "TVUPLBaseRow.h"
#import "Masonry.h"

@implementation TVUPLBaseRow
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureLine];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self configureLine];
}



- (void)sendEventInfo:(id)info {
    
    
}

- (void)updateWithData:(id)data {
    
    
}

#pragma mark - Private Methods
- (void)configureLine {
    UIView *line = [UIView new];
    [self.contentView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@1);
    }];
    
    line.backgroundColor = [UIColor lightGrayColor];
    
    self.lineView = line;
}
@end
