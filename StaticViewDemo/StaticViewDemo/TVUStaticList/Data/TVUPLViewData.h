//
//  TVUPLViewData.h
//  StaticViewDemo
//
//  Created by erfeixia on 2026/1/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define ViewData(KEY) [TVUPLViewData new].key(KEY)

@interface TVUPLViewData : NSObject

@property (nonatomic,   copy, readonly) NSString *mkey;
///< 支持 UIColor、FFFFFF、FFFFFFA2(携带透明度)、#FBFBFB
@property (nonatomic, strong, readonly) id mbackgroundColor;
@property (nonatomic, assign, readonly) CGFloat mcornerRadius;
@property (nonatomic, assign, readonly) UIEdgeInsets minsets;
@property (nonatomic, strong, readonly) NSMutableDictionary *mdataDict;

- (TVUPLViewData *(^)(NSString * _Nullable key))key;
- (TVUPLViewData *(^)(id _Nullable color))backgroundColor;
- (TVUPLViewData *(^)(CGFloat cornerRadius))cornerRadius;
- (TVUPLViewData *(^)(UIEdgeInsets insets))insets;

///< 自定义
- (TVUPLViewData *(^)(NSString *key, id value))custom;
- (id)customForKey:(NSString *)key;

- (void)configure:(UIView *)view;
@end

NS_ASSUME_NONNULL_END
