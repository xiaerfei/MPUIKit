//
//  TVUPLListView.h
//  TVUCollectionView
//
//  Created by erfeixia on 2025/9/13.
//

#import <UIKit/UIKit.h>
#import "TVUPLSection.h"
#import "TVUPLRow.h"

NS_ASSUME_NONNULL_BEGIN

#define UIColorFromHex(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface TVUPLListView : UIView

@property (nonatomic, copy) NSArray <TVUPLSection *>*(^fetchSectionsBlock)(void);

- (void)reload;
- (void)reloadSectionForKey:(NSString *)key;
- (void)reloadRowForKey:(NSString *)key;

- (void)registerForCell:(NSString *)cellName
                 bundle:(nullable NSBundle *)bundle
                 useNib:(BOOL)useNib;

- (void)registerForHeader:(NSString *)cellName
                   bundle:(nullable NSBundle *)bundle
                   useNib:(BOOL)useNib;

- (void)registerForFooter:(NSString *)cellName
                   bundle:(nullable NSBundle *)bundle
                   useNib:(BOOL)useNib;

@end

NS_ASSUME_NONNULL_END
