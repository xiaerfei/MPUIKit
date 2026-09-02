//
//  TVURSignalTests.m
//  StaticViewDemoTests
//
//  第一组：老 API（TVURSignal）基线，产线在用，行为不变。
//  第二组：Rx dot 语法层（TVURSObservable / DisposeBag / .rx），
//         之前老 API 上失败的四个场景在这里必须成立。
//

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>
#import "TVURSignalObjc.h"
#import "TVURx.h"

@interface TVURSignalTests : XCTestCase
@end

@implementation TVURSignalTests

#pragma mark - 老 API 基线

- (void)testBasicSubscribeReceivesValue {
    TVURSignal *signal = [TVURSignal signal];
    __block id received = nil;
    [signal subscribeNext:^(id x) { received = x; }];
    [signal sendNext:@1];
    XCTAssertEqualObjects(received, @1);
}

- (void)testMapTransformsValue {
    TVURSignal *signal = [TVURSignal signal];
    __block id received = nil;
    [[signal map:^id(NSNumber *v) { return @(v.integerValue * 10); }] subscribeNext:^(id x) { received = x; }];
    [signal sendNext:@2];
    XCTAssertEqualObjects(received, @20);
}

- (void)testControlSignalFiresOnEvent {
    UIButton *button = [UIButton new];
    __block NSInteger count = 0;
    [[button rs_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) { count++; }];
    [button sendActionsForControlEvents:UIControlEventTouchUpInside];
    XCTAssertEqual(count, 1);
}

#pragma mark - Rx：语法

- (void)testRxChainMapFilterSubscribe {
    TVURSignal<NSNumber *> *source = [TVURSignal signal];
    NSMutableArray *received = [NSMutableArray array];

    source.asObservable
        .map(^id(NSNumber *x) { return @(x.integerValue * 10); })
        .filter(^BOOL(NSNumber *x) { return x.integerValue > 10; })
        .subscribeNext(^(NSNumber *x) { [received addObject:x]; })
        .disposedBy(self.rx.disposeBag);

    [source sendNext:@1];
    [source sendNext:@2];
    [source sendNext:@3];
    XCTAssertEqualObjects(received, (@[@20, @30]));
}

- (void)testRxScanDistinctTake {
    TVURSignal<NSNumber *> *source = [TVURSignal signal];
    NSMutableArray *received = [NSMutableArray array];
    __block BOOL completed = NO;

    source.asObservable
        .distinctUntilChanged
        .scan(@0, ^id(NSNumber *acc, NSNumber *x) { return @(acc.integerValue + x.integerValue); })
        .take(2)
        .subscribe(^(NSNumber *x) { [received addObject:x]; }, nil, ^{ completed = YES; })
        .disposedBy(self.rx.disposeBag);

    [source sendNext:@1];
    [source sendNext:@1];     ///< distinct 吞掉
    [source sendNext:@2];     ///< take 满 2 个后 completed
    [source sendNext:@3];     ///< 不应再收到
    XCTAssertEqualObjects(received, (@[@1, @3]));
    XCTAssertTrue(completed);
    XCTAssertEqual([[source valueForKey:@"subscribers"] count], 0, @"completed 后应自动从源上退订");
}

#pragma mark - Rx：生命周期（老 API 上失败的四个场景）

- (void)testRxDisposeBagReleasesOwnerAndUnsubscribes {
    TVURSignal *longLived = [TVURSignal signal];
    NSArray *subscribers = [longLived valueForKey:@"subscribers"];
    __weak NSObject *weakOwner = nil;

    @autoreleasepool {
        NSObject *owner = [NSObject new];              ///< 模拟一个 VC
        weakOwner = owner;
        __weak NSObject *weakSelf = owner;             ///< 与 RxSwift 一样：block 内 [weak self]
        longLived.asObservable
            .map(^id(id v) { return v; })
            .subscribeNext(^(id x) { [weakSelf description]; })
            .disposedBy(owner.rx.disposeBag);
        XCTAssertEqual(subscribers.count, 1);
    }

    XCTAssertNil(weakOwner, @"owner 无人引用时应正常释放");
    XCTAssertEqual(subscribers.count, 0, @"owner 销毁后源信号上的订阅应被移除");
}

- (void)testRxRepeatedOwnersLeaveNothingBehind {
    TVURSignal *longLived = [TVURSignal signal];
    NSArray *subscribers = [longLived valueForKey:@"subscribers"];

    for (NSInteger i = 0; i < 3; i++) {
        @autoreleasepool {
            NSObject *owner = [NSObject new];
            __weak NSObject *weakSelf = owner;
            longLived.asObservable
                .map(^id(id v) { return v; })
                .subscribeNext(^(id x) { [weakSelf description]; })
                .disposedBy(owner.rx.disposeBag);
        }
    }
    XCTAssertEqual(subscribers.count, 0, @"进出页面三次，源信号上不应残留订阅");
}

- (void)testRxControlTwoEventsCoexist {
    UIButton *button = [UIButton new];
    __block NSInteger upInside = 0, touchDown = 0;

    @autoreleasepool {
        button.rx.tap
            .subscribeNext(^(id x) { upInside++; })
            .disposedBy(self.rx.disposeBag);
        button.rx.controlEvent(UIControlEventTouchDown)
            .subscribeNext(^(id x) { touchDown++; })
            .disposedBy(self.rx.disposeBag);
    }

    [button sendActionsForControlEvents:UIControlEventTouchUpInside];
    [button sendActionsForControlEvents:UIControlEventTouchDown];
    XCTAssertEqual(upInside, 1);
    XCTAssertEqual(touchDown, 1);
}

- (void)testRxControlSubscriptionRemovesTargetOnDispose {
    UIButton *button = [UIButton new];
    TVURSDisposeBag *bag = [TVURSDisposeBag new];
    __block NSInteger count = 0;

    button.rx.tap.subscribeNext(^(id x) { count++; }).disposedBy(bag);
    XCTAssertEqual(button.allTargets.count, 1);

    [bag dispose];
    [button sendActionsForControlEvents:UIControlEventTouchUpInside];
    XCTAssertEqual(count, 0);
    XCTAssertEqual(button.allTargets.count, 0, @"dispose 后控件里不应残留 target");
}

- (void)testRxNotificationStaysAliveWhileBagged {
    NSString *name = @"TVURSignalTestsNotification";
    __block BOOL fired = NO;

    @autoreleasepool {
        NSNotificationCenter.defaultCenter.rx.notification(name)
            .subscribeNext(^(NSNotification *note) { fired = YES; })
            .disposedBy(self.rx.disposeBag);
    }
    [NSNotificationCenter.defaultCenter postNotificationName:name object:nil];
    XCTAssertTrue(fired);
}

- (void)testRxSubscriptionWithoutBagEndsAtPoolDrain {
    ///< 契约：忘记 disposedBy 的订阅活不过当前 autoreleasepool（DEBUG 下有日志提醒）
    TVURSignal *source = [TVURSignal signal];
    __block NSInteger count = 0;

    @autoreleasepool {
        source.asObservable.subscribeNext(^(id x) { count++; });
    }
    [source sendNext:@1];
    XCTAssertEqual(count, 0);
    XCTAssertEqual([[source valueForKey:@"subscribers"] count], 0);
}

- (void)testRxSubscribeWithPassesOwnerAndAutoDisposes {
    TVURSignal *longLived = [TVURSignal signal];
    NSArray *subscribers = [longLived valueForKey:@"subscribers"];
    __weak NSObject *weakOwner = nil;
    __block id receivedOwner = nil;
    __block id receivedValue = nil;

    @autoreleasepool {
        NSObject *owner = [NSObject new];
        weakOwner = owner;
        longLived.asObservable.subscribeWith(owner, ^(NSObject *o, id x) {
            receivedOwner = o;                         ///< 用参数 o，写不出对 owner 的环
            receivedValue = x;
        });
        XCTAssertEqual(subscribers.count, 1, @"无需 .disposedBy，已自动进入 owner.rx.disposeBag");

        [longLived sendNext:@7];
        XCTAssertEqual(receivedOwner, owner);
        XCTAssertEqualObjects(receivedValue, @7);
        receivedOwner = nil;
    }

    XCTAssertNil(weakOwner, @"block 内没有强引用 owner，owner 应正常释放");
    XCTAssertEqual(subscribers.count, 0, @"owner 释放后源信号上的订阅应被移除");

    [longLived sendNext:@8];
    XCTAssertEqualObjects(receivedValue, @7, @"owner 释放后不应再回调");
}

- (void)testRxTakeUntil {
    TVURSignal *source  = [TVURSignal signal];
    TVURSignal *trigger = [TVURSignal signal];
    __block NSInteger count = 0;
    __block BOOL completed = NO;

    source.asObservable
        .takeUntil(trigger.asObservable)
        .subscribe(^(id x) { count++; }, nil, ^{ completed = YES; })
        .disposedBy(self.rx.disposeBag);

    [source sendNext:@1];
    [trigger sendNext:@YES];
    [source sendNext:@2];
    XCTAssertEqual(count, 1);
    XCTAssertTrue(completed);
    XCTAssertEqual([[source valueForKey:@"subscribers"] count], 0);
    XCTAssertEqual([[trigger valueForKey:@"subscribers"] count], 0);
}

@end
