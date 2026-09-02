//
//  TVURSignal.h
//
//  Created by 夏二飞 on 2024/1/28.
//

#import <Foundation/Foundation.h>
#import "TVURSDisposable.h"
#import "TVURSubscriber.h"
#import "TVUTuple.h"
NS_ASSUME_NONNULL_BEGIN

@interface TVURSignal<__covariant ValueType> : NSObject
/// 创建一个信号
+ (instancetype)signal;
/// 信号销毁回调
- (void)addDisposableWithBlock:(void(^)(void))block;

@property (nonatomic,   copy, readonly) NSString *debugName;
/// 设置信号的名称
- (TVURSignal<ValueType> *)addDebugName:(NSString *)name;
#pragma mark - Send
/// 向订阅者发送 value
/// - Parameter value: value
- (void)sendNext:(ValueType)value;
/// 向订阅者发送已完成
- (void)sendCompleted;
/// 向订阅者发送错误
/// - Parameter error: error
- (void)sendError:(NSError *)error;
#pragma mark - Subscribe
/// 订阅信号
/// - Parameter subscriber: 订阅者
- (TVURSDisposable *)subscribe:(TVURSubscriber *)subscriber;
/// 订阅信号
/// - Parameter nextBlock: nextBlock
- (TVURSDisposable *)subscribeNext:(void (^)(ValueType x))nextBlock;
/// 订阅信号
/// - Parameters:
///   - nextBlock: nextBlock
///   - completed: completed
- (TVURSDisposable *)subscribeNext:(void (^)(ValueType x))nextBlock
                         completed:(nullable void (^)(void))completed;
/// 订阅信号
/// - Parameters:
///   - nextBlock: nextBlock
///   - error: error
///   - completed: completed
- (TVURSDisposable *)subscribeNext:(void (^)(ValueType x))nextBlock
                             error:(nullable void (^)(NSError *error))error
                         completed:(nullable void (^)(void))completed;
#pragma mark - Transform
/// 合并信号(信号中的任何变动都会发送给所有的订阅者)
/// - Parameter signal: 合并的信号
/// - Return a new signal
- (TVURSignal<ValueType> *)merge:(TVURSignal *)signal;
/// 将信号进行 map 变换
/// - Parameter block: block
/// - Return a new signal with the mapped values.
- (TVURSignal<ValueType> *)map:(id _Nullable (^)(ValueType _Nullable value))block;
/// 过滤符合条件的信号
/// - Parameter block: block
/// - Return a new signal with only those values that passed.
- (TVURSignal<ValueType> *)filter:(BOOL (^)(ValueType _Nullable value))block;
/// 累加器
/// - Parameter block: block
/// - Return a new signal that consists of each application of `reduceBlock`.
- (TVURSignal<ValueType> *)scanWithStart:(nullable id)startingValue
                       reduce:(id _Nullable (^)(id _Nullable running, ValueType _Nullable next))reduceBlock;
/// 当前一个值和后一个值不等的时候才返回一个信号
/// Block 决定是否相等
- (TVURSignal<ValueType> *)distinctUntilChangedBlock:(BOOL(^)(ValueType pre, ValueType now))block;
/// ValueType 必须为 NSNumber 类型
- (TVURSignal<ValueType> *)distinctUntilChanged;
@end

NS_ASSUME_NONNULL_END
