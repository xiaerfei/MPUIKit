//
//  Test.h
//  Pods
//
//  Created by erfeixia on 2024/2/24.
//

#import <Foundation/Foundation.h>
#import "TVURSignal.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSNotificationCenter (TVUSignalSupport)

// Sends the NSNotification every time the notification is posted.
- (TVURSignal *)rs_addObserverForName:(nullable NSString *)notificationName object:(nullable id)object;

@end

NS_ASSUME_NONNULL_END
