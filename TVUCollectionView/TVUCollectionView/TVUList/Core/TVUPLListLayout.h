//
//  TVUPLListLayout.h
//  TVUCollectionView
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class TVUPLSection, TVUPLRow, TVUPLListLayout;
@protocol TVUPLListFlowLayoutDelegate <NSObject>

- (TVUPLSection *)layout:(TVUPLListLayout *)layout section:(NSInteger)section;
- (TVUPLRow *)layout:(TVUPLListLayout *)layout headerForSection:(NSInteger)section;
- (TVUPLRow *)layout:(TVUPLListLayout *)layout footerForSection:(NSInteger)section;
- (TVUPLRow *)layout:(TVUPLListLayout *)layout rowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface TVUPLListLayout : UICollectionViewFlowLayout

@end

NS_ASSUME_NONNULL_END
