//
//  Test.m
//  Pods
//
//  Created by erfeixia on 2024/2/24.
//

#import "NSNotificationCenter+TVUSignalSupport.h"
#import "TVURSmetamacros.h"
@implementation NSNotificationCenter (TVUSignalSupport)
- (TVURSignal *)rs_addObserverForName:(nullable NSString *)notificationName object:(nullable id)object {
    TVURSignal *signal = [TVURSignal signal];
    
    @weakify(signal);
    id observer = [self addObserverForName:notificationName 
                                    object:object
                                     queue:nil
                                usingBlock:^(NSNotification *note) {
        @strongify(signal)
        [signal sendNext:note];
    }];
    
    [signal addDisposableWithBlock:^{
        TVURSLog(@"RSignal: remove Observer: %@", notificationName);
        [self removeObserver:observer];
    }];
    return signal;
}
@end
