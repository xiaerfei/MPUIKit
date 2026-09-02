//
//  UIControl+TVURSignal.m
//  TestPrj
//
//  Created by sharexia on 2/21/24.
//

#import "UIControl+TVURSignal.h"
#import <objc/runtime.h>

@implementation UIControl (TVURSignal)

- (TVURSignal *)rs_signalForControlEvents:(UIControlEvents)controlEvents {
    /// 将之前信号移除
    [self setInnerEventSignal:nil];
    TVURSignal *signal = [TVURSignal signal];
    [self setInnerEventSignal:signal];
    [self addTarget:signal action:@selector(sendNext:) forControlEvents:controlEvents];
    return signal;
}

- (TVURSignal *)innerEventSignal {
    return objc_getAssociatedObject(self, @selector(innerEventSignal));
}

- (void)setInnerEventSignal:(TVURSignal *)signal {
    objc_setAssociatedObject(self, @selector(innerEventSignal), signal, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}


@end
