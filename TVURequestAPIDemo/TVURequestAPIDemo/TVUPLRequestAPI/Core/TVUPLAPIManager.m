//
//  TVUPLAPIManager.m
//  MyStreamDemo
//
//  Created by sharexia on 4/16/25.
//

#import "TVUPLAPIManager.h"
#import "TVUPLRequestAPI.h"

@interface TVUPLAPIRetryItem : NSObject
@property (nonatomic, strong) TVUPLRequestAPI *api;
@property (nonatomic, strong) NSTimer *timer;
@end
@implementation TVUPLAPIRetryItem
- (void)retry {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSTimeInterval interval = self.api.retryTime < 0.1 ? 0.1 : self.api.retryTime;
        NSLog(@"④ 开始 waiting timer interval=%f", interval);
        self.timer =
        [NSTimer timerWithTimeInterval:interval
                                target:self
                              selector:@selector(retryAction)
                              userInfo:nil
                               repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    });
}

- (void)retryAction {
    NSLog(@"⑤ 开始 Retry");
    [self.timer invalidate];
    self.timer = nil;
    TVUPLRequestAPI *api = self.api;
    [[TVUPLAPIManager manager] removeWithAPI:api];
    dispatch_async(dispatch_get_main_queue(), ^{
        [api start];
    });
}

- (void)cancel {
    void(^block)(void) = ^{
        [self.timer invalidate];
        self.timer = nil;
        [self.api stop];
    };
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

- (void)dealloc {
    NSLog(@"⑦ release retry item");
}

@end

@interface TVUPLAPIManager ()
@property (nonatomic, assign) NSInteger requestBaseId;
@property (nonatomic, strong) NSMutableDictionary *requestDict;
@end

@implementation TVUPLAPIManager
- (instancetype)init {
    self = [super init];
    if (self) {
        self.requestDict = [NSMutableDictionary dictionary];
    }
    return self;
}
#pragma mark - Private Methods
+ (instancetype)manager {
    static TVUPLAPIManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TVUPLAPIManager alloc] init];
    });
    return manager;
}

- (void)retryWithAPI:(TVUPLRequestAPI *)api {
    if (api == nil) return;
    @synchronized (self) {
        TVUPLAPIRetryItem *item = [TVUPLAPIRetryItem new];
        item.api = api;
        self.requestDict[@(api.requestId)] = item;
        [item retry];
    }
}
- (void)removeWithAPI:(TVUPLRequestAPI *)api {
    if (api == nil) return;
    @synchronized (self) {
        NSLog(@"⑥ remove API");
        self.requestDict[@(api.requestId)] = nil;
    }
}
- (void)removeRetryWithAPI:(TVUPLRequestAPI *)api {
    if (api == nil) return;
    @synchronized (self) {
        TVUPLAPIRetryItem *item = self.requestDict[@(api.requestId)];
        [item cancel];
        self.requestDict[@(api.requestId)] = nil;
    }
}

- (void)removeAllRetry {
    @synchronized (self) {
        NSArray <TVUPLAPIRetryItem *>*items = self.requestDict.allValues;
        for (TVUPLAPIRetryItem *item in items) {
            [self removeRetryWithAPI:item.api];
        }
    }
}

- (NSInteger)generateRequestId {
    @synchronized (self) {
        return self.requestBaseId++;
    }
}

@end
