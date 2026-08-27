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
@property (nonatomic, assign, readonly) BOOL mhidden;
@property (nonatomic, assign, readonly) CGRect mframe;
@property (nonatomic, strong, readonly) NSMutableDictionary *mdataDict;

- (TVUPLViewData *(^)(NSString * _Nullable key))key;
- (TVUPLViewData *(^)(id _Nullable color))backgroundColor;
- (TVUPLViewData *(^)(CGFloat cornerRadius))cornerRadius;
- (TVUPLViewData *(^)(UIEdgeInsets insets))insets;
- (TVUPLViewData *(^)(BOOL hidden))hidden;
- (TVUPLViewData *(^)(CGRect frame))frame;

///< 自定义
- (TVUPLViewData *(^)(NSString *key, id value))custom;
- (id)customForKey:(NSString *)key;

#pragma mark - 框架内部
///< 记录/查询某个属性是否被显式设置过。
///< configure: 据此决定是否覆盖 view 自身的默认样式 —— 没设过就不碰，
///< 这样 View 层的默认字体、颜色才不会被 nil 冲掉。
- (void)markSet:(NSString *)propertyName;
- (BOOL)isSet:(NSString *)propertyName;

- (void)configure:(UIView *)view;
@end

NS_ASSUME_NONNULL_END
