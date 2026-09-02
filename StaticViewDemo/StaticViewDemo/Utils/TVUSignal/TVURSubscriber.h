//
//  TVURSubscriber.h
//
//  Created by 夏二飞 on 2024/1/28.
//

#import <Foundation/Foundation.h>
#import "TVURSDisposable.h"
NS_ASSUME_NONNULL_BEGIN

@interface TVURSubscriber : NSObject

// Creates a new subscriber with the given blocks.
+ (instancetype)subscriberWithNext:(nullable void (^)(id x))next
                             error:(nullable void (^)(NSError *error))error
                         completed:(nullable void (^)(void))completed;

@property (nonatomic, strong, nullable) TVURSDisposable *disposable;
@property (nonatomic,   copy, nullable) NSString *name;
- (void)sendNext:(nullable id)value;

- (void)sendError:(nullable NSError *)error;

- (void)sendCompleted;
@end

NS_ASSUME_NONNULL_END
