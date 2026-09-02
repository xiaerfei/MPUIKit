//
//  TVURSObservable.m
//  TVUSignal / Rx
//

#import "TVURSObservable.h"
#import "TVURSReactive.h"
#import "TVURSmetamacros.h"

typedef TVURSDisposable * _Nullable (^TVURSSubscribeHandler)(TVURSubscriber *observer);
typedef void (^TVURSNext)(id _Nullable x);
/// 每次订阅调用一次，返回带有独立状态的 next 处理块（scan / skip / take 的计数器都在这里诞生）
typedef TVURSNext _Nonnull (^TVURSNextFactory)(TVURSubscriber *downstream);

#pragma mark - 订阅句柄：忘记 disposedBy 时给出提醒

@interface TVURSDisposable ()
@property (nonatomic, copy) void(^block)(void);
@end

@interface TVURSSubscriptionDisposable : TVURSDisposable
@property (nonatomic, assign) BOOL bagged;
@property (nonatomic, assign) BOOL disposedExplicitly;
@end

@implementation TVURSSubscriptionDisposable
- (void)dispose {
    self.disposedExplicitly = YES;
    [super dispose];
}
- (void (^)(TVURSDisposeBag *))disposedBy {
    return ^(TVURSDisposeBag *bag) {
        self.bagged = YES;
        [bag insert:self];
    };
}
- (void)dealloc {
    if (!self.bagged && !self.disposedExplicitly) {
        TVURSLog(@"RSignal: 订阅未 .disposedBy(...)，已随 autoreleasepool 结束。忘记写 disposedBy 了？");
    }
}
@end

#pragma mark - Observable

@interface TVURSObservable ()
@property (nonatomic, copy) TVURSSubscribeHandler handler;
@end

@implementation TVURSObservable

+ (instancetype)create:(TVURSSubscribeHandler)handler {
    NSAssert(handler != nil, @"create handler is null");
    TVURSObservable *observable = [[self alloc] init];
    observable.handler = handler;
    return observable;
}

+ (instancetype)just:(id)value {
    return [self create:^TVURSDisposable *(TVURSubscriber *observer) {
        [observer sendNext:value];
        [observer sendCompleted];
        return nil;
    }];
}

+ (instancetype)empty {
    return [self create:^TVURSDisposable *(TVURSubscriber *observer) {
        [observer sendCompleted];
        return nil;
    }];
}

#pragma mark - Subscribe

- (TVURSDisposable *)subscribeWithObserver:(TVURSubscriber *)observer {
    NSAssert(observer != nil, @"observer is null");
    __block TVURSDisposable *upstream = nil;
    __block BOOL terminated = NO;

    ///< 终止即拆链：completed / error 之后不再转发，并 dispose 上游
    TVURSubscriber *guard = [TVURSubscriber subscriberWithNext:^(id x) {
        if (terminated) return;
        [observer sendNext:x];
    } error:^(NSError *error) {
        if (terminated) return;
        terminated = YES;
        [observer sendError:error];
        [upstream dispose];
    } completed:^{
        if (terminated) return;
        terminated = YES;
        [observer sendCompleted];
        [upstream dispose];
    }];

    upstream = self.handler(guard);
    ///< handler 内同步终止（如 just/empty）时 upstream 尚未赋值，补一次
    if (terminated) [upstream dispose];

    TVURSSubscriptionDisposable *disposable = [TVURSSubscriptionDisposable new];
    disposable.block = ^{
        terminated = YES;
        [upstream dispose];
        upstream = nil;
    };
    return disposable;
}

- (TVURSDisposable *(^)(void (^)(id)))subscribeNext {
    return ^(void (^next)(id)) {
        return self.subscribe(next, nil, nil);
    };
}

- (TVURSDisposable *(^)(void (^)(id), void (^)(NSError *), void (^)(void)))subscribe {
    return ^(void (^next)(id), void (^error)(NSError *), void (^completed)(void)) {
        return [self subscribeWithObserver:[TVURSubscriber subscriberWithNext:next error:error completed:completed]];
    };
}

- (TVURSDisposable *(^)(id, void (^)(id, id)))subscribeWith {
    return ^(id owner, void (^next)(id, id)) {
        NSAssert(owner != nil, @"subscribeWith owner is null");
        NSAssert(next != nil, @"subscribeWith block is null");
        __weak id weakOwner = owner;
        __block __weak TVURSDisposable *weakDisposable = nil;
        TVURSDisposable *disposable = [self subscribeWithObserver:[TVURSubscriber subscriberWithNext:^(id x) {
            id strongOwner = weakOwner;
            if (strongOwner == nil) {                  ///< owner 正在销毁，bag 尚未来得及拆链
                [weakDisposable dispose];
                return;
            }
            next(strongOwner, x);
        } error:nil completed:nil]];
        weakDisposable = disposable;
        disposable.disposedBy(((NSObject *)owner).rx.disposeBag);
        return disposable;
    };
}

#pragma mark - Operators

/// 所有单流操作符的骨架：error / completed 原样下传，只定制 next
- (TVURSObservable *)lift:(TVURSNextFactory)makeNext {
    return [TVURSObservable create:^TVURSDisposable *(TVURSubscriber *downstream) {
        TVURSNext next = makeNext(downstream);
        return [self subscribeWithObserver:[TVURSubscriber subscriberWithNext:next error:^(NSError *error) {
            [downstream sendError:error];
        } completed:^{
            [downstream sendCompleted];
        }]];
    }];
}

- (TVURSObservable *(^)(id (^)(id)))map {
    return ^(id (^block)(id)) {
        NSAssert(block != nil, @"map block is null");
        return [self lift:^TVURSNext(TVURSubscriber *downstream) {
            return ^(id x) { [downstream sendNext:block(x)]; };
        }];
    };
}

- (TVURSObservable *(^)(BOOL (^)(id)))filter {
    return ^(BOOL (^block)(id)) {
        NSAssert(block != nil, @"filter block is null");
        return [self lift:^TVURSNext(TVURSubscriber *downstream) {
            return ^(id x) { if (block(x)) [downstream sendNext:x]; };
        }];
    };
}

- (TVURSObservable *)distinctUntilChanged {
    return self.distinctUntilChangedBy(^BOOL(id pre, id now) {
        return pre == now || [pre isEqual:now];
    });
}

- (TVURSObservable *(^)(BOOL (^)(id, id)))distinctUntilChangedBy {
    return ^(BOOL (^isEqual)(id, id)) {
        NSAssert(isEqual != nil, @"distinctUntilChangedBy block is null");
        return [self lift:^TVURSNext(TVURSubscriber *downstream) {
            __block BOOL initial = YES;
            __block id last = nil;
            return ^(id x) {
                if (!initial && isEqual(last, x)) return;
                initial = NO;
                last = x;
                [downstream sendNext:x];
            };
        }];
    };
}

- (TVURSObservable *(^)(id, id (^)(id, id)))scan {
    return ^(id start, id (^reduce)(id, id)) {
        NSAssert(reduce != nil, @"scan reduce block is null");
        return [self lift:^TVURSNext(TVURSubscriber *downstream) {
            __block id acc = start;
            return ^(id x) {
                acc = reduce(acc, x);
                [downstream sendNext:acc];
            };
        }];
    };
}

- (TVURSObservable *(^)(void (^)(id)))doNext {
    return ^(void (^block)(id)) {
        NSAssert(block != nil, @"doNext block is null");
        return [self lift:^TVURSNext(TVURSubscriber *downstream) {
            return ^(id x) { block(x); [downstream sendNext:x]; };
        }];
    };
}

- (TVURSObservable *(^)(NSUInteger))skip {
    return ^(NSUInteger count) {
        return [self lift:^TVURSNext(TVURSubscriber *downstream) {
            __block NSUInteger skipped = 0;
            return ^(id x) {
                if (skipped < count) { skipped++; return; }
                [downstream sendNext:x];
            };
        }];
    };
}

- (TVURSObservable *(^)(NSUInteger))take {
    return ^(NSUInteger count) {
        return [self lift:^TVURSNext(TVURSubscriber *downstream) {
            __block NSUInteger taken = 0;
            return ^(id x) {
                if (taken >= count) return;
                taken++;
                [downstream sendNext:x];
                if (taken == count) [downstream sendCompleted];
            };
        }];
    };
}

- (TVURSObservable *(^)(TVURSObservable *))merge {
    return ^(TVURSObservable *other) {
        NSAssert(other != nil, @"merge other is null");
        return [TVURSObservable create:^TVURSDisposable *(TVURSubscriber *downstream) {
            __block NSUInteger completedCount = 0;
            void (^oneCompleted)(void) = ^{
                if (++completedCount == 2) [downstream sendCompleted];
            };
            TVURSubscriber *(^forwarder)(void) = ^{
                return [TVURSubscriber subscriberWithNext:^(id x) {
                    [downstream sendNext:x];
                } error:^(NSError *error) {
                    [downstream sendError:error];
                } completed:oneCompleted];
            };
            TVURSDisposable *a = [self  subscribeWithObserver:forwarder()];
            TVURSDisposable *b = [other subscribeWithObserver:forwarder()];
            return [TVURSDisposable disposableWithBlock:^{ [a dispose]; [b dispose]; }];
        }];
    };
}

- (TVURSObservable *(^)(TVURSObservable *))takeUntil {
    return ^(TVURSObservable *trigger) {
        NSAssert(trigger != nil, @"takeUntil trigger is null");
        return [TVURSObservable create:^TVURSDisposable *(TVURSubscriber *downstream) {
            TVURSDisposable *stop = [trigger subscribeWithObserver:[TVURSubscriber subscriberWithNext:^(id x) {
                [downstream sendCompleted];
            } error:^(NSError *error) {
                [downstream sendError:error];
            } completed:nil]];
            TVURSDisposable *source = [self subscribeWithObserver:[TVURSubscriber subscriberWithNext:^(id x) {
                [downstream sendNext:x];
            } error:^(NSError *error) {
                [downstream sendError:error];
            } completed:^{
                [downstream sendCompleted];
            }]];
            return [TVURSDisposable disposableWithBlock:^{ [stop dispose]; [source dispose]; }];
        }];
    };
}

@end
