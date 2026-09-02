//
//  TVURSReactive.h
//  TVUSignal / Rx
//
//  对应 RxCocoa 的 Reactive<Base>：所有对象都有 .rx 命名空间。
//
//      self.rx.disposeBag                          随 self 一同销毁
//      button.rx.tap                               TouchUpInside
//      button.rx.controlEvent(UIControlEventTouchDown)
//      uiSwitch.rx.valueChanged                    ValueChanged，值为控件本身
//      NSNotificationCenter.defaultCenter.rx.notification(name)
//      hotSignal.asObservable                      老的 TVURSignal 进入 dot 世界
//

#import <UIKit/UIKit.h>
#import "TVURSObservable.h"
#import "TVURSDisposeBag.h"
#import "TVURSignal.h"

NS_ASSUME_NONNULL_BEGIN

@interface TVURSReactive<__covariant Base> : NSObject
@property (nonatomic, weak, readonly) Base base;
/// 挂在 base 上的关联对象，base 销毁时袋中订阅一并 dispose
@property (nonatomic, strong, readonly) TVURSDisposeBag *disposeBag;
@end

@interface TVURSControlReactive<__covariant Base : UIControl *> : TVURSReactive<Base>
@property (nonatomic, strong, readonly) TVURSObservable<Base> *tap;
@property (nonatomic, strong, readonly) TVURSObservable<Base> *valueChanged;
- (TVURSObservable<Base> *(^)(UIControlEvents events))controlEvent;
@end

@interface TVURSNotificationReactive : TVURSReactive<NSNotificationCenter *>
- (TVURSObservable<NSNotification *> *(^)(NSNotificationName name))notification;
- (TVURSObservable<NSNotification *> *(^)(NSNotificationName name, id _Nullable object))notificationOf;
@end

@interface NSObject (TVURx)
@property (nonatomic, strong, readonly) TVURSReactive *rx;
@end

@interface UIControl (TVURx)
@property (nonatomic, strong, readonly) TVURSControlReactive *rx;
@end

@interface NSNotificationCenter (TVURx)
@property (nonatomic, strong, readonly) TVURSNotificationReactive *rx;
@end

@interface TVURSignal<ValueType> (TVURx)
/// 对应 RxSwift 的 subject.asObservable()：订阅即 [signal subscribe:]，dispose 即退订
@property (nonatomic, strong, readonly) TVURSObservable<ValueType> *asObservable;
@end

NS_ASSUME_NONNULL_END
