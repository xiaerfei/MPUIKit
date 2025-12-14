//
//  TVUStaticView.h
//  TVUCollectionView
//
//  Created by erfeixia on 2025/12/14.
//

#import <UIKit/UIKit.h>
#import "TVUPLSection.h"
#import "TVUPLRow.h"
NS_ASSUME_NONNULL_BEGIN

@interface TVUStaticView : UIScrollView

- (TVUStaticView *(^)(void(^)(TVUStaticView *list)))prefetch;
- (TVUStaticView *(^)(NSArray <TVUPLSection *>*sections))sections;
- (void)reload;

@end

NS_ASSUME_NONNULL_END
