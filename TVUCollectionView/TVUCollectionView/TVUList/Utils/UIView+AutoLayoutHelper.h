//
//  UIView+AutoLayoutHelper.h
//  TVUCollectionView
//
//  Created by TVUM4Pro on 2025/12/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (AutoLayoutHelper)
// 递归遍历所有子视图，找到多行 Label 并设置 preferredMaxLayoutWidth
- (void)applyPreferredMaxLayoutWidthToAllLabels;
- (void)autoLayoutUI;
@end

NS_ASSUME_NONNULL_END
