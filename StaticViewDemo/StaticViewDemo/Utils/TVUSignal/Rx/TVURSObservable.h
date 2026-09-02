//
//  TVURSObservable.h
//  TVUSignal / Rx
//
//  对应 RxSwift 的 Observable：冷序列，订阅时才建链，dispose 时整条链一起拆。
//  语法全部为 dot 风格：
//
//      button.rx.tap
//          .map(^id(id x) { return @1; })
//          .filter(^BOOL(NSNumber *x) { return x.integerValue > 0; })
//          .subscribeNext(^(NSNumber *x) { NSLog(@"%@", x); })
//          .disposedBy(self.rx.disposeBag);
//
//  两条约定，都与 RxSwift 相同：
//  1. 订阅必须 .disposedBy(...)，否则返回的 disposable 会随 autoreleasepool 释放而结束订阅
//     （DEBUG 下会打日志提醒）。忘记 disposed(by:) 就是 bug。
//  2. block 内引用 owner 请用弱引用（RxSwift 的 [weak self]）。热源会强持有订阅者，
//     owner → disposeBag → 订阅 → block → owner 是环，弱引用才能让 owner 正常释放。
//
//  以上两条用 .subscribeWith(self, ^(owner, x){ ... }) 可以一并省掉，见下文。
//

#import <Foundation/Foundation.h>
#import "TVURSDisposable.h"
#import "TVURSubscriber.h"
#import "TVURSDisposeBag.h"

NS_ASSUME_NONNULL_BEGIN

@interface TVURSObservable<__covariant T> : NSObject

#pragma mark - Create
/// 对应 Observable.create：handler 收到 observer，返回用于拆链的 disposable（可为 nil）
+ (instancetype)create:(TVURSDisposable * _Nullable (^)(TVURSubscriber *observer))handler;
/// 对应 Observable.just
+ (instancetype)just:(T)value;
/// 对应 Observable.empty
+ (instancetype)empty;

#pragma mark - Subscribe
/// 核心订阅入口，其余 subscribe 皆经由此处；completed / error 后自动拆链
- (TVURSDisposable *)subscribeWithObserver:(TVURSubscriber *)observer;
- (TVURSDisposable *(^)(void (^next)(T x)))subscribeNext;
- (TVURSDisposable *(^)(void (^_Nullable next)(T x),
                        void (^_Nullable error)(NSError *error),
                        void (^_Nullable completed)(void)))subscribe;
/// 对应 RxSwift 6 的 subscribe(with:)：owner 作为参数传入 block，内部弱持有，
/// owner 释放后自动结束；并自动放进 owner.rx.disposeBag。
/// UI 场景的首选写法——不必写 __weak，也不必写 .disposedBy。
///
///     uiSwitch.rx.valueChanged
///         .subscribeWith(self, ^(ViewController *owner, UISwitch *s) {
///             owner.state.value = @(s.on);
///         });
- (TVURSDisposable *(^)(id owner, void (^next)(id owner, T x)))subscribeWith;

#pragma mark - Operators
- (TVURSObservable *(^)(id _Nullable (^block)(T x)))map;
- (TVURSObservable<T> *(^)(BOOL (^block)(T x)))filter;
/// 以 isEqual: 判等
- (TVURSObservable<T> *)distinctUntilChanged;
- (TVURSObservable<T> *(^)(BOOL (^isEqual)(T pre, T now)))distinctUntilChangedBy;
- (TVURSObservable *(^)(id _Nullable start, id _Nullable (^reduce)(id _Nullable acc, T x)))scan;
/// 副作用，不改变值；`do` 是 C 关键字，故名 doNext
- (TVURSObservable<T> *(^)(void (^block)(T x)))doNext;
- (TVURSObservable<T> *(^)(NSUInteger count))skip;
- (TVURSObservable<T> *(^)(NSUInteger count))take;
/// 任一方发出即转发；双方都 completed 才 completed
- (TVURSObservable<T> *(^)(TVURSObservable<T> *other))merge;
/// trigger 发出任意值时 completed 并拆链
- (TVURSObservable<T> *(^)(TVURSObservable *trigger))takeUntil;

@end

NS_ASSUME_NONNULL_END
