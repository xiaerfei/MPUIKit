//
//  TVUTuple.m
//  Pods
//
//  Created by sharexia on 4/29/24.
//

#import "TVUTuple.h"

@interface TVUTuple ()
@property (nonatomic, strong) id value0;
@property (nonatomic, strong) id value1;
@property (nonatomic, strong) id value2;
@property (nonatomic, strong) id value3;
@property (nonatomic, strong) id value4;
@property (nonatomic, strong) id value5;
@property (nonatomic, strong) id value6;
@property (nonatomic, strong) id value7;
@property (nonatomic, strong) id value8;
@property (nonatomic, strong) id value9;
@end

@implementation TVUTuple

+ (instancetype)tupleWithArray:(NSArray *)array {
    TVUTuple *tuple = [[self alloc] init];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
#if DEBUG
        NSAssert(idx < 9, @"最多支持9个元素");
#endif
        if (obj == [NSNull null]) {
            obj = nil;
        }
        [tuple setObject:obj atIndexedSubscript:idx];
    }];
    return tuple;
}

+ (instancetype)tupleWithValues:(id)first, ... {
    va_list args;
    va_start(args, first);
    NSMutableArray *tempArray = [NSMutableArray array];
    
    id end = TVUTupleSentinel;

    for (id current = first; current != end; current = va_arg(args, id)) {
        [tempArray addObject:(current ?: NSNull.null)];
    }
    va_end(args);
    return [TVUTuple tupleWithArray:tempArray.copy];
}

- (id)objectAtIndexedSubscript:(NSUInteger)index {
    @synchronized (self) {
        switch (index) {
            case 0: return self.value0;
            case 1: return self.value1;
            case 2: return self.value2;
            case 3: return self.value3;
            case 4: return self.value4;
            case 5: return self.value5;
            case 6: return self.value6;
            case 7: return self.value7;
            case 8: return self.value8;
            case 9: return self.value9;
            default:
            {
#if DEBUG
                NSString *error = [NSString stringWithFormat:@"index out of bounds[0-9]:%ld", index];
                NSAssert(NO, error);
#endif
                break;
            }
        }
        return nil;
    }
}

- (void)setObject:(id)object atIndexedSubscript:(NSUInteger)index {
    @synchronized (self) {
        switch (index) {
            case 0: { self.value0 = object; break; }
            case 1: { self.value1 = object; break; }
            case 2: { self.value2 = object; break; }
            case 3: { self.value3 = object; break; }
            case 4: { self.value4 = object; break; }
            case 5: { self.value5 = object; break; }
            case 6: { self.value6 = object; break; }
            case 7: { self.value7 = object; break; }
            case 8: { self.value8 = object; break; }
            case 9: { self.value9 = object; break; }
            default:
            {
#if DEBUG
                NSString *error = [NSString stringWithFormat:@"index out of bounds[0-9]:%ld", index];
                NSAssert(NO, error);
#endif
                break;
            }
        }
    }
}

- (id)objectForKeyedSubscript:(NSString *)key {
    return nil;
}

- (void)setObject:(id)object forKeyedSubscript:(NSString *)key {
}

- (id)copyWithZone:(nullable NSZone *)zone {
    @synchronized (self) {
        TVUTuple *tuple = [TVUTuple new];
        tuple.value0 = self.value0;
        tuple.value1 = self.value1;
        tuple.value2 = self.value2;
        tuple.value3 = self.value3;
        tuple.value4 = self.value4;
        tuple.value5 = self.value5;
        tuple.value6 = self.value6;
        tuple.value7 = self.value7;
        tuple.value8 = self.value8;
        tuple.value9 = self.value9;
        return tuple;        
    }
}

// 哨兵
+ (id)endOfArgs {
    static NSObject *sentinel = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sentinel = [[NSObject alloc] init];
    });
    return sentinel;
}


#define GETFuncMacro(NAME, VALUE) \
- (id)NAME { \
    @synchronized (self) { \
        return self.VALUE; \
    } \
}

#define SETFuncMacro(NAME, VALUE) \
- (void)set##NAME:(id)VALUE { \
    @synchronized (self) { \
        self.VALUE = VALUE; \
    } \
}

GETFuncMacro(first, value0)
SETFuncMacro(First, value0)

GETFuncMacro(second, value1)
SETFuncMacro(Second, value1)

GETFuncMacro(third, value2)
SETFuncMacro(Third, value2)

GETFuncMacro(fourth, value3)
SETFuncMacro(Fourth, value3)

GETFuncMacro(fifth, value4)
SETFuncMacro(Fifth, value4)

GETFuncMacro(sixth, value5)
SETFuncMacro(Sixth, value5)

GETFuncMacro(seventh, value6)
SETFuncMacro(Seventh, value6)

GETFuncMacro(eighth, value7)
SETFuncMacro(Eighth, value7)

GETFuncMacro(ninth, value8)
SETFuncMacro(Ninth, value8)

GETFuncMacro(lastone, value9)
SETFuncMacro(Lastone, value9)
@end
