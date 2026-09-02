//
//  TVURSDisposable.m
//
//  Created by 夏二飞 on 2024/1/28.
//

#import "TVURSDisposable.h"
#import "TVURSubscriber.h"
#import "TVURSmetamacros.h"
@interface TVURSDisposable ()
@property (nonatomic, copy) void(^block)(void);
@property (nonatomic, weak) TVURSubscriber *subscriber;
@property (nonatomic,   copy, nullable) NSString *name;
@end

@implementation TVURSDisposable

+ (instancetype)disposableWithBlock:(void (^)(void))block {
    TVURSDisposable *dispose = [[TVURSDisposable alloc] init];
    dispose.block = block;
    return dispose;
}


- (void)dispose {
    @synchronized (self) {
        if (self.block) self.block();
        self.block = nil;
    }
}

- (TVURSDisposable *)setDebugName:(NSString *)name {
    self.subscriber.name = name;
    self.name = name;
    return self;
}

- (void)dealloc {
    [self dispose];
    if (self.name) {
        TVURSLog(@"RSignal: %@ dispose release", self.name);        
    }
}
@end
