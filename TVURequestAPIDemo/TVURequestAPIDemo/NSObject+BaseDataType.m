//
//  NSObject+BaseDataType.m
//  TVUAnywhere
//
//  Created by sharexia on 2022/9/5.
//

#import "NSObject+BaseDataType.h"

@implementation NSObject (BaseDataType)

- (BOOL)isDictionary {
    return [self isKindOfClass:NSDictionary.class];
}

- (BOOL)isString {
    return [self isKindOfClass:NSString.class];
}

- (BOOL)isNumber {
    return [self isKindOfClass:NSNumber.class];
}

- (BOOL)isArray {
    return [self isKindOfClass:NSArray.class];
}

- (BOOL)isNull {
    return [self isKindOfClass:NSNull.class];
}

- (NSString *)toStringValue {
    if (self.isString) {
        return (NSString *)self;
    }
    
    if (self.isNumber) {
        return [(NSNumber *)self stringValue];
    }
    
    if (self.isDictionary || self.isArray) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:self options:0 error:nil];
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    return @"";
}

- (NSError *)toErrorValue {
    if ([self isKindOfClass:NSError.class]) {
        return (NSError *)self;
    } else {
        return nil;
    }
}


///< 判断字符串是否全为空格
- (BOOL)isBlank {
    return [self trimmingWhitespace].length == 0;
}

///< 移除字符串首尾的空格
- (NSString *)trimmingWhitespace {
    if (!self.isString) {
        return nil;
    }
    NSString *str = (NSString *)self;
    if (str.length == 0) {
        return nil;
    }
    NSString *trimmedString = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return trimmedString;
}
///< 移除字符串中所有的空格
- (NSString *)removeWhitespace {
    if (!self.isString) {
        return nil;
    }
    NSString *str = (NSString *)self;
    if (str.length == 0) {
        return nil;
    }
    return [str stringByReplacingOccurrencesOfString:@" " withString:@""];
}
- (NSDictionary *)toDictionaryValue {
    if (!self || self == (id)kCFNull) return nil;
    NSDictionary *dic = nil;
    NSData *jsonData = nil;
    if ([self isKindOfClass:[NSDictionary class]]) {
        dic = (NSDictionary *)self;
    } else if ([self isKindOfClass:[NSString class]]) {
        jsonData = [(NSString *)self dataUsingEncoding : NSUTF8StringEncoding];
    } else if ([self isKindOfClass:[NSData class]]) {
        jsonData = (NSData *)self;
    }
    if (jsonData) {
        if (![NSJSONSerialization isValidJSONObject:jsonData]) {
            /// 不合法，可能是一个单一的字符串
            id value = [self jsonReadingFragmentsAllowed:jsonData];
            if ([value isDictionary]) {
                return  value;
            }
            if (!value || ![value isKindOfClass:NSData.class]) {
                return nil;
            }
            jsonData = value;
        }
        dic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
        if (![dic isKindOfClass:[NSDictionary class]]) dic = nil;
    }
    return dic;
}

- (id)jsonReadingFragmentsAllowed:(NSData *)data {
    id temp = [NSJSONSerialization JSONObjectWithData:data
                                              options:NSJSONReadingFragmentsAllowed
                                                error:NULL];
    if ([temp isArray]) {
        return nil;
    }
    if ([temp isDictionary]) {
        return temp;
    }
    
    if (![temp isString]) {
        return nil;
    }
    return [(NSString *)temp dataUsingEncoding : NSUTF8StringEncoding];
}

@end
