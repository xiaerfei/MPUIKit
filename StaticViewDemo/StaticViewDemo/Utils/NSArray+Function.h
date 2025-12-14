//
//  NSArray+Function.h
//  TVUAnywhere
//
//  Created by sharexia on 10/26/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (Function)
- (NSArray *)map:(id (^)(id obj))block;
- (NSArray *)filter:(BOOL (^)(id obj))block;
- (BOOL)contains:(BOOL (^)(id obj))block;
- (id)reduce:(id)initial
       block:(id (^)(id obj1, id obj2))block;
@end

NS_ASSUME_NONNULL_END
