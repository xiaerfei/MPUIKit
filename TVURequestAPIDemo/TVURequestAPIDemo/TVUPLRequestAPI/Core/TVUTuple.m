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
@end
