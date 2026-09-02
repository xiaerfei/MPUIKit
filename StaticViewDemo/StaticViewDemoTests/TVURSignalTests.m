//
//  TVURSignalTests.m
//  StaticViewDemoTests
//
//  TVURSignal 轻量级信号的行为测试。
//  每个用例按「期望的正确行为」编写：修复前应失败，修复后应通过。
//

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>
#import "TVURSignal.h"
#import "UIControl+TVURSignal.h"
#import "NSNotificationCenter+TVUSignalSupport.h"

@interface TVURSignalTests : XCTestCase
@end

@implementation TVURSignalTests

#pragma mark - 基线：这些现在就应该通过

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

#pragma mark - 瑕疵 1：派生信号把订阅者（VC）永久钉在源信号上

- (void)testDerivedSubscriptionShouldNotLeakOwner {
    TVURSignal *longLived = [TVURSignal signal];      ///< 模拟全局/单例信号
    __weak NSObject *weakOwner = nil;

    @autoreleasepool {
        NSObject *owner = [NSObject new];              ///< 模拟一个 VC
        weakOwner = owner;
        [[longLived map:^id(id v) { return v; }] subscribeNext:^(id x) {
            [owner description];                       ///< block 强捕获 owner —— 最常见写法
        }];
    }

    XCTAssertNil(weakOwner, @"owner 已无人引用，却被源信号上的派生订阅链钉住无法释放");
}

- (void)testDerivedSubscriptionShouldBeRemovedFromSourceAfterOwnerGone {
    TVURSignal *longLived = [TVURSignal signal];
    NSArray *subscribers = [longLived valueForKey:@"subscribers"];

    for (NSInteger i = 0; i < 3; i++) {
        @autoreleasepool {
            NSObject *owner = [NSObject new];
            [[longLived map:^id(id v) { return v; }] subscribeNext:^(id x) { [owner description]; }];
        }
    }

    XCTAssertEqual(subscribers.count, 0,
                   @"三个 owner 都已销毁，源信号上却还挂着 %lu 条订阅（每进一次页面就多一条）",
                   (unsigned long)subscribers.count);
}

#pragma mark - 瑕疵 2：UIControl 更换信号不 removeTarget，留下悬垂 target

- (void)testControlSecondEventSignalShouldNotKillFirst {
    UIButton *button = [UIButton new];
    __block NSInteger upInside = 0, touchDown = 0;

    __weak TVURSignal *weakFirst = nil;
    @autoreleasepool {                                 ///< 模拟 viewDidLoad 结束、run loop 一轮 drain
        TVURSignal *first = [button rs_signalForControlEvents:UIControlEventTouchUpInside];
        weakFirst = first;
        [first subscribeNext:^(id x) { upInside++; }];
    }                                                  ///< 调用方不持有，信号只靠控件关联对象活着
    XCTAssertNotNil(weakFirst, @"前置条件：仅监听一种事件时信号应由控件持有");

    @autoreleasepool {
        [[button rs_signalForControlEvents:UIControlEventTouchDown] subscribeNext:^(id x) { touchDown++; }];
    }

    XCTAssertNotNil(weakFirst, @"监听第二种事件时，第一种事件的信号被释放了；"
                               @"UIControl 弱持有 target，第一种事件从此静默失效");

    if (weakFirst) {
        [button sendActionsForControlEvents:UIControlEventTouchUpInside];
        [button sendActionsForControlEvents:UIControlEventTouchDown];
        XCTAssertEqual(upInside, 1);
        XCTAssertEqual(touchDown, 1);
    }
}

#pragma mark - 瑕疵 3：根信号（通知）不持有就当场失效，与派生信号规则相反

- (void)testNotificationSignalShouldStayAliveWhileSubscribed {
    NSString *name = @"TVURSignalTestsNotification";
    __block BOOL fired = NO;

    @autoreleasepool {                                 ///< viewDidLoad 里这么写，run loop 一轮之后……
        [[NSNotificationCenter.defaultCenter rs_addObserverForName:name object:nil] subscribeNext:^(id x) {
            fired = YES;
        }];
    }
    [NSNotificationCenter.defaultCenter postNotificationName:name object:nil];

    XCTAssertTrue(fired, @"和 map 链一样的写法，通知信号却因为没人持有而随 autoreleasepool 释放、observer 被移除");
}

@end
