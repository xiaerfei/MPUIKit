//
//  TVUPLListView.h
//  TVUCollectionView
//
//  Created by erfeixia on 2025/9/13.
//
/*
 使用方式:
 
 
 
 
 
 
 
 
 
 
 
 */
#import <UIKit/UIKit.h>
#import "TVUPLSection.h"
#import "TVUPLReuseManager.h"
#import "TVUPLListConst.h"
#import "TVUPLRowData.h"

NS_ASSUME_NONNULL_BEGIN

#define UIColorFromHex(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface TVUPLListView : UIView

- (void)reload;
- (void)reloadSectionForKeys:(NSArray *)keys;
- (void)reloadRowForKeys:(NSArray *)keys;

- (void)registerClassForRow:(NSString *)rowName;
- (void)registerNibForRow:(NSString *)rowName bundle:(nullable NSBundle *)bundle;


#pragma mark - Section 相关设置
- (TVUPLListView *(^)(NSArray *sections))sections;
- (TVUPLListView *(^)(UIEdgeInsets insets))insets;
- (TVUPLListView *(^)(CGFloat cornerRadius))cornerRadius;
- (TVUPLListView *(^)(UIColor *backgroundColor))sectionColor;
- (TVUPLListView *(^)(void(^)(TVUPLListView *list)))prefetch;
@end

NS_ASSUME_NONNULL_END
