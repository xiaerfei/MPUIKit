//
//  TVUPLState.h
//  StaticViewDemo
//
//  Created by erfeixia on 2026/8/27.
//

/*
 可观察状态。在 row 的 prefetch 中读取 value 会自动建立依赖，
 之后修改 value 只刷新真正读过它的那些 row，不必手写 reloadRowForKey:。

     self.pidString = [TVUPLState value:@"..."];

     // prefetch 中读取 —— 依赖在这一刻建立
     .text(self.pidString.value)

     // 任意时刻写入 —— 刷新自动发生
     self.pidString.value = @"新文案";

 依赖在每次求值时重建，所以写在条件分支里的读取也能被正确追踪：
 分支没走到，这一轮就不会读到，那个 State 自然不再触发这一行。
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class TVUPLRow;

@interface TVUPLState<__covariant ValueType> : NSObject

+ (instancetype)value:(nullable ValueType)value;

@property (nonatomic, strong, nullable) ValueType value;

#pragma mark - 框架内部
///< 由 TVUStaticView 在执行 row.rprefetch 前后调用，界定依赖收集的作用域
+ (void)beginEvaluatingRow:(TVUPLRow *)row;
+ (void)endEvaluating;
+ (BOOL)isEvaluating;

@end

NS_ASSUME_NONNULL_END
