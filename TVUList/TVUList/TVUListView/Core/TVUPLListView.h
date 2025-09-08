//
//  TVUPLListView.h
//  TVURequestAPIDemo
//
//  Created by TVUM4Pro on 2025/6/24.
//

#import <UIKit/UIKit.h>
#import "TVUPLRowProtocol.h"
#import "TVUPLSection.h"
#import "TVUPLCRows.h"
#import "TVUPLRow.h"
NS_ASSUME_NONNULL_BEGIN

@class TVUSectionView;

@interface TVUPLListView : UIScrollView
@property (nonatomic, copy) NSArray <TVUPLSection *>*(^fetchSectionsBlock)(void);

- (void)reload;
- (void)reloadRowWithKey:(NSString *)key;

- (TVUPLRow *)rowForKey:(NSString *)key;

- (void)reloadSectionWithKey:(NSString *)key;
- (void)reloadSection:(TVUPLSection *)section;
- (TVUPLSection *)sectionForKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
