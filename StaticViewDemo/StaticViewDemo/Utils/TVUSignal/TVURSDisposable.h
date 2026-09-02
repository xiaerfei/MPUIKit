//
//  TVURSDisposable.h
//
//  Created by 夏二飞 on 2024/1/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TVURSDisposable : NSObject

+ (instancetype)disposableWithBlock:(void (^)(void))block;
- (void)dispose;
- (TVURSDisposable *)setDebugName:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
