//
//  TVUPLBaseRow.h
//  TVUCollectionView
//
//  Created by erfeixia on 2025/9/13.
//

#import <UIKit/UIKit.h>
#import "TVUPLRow.h"

NS_ASSUME_NONNULL_BEGIN

@interface TVUPLBaseRow : UICollectionViewCell

@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic,   weak) TVUPLRow *plrow;

- (void)sendEventInfo:(id)info;

- (void)updateWithData:(id)data;

@end

NS_ASSUME_NONNULL_END
