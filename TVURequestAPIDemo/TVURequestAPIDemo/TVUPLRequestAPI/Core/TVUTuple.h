//
//  TVUTuple.h
//  Pods
//
//  Created by sharexia on 4/29/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*
    使用方式：
    TVUTuple *tuple = [TVUTuple new];
    tuple[0] = value0;
    tuple[1] = value1;
    tuple[2] = value2;
 
    TVUTuple 最大支持 0 ~ 9 个索引
 */
@interface TVUTuple : NSObject <NSCopying>

- (id)objectAtIndexedSubscript:(NSUInteger)index;
- (void)setObject:(id)object atIndexedSubscript:(NSUInteger)index;

- (id)objectForKeyedSubscript:(NSString *)key;
- (void)setObject:(id)object forKeyedSubscript:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
