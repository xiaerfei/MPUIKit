//
//  TVUPLAPIManager.h
//  MyStreamDemo
//
//  Created by sharexia on 4/16/25.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@class TVUPLRequestAPI;

@interface TVUPLAPIManager : NSObject
+ (instancetype)manager;
- (void)retryWithAPI:(TVUPLRequestAPI *)api;
- (void)removeRetryWithAPI:(TVUPLRequestAPI *)api;
- (void)removeWithAPI:(TVUPLRequestAPI *)api;
- (void)removeAllRetry;
- (NSInteger)generateRequestId;
@end

NS_ASSUME_NONNULL_END
