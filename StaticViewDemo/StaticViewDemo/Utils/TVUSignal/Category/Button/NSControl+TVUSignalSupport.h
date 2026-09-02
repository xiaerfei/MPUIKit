//
//  Test.h
//  macOSExample
//
//  Created by erfeixia on 2024/2/23.
//

#if TARGET_OS_OSX

#import <Cocoa/Cocoa.h>
#import "TVURSignal.h"
NS_ASSUME_NONNULL_BEGIN

@interface NSControl(TVUSignalSupport)
- (TVURSignal *)rs_signalForControlEvent;
@end

NS_ASSUME_NONNULL_END

#endif
