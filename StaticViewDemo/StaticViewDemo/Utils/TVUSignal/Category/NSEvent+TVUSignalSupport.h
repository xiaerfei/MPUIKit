//
//  NSEvent+TVUSignalSupport.h
//  TVUPartyline
//
//  Created by sharexia on 4/17/24.
//  Copyright © 2024 tvunetworks. All rights reserved.
//
#if TARGET_OS_OSX
#import <Cocoa/Cocoa.h>
#import "TVURSignal.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSEvent (TVUSignalSupport)
+ (TVURSignal <NSEvent *>*)rs_addLocalMonitorForEventsMatchingMask:(NSEventMask)mask;

+ (TVURSignal <NSEvent *>*)rs_addGlobalMonitorForEventsMatchingMask:(NSEventMask)mask;
@end

NS_ASSUME_NONNULL_END
#endif
