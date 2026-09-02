//
//  TVURSignal.m
//
//  Created by 夏二飞 on 2024/1/28.
//

#import "TVURSignal.h"
#import "TVURSmetamacros.h"

@interface TVURSDisposable ()
@property (nonatomic, weak) TVURSubscriber *subscriber;
@end

@interface TVURSignal()
@property (nonatomic, strong) NSMutableArray *subscribers;
@property (nonatomic, strong) NSMutableArray *disposables;
@property (nonatomic,   copy, readwrite) NSString *debugName;
@end

@implementation TVURSignal
- (instancetype)init {
    self = [super init];
    if (self) {
        self.subscribers = [NSMutableArray array];
        self.disposables = [NSMutableArray array];
    }
    return self;
}

- (void)dealloc {
    @synchronized (self) {
        [self enumerateSubscribersUsingBlock:^(TVURSubscriber *subscriber) {
            [subscriber.disposable dispose];
        }];
        [self.subscribers removeAllObjects];        
    }
    [self disposable];
    if (self.debugName) {
        TVURSLog(@"RSignal: %@ release", self.debugName);
    }
}
#pragma mark - Create Signal
+ (instancetype)signal {
    return [[TVURSignal alloc] init];
}
/// 信号销毁回调
- (void)addDisposableWithBlock:(void(^)(void))block {
    @synchronized (self) {
        [self.disposables addObject:[TVURSDisposable disposableWithBlock:block]];
    }
}
/// 设置信号的名称
- (__kindof TVURSignal *)addDebugName:(NSString *)name {
    self.debugName = name;
    return self;
}
#pragma mark - Send
- (void)sendNext:(id)value {
    [self enumerateSubscribersUsingBlock:^(TVURSubscriber *subscriber) {
        [subscriber sendNext:value];
    }];
}

- (void)sendCompleted {
    [self enumerateSubscribersUsingBlock:^(TVURSubscriber *subscriber) {
        [subscriber sendCompleted];
        [subscriber.disposable dispose];
    }];
}

- (void)sendError:(NSError *)error {
    [self enumerateSubscribersUsingBlock:^(TVURSubscriber *subscriber) {
        [subscriber sendError:error];
        [subscriber.disposable dispose];
    }];
}

#pragma mark - Subscribe
- (TVURSDisposable *)subscribe:(TVURSubscriber *)subscriber {
    NSAssert(subscriber != nil, @"subscriber parameter is null");

    NSMutableArray *subscribers = self.subscribers;
    @synchronized (subscribers) {
        [subscribers addObject:subscriber];
    }
    
    @weakify(subscriber)
    TVURSDisposable *disposable = [TVURSDisposable disposableWithBlock:^{
        @strongify(subscriber)
        @synchronized (subscribers) {
            // Since newer subscribers are generally shorter-lived, search
            // starting from the end of the list.
            NSUInteger index = [subscribers indexOfObjectWithOptions:NSEnumerationReverse passingTest:^ BOOL (TVURSubscriber *obj, NSUInteger index, BOOL *stop) {
                return obj == subscriber;
            }];
            subscriber.disposable = nil;
            if (index != NSNotFound) [subscribers removeObjectAtIndex:index];
        }
    }];
    /// subscriber --> dispose(strong)
    subscriber.disposable = disposable;
    /// dispose ---> subscriber(weak)
    disposable.subscriber = subscriber;
    return disposable;
}

- (TVURSDisposable *)subscribeNext:(void (^)(id x))nextBlock {
    return [self subscribeNext:nextBlock error:nil completed:nil];
}

- (TVURSDisposable *)subscribeNext:(void (^)(id x))nextBlock
                         completed:(nullable void (^)(void))completed {
    return [self subscribeNext:nextBlock error:nil completed:completed];
}

- (TVURSDisposable *)subscribeNext:(void (^)(id x))nextBlock
                             error:(nullable void (^)(NSError *error))error
                         completed:(nullable void (^)(void))completed {
    TVURSubscriber *subscriber = [TVURSubscriber subscriberWithNext:nextBlock error:error completed:completed];
    return [self subscribe:subscriber];
}
#pragma mark - Transform
/// 合并信号(信号中的任何变动都会发送给所有的订阅者)
/// - Parameter signal: 合并的信号
/// - Return a new signal
- (__kindof TVURSignal *)merge:(TVURSignal *)signal {
    NSAssert(signal != nil, @"merge parameter is null");
    TVURSignal *mergeSignal = [TVURSignal signal];
    
    [self subscribeNext:^(id  _Nonnull x) {
        [mergeSignal sendNext:x];
    } error:^(NSError * _Nonnull error) {
        [mergeSignal sendError:error];
    } completed:^{
        [mergeSignal sendCompleted];
    }];
    
    [signal subscribeNext:^(id  _Nonnull x) {
        [mergeSignal sendNext:x];
    } error:^(NSError * _Nonnull error) {
        [mergeSignal sendError:error];
    } completed:^{
        [mergeSignal sendCompleted];
    }];
    
    return mergeSignal;
}
/// 将信号进行 map 变换
/// - Parameter block: block
/// - Return a new signal with the mapped values.
- (__kindof TVURSignal *)map:(id _Nullable (^)(id _Nullable value))block {
    NSAssert(block != nil, @"map parameter block is null");
    TVURSignal *signal = [TVURSignal signal];
    
    [self subscribeNext:^(id  _Nonnull x) {
        [signal sendNext:block(x)];
    } error:^(NSError * _Nonnull error) {
        [signal sendError:error];
    } completed:^{
        [signal sendCompleted];
    }];
    return signal;
}
/// 过滤符合条件的信号
/// - Parameter block: block
/// - Return a new signal with only those values that passed.
- (__kindof TVURSignal *)filter:(BOOL (^)(id _Nullable value))block {
    NSAssert(block != nil, @"filter parameter block is null");
    TVURSignal *signal = [TVURSignal signal];
    
    [self subscribeNext:^(id  _Nonnull x) {
        if (block(x)) {
            [signal sendNext:x];
        }
    } error:^(NSError * _Nonnull error) {
        [signal sendError:error];
    } completed:^{
        [signal sendCompleted];
    }];
    return signal;
}
/// 累加器
/// - Parameter block: block
/// - Return a new signal that consists of each application of `reduceBlock`.
- (__kindof TVURSignal *)scanWithStart:(nullable id)startingValue
                       reduce:(id _Nullable (^)(id _Nullable running, id _Nullable next))reduceBlock {
    NSAssert(reduceBlock != nil, @"reduce parameter block is null");
    TVURSignal *signal = [TVURSignal signal];
    __block id value = startingValue;
    [self subscribeNext:^(id  _Nonnull x) {
        value = reduceBlock(value, x);
        [signal sendNext:value];
    } error:^(NSError * _Nonnull error) {
        [signal sendError:error];
    } completed:^{
        [signal sendCompleted];
    }];
    
    return signal;
}
/// 当前一个值和后一个值不等的时候才返回一个信号
/// Block 决定是否相等
/*
 ---------NO---------YES---------YES---------NO--------->
 ↑ 订阅         distinctUntilChanged 信号变换
 ---------NO---------YES---------------------NO--------->
 */
- (__kindof TVURSignal *)distinctUntilChangedBlock:(BOOL(^)(id pre, id now))block {
    NSAssert(block != nil, @"block is null");
    TVURSignal *signal = [TVURSignal signal];
    __block BOOL initial = YES;
    __block id lastValue = nil;
    [self subscribeNext:^(id  _Nonnull x) {
        if (!initial && block(lastValue, x)) return;
        initial = NO;
        lastValue = x;
        [signal sendNext:x];
    } error:^(NSError * _Nonnull error) {
        [signal sendError:error];
    } completed:^{
        [signal sendCompleted];
    }];
    return signal;
}
/// ValueType 必须为 NSNumber 类型
- (__kindof TVURSignal *)distinctUntilChanged {
    return [self distinctUntilChangedBlock:^BOOL(NSNumber *pre, NSNumber *now) {
        if ([pre isKindOfClass:NSNumber.class] && [now isKindOfClass:NSNumber.class]) {
            return [pre isEqualToNumber:now];
        } else {
#if DEBUG
            TVURSLog(@"RSignal: distinctUntilChanged ValueType must be NSNumber Type");
            assert(NO);
#endif
            return NO;
        }
    }];
}
#pragma mark - Private Methods
- (void)enumerateSubscribersUsingBlock:(void (^)(TVURSubscriber *subscriber))block {
    NSArray *subscribers = nil;
    @synchronized (self.subscribers) {
        subscribers = [self.subscribers copy];
    }

    for (TVURSubscriber *subscriber in subscribers) {
        block(subscriber);
    }
}

- (void)disposable {
    if (self.debugName) {
        TVURSLog(@"RSignal: %@ will dispose", self.debugName);
    }
    @synchronized (self) {
        for (TVURSDisposable *dis in self.disposables) {
            [dis dispose];
        }
        [self.disposables removeAllObjects];
    }
}

@end
