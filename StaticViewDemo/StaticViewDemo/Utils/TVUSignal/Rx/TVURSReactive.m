//
//  TVURSReactive.m
//  TVUSignal / Rx
//

#import "TVURSReactive.h"
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Reactive

@interface TVURSReactive ()
@property (nonatomic, weak, readwrite) id base;
@end

@implementation TVURSReactive
- (instancetype)initWithBase:(id)base {
    if (self = [super init]) {
        _base = base;
    }
    return self;
}

- (TVURSDisposeBag *)disposeBag {
    id base = self.base;
    if (base == nil) return [TVURSDisposeBag new];   ///< base 已死，给个一次性袋子避免 nil 崩溃
    TVURSDisposeBag *bag = objc_getAssociatedObject(base, _cmd);
    if (bag == nil) {
        bag = [TVURSDisposeBag new];
        objc_setAssociatedObject(base, _cmd, bag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return bag;
}
@end

#pragma mark - UIControl

/// UIControl 弱持有 target，故由订阅的 disposable 持有本对象
@interface TVURSControlTarget : NSObject
@property (nonatomic, copy) void (^handler)(id sender);
@end

@implementation TVURSControlTarget
- (void)invoke:(id)sender {
    if (self.handler) self.handler(sender);
}
@end

@implementation TVURSControlReactive

- (TVURSObservable<UIControl *> *)tap {
    return self.controlEvent(UIControlEventTouchUpInside);
}

- (TVURSObservable<UIControl *> *)valueChanged {
    return self.controlEvent(UIControlEventValueChanged);
}

- (TVURSObservable<UIControl *> *(^)(UIControlEvents))controlEvent {
    __weak UIControl *weakControl = self.base;
    return ^(UIControlEvents events) {
        return [TVURSObservable create:^TVURSDisposable *(TVURSubscriber *observer) {
            UIControl *control = weakControl;
            if (control == nil) {
                [observer sendCompleted];
                return nil;
            }
            TVURSControlTarget *target = [TVURSControlTarget new];
            target.handler = ^(id sender) { [observer sendNext:sender]; };
            [control addTarget:target action:@selector(invoke:) forControlEvents:events];
            return [TVURSDisposable disposableWithBlock:^{
                [weakControl removeTarget:target action:@selector(invoke:) forControlEvents:events];
            }];
        }];
    };
}
@end

#pragma mark - NSNotificationCenter

@implementation TVURSNotificationReactive
- (TVURSObservable<NSNotification *> *(^)(NSNotificationName))notification {
    return ^(NSNotificationName name) {
        return self.notificationOf(name, nil);
    };
}

- (TVURSObservable<NSNotification *> *(^)(NSNotificationName, id _Nullable))notificationOf {
    NSNotificationCenter *center = self.base;
    return ^(NSNotificationName name, id _Nullable object) {
        return [TVURSObservable create:^TVURSDisposable *(TVURSubscriber *observer) {
            id token = [center addObserverForName:name object:object queue:nil usingBlock:^(NSNotification *note) {
                [observer sendNext:note];
            }];
            return [TVURSDisposable disposableWithBlock:^{
                [center removeObserver:token];
            }];
        }];
    };
}
@end

#pragma mark - Categories

@implementation NSObject (TVURx)
- (TVURSReactive *)rx {
    return [[TVURSReactive alloc] initWithBase:self];
}
@end

@implementation UIControl (TVURx)
- (TVURSControlReactive *)rx {
    return [[TVURSControlReactive alloc] initWithBase:self];
}
@end

@implementation NSNotificationCenter (TVURx)
- (TVURSNotificationReactive *)rx {
    return [[TVURSNotificationReactive alloc] initWithBase:self];
}
@end

@implementation TVURSignal (TVURx)
- (TVURSObservable *)asObservable {
    return [TVURSObservable create:^TVURSDisposable *(TVURSubscriber *observer) {
        return [self subscribe:observer];
    }];
}
@end

NS_ASSUME_NONNULL_END
