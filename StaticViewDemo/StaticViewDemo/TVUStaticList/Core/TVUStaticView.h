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

extern NSString *const kTVUPLDefaultRow;
extern NSString *const kTVUPLLoginRow;

@interface TVUStaticView : UIScrollView

- (TVUStaticView *(^)(void(^)(TVUStaticView *list)))prefetch;
- (TVUStaticView *(^)(NSArray <TVUPLSection *>*sections))sections;
- (void)reload;

- (void)reloadSectionForKey:(NSString *)key;
- (void)reloadRowForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
