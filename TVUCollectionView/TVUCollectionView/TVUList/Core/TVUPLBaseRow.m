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

- (void)layoutSubviews {
    [super layoutSubviews]; // 必须先调用父类方法，确保系统默认布局完成
    // 调整 contentView 的 frame（例如：缩小 10pt 边距）
    self.contentView.frame = CGRectInset(self.bounds, self.plrow.rInsets.left, self.plrow.rInsets.right);
}

- (void)sendEventInfo:(id)info {
    if (self.plrow.rDidSelectedBlock) {
        self.plrow.rDidSelectedBlock(self.plrow, info);
    }
}

- (void)updateWithData:(id)data { }

#pragma mark - Private Methods
- (void)configureLine {
    UIView *line = [UIView new];
    [self.contentView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(@1);
    }];
    
    line.backgroundColor = [[UIColor lightTextColor] colorWithAlphaComponent:0.1];
    
    self.lineView = line;
}
@end
