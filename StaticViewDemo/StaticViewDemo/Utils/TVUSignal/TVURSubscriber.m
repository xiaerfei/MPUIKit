//
//  TVURSubscriber.m
//
//  Created by 夏二飞 on 2024/1/28.
//

#import "TVURSubscriber.h"
#import "TVURSmetamacros.h"
@interface TVURSDisposable ()
@property (nonatomic, weak) TVURSubscriber *subscriber;
@end

@interface TVURSubscriber ()
// These callbacks should only be accessed while synchronized on self.
@property (nonatomic, copy) void (^next)(id value);
@property (nonatomic, copy) void (^error)(NSError *error);
@property (nonatomic, copy) void (^completed)(void);

@end

@implementation TVURSubscriber
// Creates a new subscriber with the given blocks.
+ (instancetype)subscriberWithNext:(nullable void (^)(id x))next
                             error:(nullable void (^)(NSError *error))error
                         completed:(nullable void (^)(void))completed {
    TVURSubscriber *subscriber = [[self alloc] init];
    subscriber.next      = next;
    subscriber.error     = error;
    subscriber.completed = completed;
    return subscriber;
}

- (void)sendNext:(nullable id)value {
    @synchronized (self) {
        void (^nextBlock)(id) = [self.next copy];
        if (nextBlock == nil) return;
        nextBlock(value);
    }
}

- (void)sendError:(nullable NSError *)error {
    @synchronized (self) {
        void (^errorBlock)(id) = [self.error copy];
        if (errorBlock == nil) return;
        errorBlock(error);
    }
}

- (void)sendCompleted {
    @synchronized (self) {
        void (^completedBlock)(void) = [self.completed copy];
        if (completedBlock == nil) return;
        completedBlock();
    }
}

- (void)dealloc {
    if (self.name) {
        TVURSLog(@"RSignal: Subscriber release: %@", self.name);
    }
}

@end
