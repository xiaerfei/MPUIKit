//
//  SectionBackViewLayout.h
//  TVUList
//
//  Created by erfeixia on 2025/8/4.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN
extern NSString * const kSectionBackView;

@protocol SectionBackgroundCollectionViewLayoutDelegate <UICollectionViewDelegate>
@optional

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
           sizeInSection:(NSInteger)section;
@end
@interface SectionBackViewLayout : UICollectionViewFlowLayout
// 默认header高度
@property (nonatomic, assign) CGFloat headerHeight;
// 默认header宽度（如果没有实现代理方法则使用此值）
@property (nonatomic, assign) CGFloat defaultHeaderWidth;
@end

NS_ASSUME_NONNULL_END
