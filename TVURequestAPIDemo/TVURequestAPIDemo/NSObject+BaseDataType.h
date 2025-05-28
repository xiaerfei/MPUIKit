//
//  NSObject+BaseDataType.h
//  TVUAnywhere
//
//  Created by sharexia on 2022/9/5.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

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


NS_ASSUME_NONNULL_BEGIN

@interface NSObject (BaseDataType)

- (BOOL)isDictionary;
- (BOOL)isNumber;
- (BOOL)isArray;
- (BOOL)isNull;

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
- (NSError *)toErrorValue;
@end

NS_ASSUME_NONNULL_END
