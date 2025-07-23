//
//  NSArray+Function.m
//  TVUAnywhere
//
//  Created by sharexia on 10/26/23.
//

#import "NSArray+Function.h"

@implementation NSArray (Function)
- (NSArray *)map:(id (^)(id obj))block {
    NSMutableArray *mutableArray = [NSMutableArray new];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id value = block(obj);
        if (value) {
            [mutableArray addObject:value];
        }
    }];
    return [mutableArray copy];
}

- (NSArray *)filter:(BOOL (^)(id obj))block {
    NSMutableArray *mutableArray = [NSMutableArray new];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (block(obj) == YES) {
            [mutableArray addObject:obj];
        }
    }];
    return [mutableArray copy];
}

- (BOOL)contains:(BOOL (^)(id obj))block {
    __block BOOL contains = NO;
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (block(obj) == YES) {
            contains = YES;
            *stop = YES;
        }
    }];
    return contains;
}

- (id)reduce:(id)initial
       block:(id (^)(id obj1, id obj2))block {
    __block id obj = initial;
    [self enumerateObjectsUsingBlock:^(id _obj, NSUInteger idx, BOOL *stop) {
        obj = block(obj, _obj);
    }];
    return obj;
}
@end
