//
//  TVUPLCListFlowLayout.h
//  TVUCollectionView
//
//  Created by erfeixia on 2025/12/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 配置模型：仅保留基础样式属性
@interface TVUPLConfigModel : NSObject
@property (nonatomic, strong) UIColor *backgroundColor; // 背景色
@property (nonatomic, assign) CGFloat cornerRadius;     // 圆角半径
@property (nonatomic, assign) CGFloat borderWidth;      // 边框宽度
@property (nonatomic, strong) UIColor *borderColor;     // 边框颜色
@end

// 代理协议：提供每个section的配置
@protocol TVUPLListFlowLayoutDelegate <UICollectionViewDelegateFlowLayout>
@optional
// 获取section的配置模型
- (TVUPLConfigModel *)collectionView:(UICollectionView *)collectionView
                              layout:(UICollectionViewLayout *)layout
                configModelForSection:(NSInteger)section;
// 背景与内容的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)layout
    borderEdgeInsetsForSection:(NSInteger)section;
@end

@interface TVUPLCListFlowLayout : UICollectionViewFlowLayout
@property (nonatomic, weak) id<TVUPLListFlowLayoutDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
