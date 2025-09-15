//
//  NSObject+BaseDataType.h
//  TVUAnywhere
//
//  Created by sharexia on 2022/9/5.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "NSArray+Function.h"

#define TVUCategoryRetainPropertyMethods(UppercaseName, LowercaseName, MemeryType, DataType)\
- (void)set##UppercaseName:( DataType ) LowercaseName {\
objc_setAssociatedObject(self, @selector( LowercaseName ), LowercaseName , MemeryType);\
}\
\
- ( DataType )LowercaseName {\
    return objc_getAssociatedObject(self, @selector(LowercaseName));\
}

#define TVUCategoryAssignPropertyMethods(UppercaseName, LowercaseName, MemeryType, DataType, DataTypeValue)\
- (void)set##UppercaseName:( DataType ) LowercaseName {\
objc_setAssociatedObject(self, @selector( LowercaseName ), @(LowercaseName) , MemeryType);\
}\
\
- ( DataType )LowercaseName {\
    return ( DataType )[objc_getAssociatedObject(self, @selector(LowercaseName)) DataTypeValue];\
}
/// 如果 obj 为 nil/Null 则返回 @""(空字符串)
#define NoNullStr(obj) [NSObject toNoNullString:obj]
/// 如果 obj 为 nil/Null 则返回 YES
#define EqualNull(obj) [NSObject equalNullValue:obj]

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (BaseDataType)

- (BOOL)isDictionary;
- (BOOL)isNumber;
- (BOOL)isArray;
- (BOOL)isNull;

/// 如果 obj 为 nil/Null 则返回 @""(空字符串)
+ (NSString *)toNoNullString:(id)obj;
/// 如果 obj 为 nil/Null 则返回 YES
+ (BOOL)equalNullValue:(id)obj;
#pragma mark - string
- (BOOL)isString;
- (NSString *)toStringValue;
///< 判断字符串是否全为空格
- (BOOL)isBlank;
///< 移除字符串首尾的空格
- (NSString *)trimmingWhitespace;
///< 移除字符串中所有的空格
- (NSString *)removeWhitespace;
- (NSDictionary *)toDictionaryValue;
#pragma mark - number
- (NSInteger)toIntegerValue;
- (BOOL)toBoolValue;
- (int)toIntValue;
@end

NS_ASSUME_NONNULL_END

