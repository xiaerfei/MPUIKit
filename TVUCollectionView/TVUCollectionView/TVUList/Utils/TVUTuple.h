//
//  TVUTuple.h
//  Pods
//
//  Created by sharexia on 4/29/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*0
    元组
 
    使用方式：
    TVUTuple *tuple = [TVUTuple new];
    tuple[0] = value0;
    tuple[1] = value1;
    tuple[2] = value2;
 
    TVUTuple 最大支持 0 ~ 9 个索引
 */


// 哨兵
#define TVUTupleSentinel [TVUTuple endOfArgs]
#define TVUTupleMake(...) [TVUTuple tupleWithValues:__VA_ARGS__, TVUTupleSentinel]
#define TVUTupleNil NSNull.null

@interface TVUTuple : NSObject <NSCopying>

+ (instancetype)tupleWithArray:(NSArray *)array;
+ (instancetype)tupleWithValues:(id)first, ...;

- (id)objectAtIndexedSubscript:(NSUInteger)index;
- (void)setObject:(nullable id)object atIndexedSubscript:(NSUInteger)index;

- (id)objectForKeyedSubscript:(NSString *)key;
- (void)setObject:(nullable id)object forKeyedSubscript:(NSString *)key;

// 哨兵
+ (id)endOfArgs;

- (id)first;
- (void)setFirst:(nullable id)value;

- (id)second;
- (void)setSecond:(nullable id)value;

- (id)third;
- (void)setThird:(nullable id)value;

- (id)fourth;
- (void)setFourth:(nullable id)value;

- (id)fifth;
- (void)setFifth:(nullable id)value;

- (id)sixth;
- (void)setSixth:(nullable id)value;

- (id)seventh;
- (void)setSeventh:(nullable id)value;

- (id)eighth;
- (void)setEighth:(nullable id)value;

- (id)ninth;
- (void)setNinth:(nullable id)value;

- (id)lastone;
- (void)setLastone:(nullable id)value;


@end

NS_ASSUME_NONNULL_END
