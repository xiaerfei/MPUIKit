//
//  TVUPLListFlowLayout.h
//  TVUCollectionView
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class TVUPLSection, TVUPLRow, TVUPLListFlowLayout;
@protocol TVUPLListFlowLayoutDelegate <NSObject>

- (TVUPLSection *)layout:(TVUPLListFlowLayout *)layout section:(NSInteger)section;
- (TVUPLRow *)layout:(TVUPLListFlowLayout *)layout headerForSection:(NSInteger)section;
- (TVUPLRow *)layout:(TVUPLListFlowLayout *)layout footerForSection:(NSInteger)section;
- (TVUPLRow *)layout:(TVUPLListFlowLayout *)layout rowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface TVUPLListFlowLayout : UICollectionViewFlowLayout

@end

NS_ASSUME_NONNULL_END
