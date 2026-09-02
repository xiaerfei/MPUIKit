//
//  NSEvent+TVUSignalSupport.m
//  TVUPartyline
//
//  Created by sharexia on 4/17/24.
//  Copyright © 2024 tvunetworks. All rights reserved.
//
#if TARGET_OS_OSX
#import "NSEvent+TVUSignalSupport.h"
#import "TVURSmetamacros.h"

@implementation NSEvent (TVUSignalSupport)
+ (TVURSignal <NSEvent *>*)rs_addLocalMonitorForEventsMatchingMask:(NSEventMask)mask {
    TVURSignal *signal = [TVURSignal signal];
    @weakify(signal);
    id localMonitor =
    [NSEvent addLocalMonitorForEventsMatchingMask:mask
                                          handler:^NSEvent * _Nullable(NSEvent * _Nonnull event) {
        @strongify(signal)
        [signal sendNext:event];
        return event;
    }];
    [signal addDisposableWithBlock:^{
        TVURSLog(@"RSignal: remove localMonitor");
        [NSEvent removeMonitor:localMonitor];
    }];
    return signal;
}

+ (TVURSignal <NSEvent *>*)rs_addGlobalMonitorForEventsMatchingMask:(NSEventMask)mask {
    TVURSignal *signal = [TVURSignal signal];
    @weakify(signal);
    id globalMonitor =
    [NSEvent addGlobalMonitorForEventsMatchingMask:mask
                                           handler:^(NSEvent * _Nonnull event) {
        @strongify(signal)
        [signal sendNext:event];
    }];
    [signal addDisposableWithBlock:^{
        TVURSLog(@"RSignal: remove globalMonitor");
        [NSEvent removeMonitor:globalMonitor];
    }];
    return signal;
}
@end
#endif
