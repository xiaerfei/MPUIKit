//
//  Test.m
//  macOSExample
//
//  Created by erfeixia on 2024/2/23.
//
#if TARGET_OS_OSX
#import "NSControl+TVUSignalSupport.h"
#import <objc/runtime.h>

@interface NSControl ()

@property (nonatomic, strong) TVURSignal *innerSignal;

@end

@implementation NSControl(TVUSignalSupport)

- (TVURSignal *)rs_signalForControlEvent {
    if (!self.innerSignal) {
        self.innerSignal = [TVURSignal signal];
        self.target = self.innerSignal;
        self.action = @selector(sendNext:);
        __weak __typeof(self) weakSelf = self;
        [self.innerSignal addDisposableWithBlock:^{
            if (weakSelf.target == weakSelf.innerSignal) {
                weakSelf.target = nil;
                weakSelf.action = nil;
            }
        }];
    }
    return self.innerSignal;
}

- (void)setInnerSignal:(TVURSignal *)innerSignal {
    objc_setAssociatedObject(self,
                             @selector(innerSignal),
                             innerSignal,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (TVURSignal *)innerSignal {
    return objc_getAssociatedObject(self, @selector(innerSignal));
}
@end
#endif
