//
//  UIView+AutoLayoutHelper.m
//  TVUCollectionView
//
//  Created by TVUM4Pro on 2025/12/12.
//

#import "UIView+AutoLayoutHelper.h"

@implementation UIView (AutoLayoutHelper)

- (void)applyPreferredMaxLayoutWidthToAllLabels {
    // 1. 如果自己就是 Label，且是多行模式，则设置
    if ([self isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)self;
        CGFloat width = label.bounds.size.width;
        // 只有当 label 需要多行显示 (numberOfLines = 0 或 >1)
        // 且当前宽度有效 (>0) 时才设置
        if (width > 0) {
            label.preferredMaxLayoutWidth = width;
            CGSize size = [label sizeThatFits:CGSizeMake(width, 100)];
            NSLog(@"lable frame:%@ fits:%@", NSStringFromCGRect(self.frame), NSStringFromCGSize(size));
        }
    }
    
    // 2. 递归遍历所有子视图
    for (UIView *subview in self.subviews) {
        [subview applyPreferredMaxLayoutWidthToAllLabels];
    }
}

- (void)autoLayoutUI {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    for (UIView *subview in self.subviews) {
        [subview autoLayoutUI];
    }
}




@end
