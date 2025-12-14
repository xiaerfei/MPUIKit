//
//  TVUPLTextRow.m
//  TVUCollectionView
//
//  Created by erfeixia on 2025/12/13.
//

#import "TVUPLTextRow.h"
#import "Masonry.h"
#import "TVUPLListConst.h"
#import "TVUPLDefaultCellView.h"
NSString *const kTVUPLTextRow = @"TVUPLTextRow";

@interface TVUPLTextRow ()
@property (nonatomic, strong) UILabel *textLabel;
@end

@implementation TVUPLTextRow
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
    // 标题
    self.textLabel = [[UILabel alloc] init];
    // 默认样式
    self.textLabel.font = [UIFont systemFontOfSize:15];
    self.textLabel.textColor = [UIColor whiteColor];
    self.textLabel.numberOfLines = 0;
    [self.plContentView addSubview:self.textLabel];
    self.textLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.bounds);
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.plContentView).offset(5);
        make.right.bottom.equalTo(self.plContentView).offset(-5);
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.bounds) - 10;
}


- (void)updateWithData:(NSDictionary *)data {
    self.textLabel.text = data[kTVUPLRowTitle];
}
@end
