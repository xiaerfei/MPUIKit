//
//  TVUPLViewData.m
//  StaticViewDemo
//
//  Created by erfeixia on 2026/1/24.
//

#import "TVUPLViewData.h"

#define DotMethod(TYPE, NAME, PRONAME) \
- (TVUPLViewData *(^)(TYPE NAME))NAME { \
    return ^(TYPE NAME) { \
        self.PRONAME = NAME; \
        [self markSet:@#PRONAME]; \
        return self; \
    }; \
}

@interface TVUPLViewData ()
@property (nonatomic,   copy, readwrite) NSString *mkey;
@property (nonatomic, strong, readwrite) id mbackgroundColor;
@property (nonatomic, assign, readwrite) CGFloat mcornerRadius;
@property (nonatomic, assign, readwrite) UIEdgeInsets minsets;
@property (nonatomic, assign, readwrite) BOOL mhidden;
@property (nonatomic, assign, readwrite) CGRect mframe;
@property (nonatomic, strong, readwrite) NSMutableDictionary *mdataDict;
@property (nonatomic, strong) NSMutableSet <NSString *>*msetKeys;
@end

@implementation TVUPLViewData
- (instancetype)init {
    self = [super init];
    if (self) {
        self.mdataDict = @{}.mutableCopy;
        self.msetKeys = [NSMutableSet set];
    }
    return self;
}

#pragma mark - 框架内部
- (void)markSet:(NSString *)propertyName {
    if (propertyName.length) [self.msetKeys addObject:propertyName];
}

- (BOOL)isSet:(NSString *)propertyName {
    return [self.msetKeys containsObject:propertyName];
}

DotMethod(NSString *, key, mkey)
DotMethod(id, backgroundColor, mbackgroundColor)
DotMethod(CGFloat, cornerRadius, mcornerRadius)
DotMethod(UIEdgeInsets, insets, minsets)
DotMethod(BOOL, hidden, mhidden)
DotMethod(CGRect, frame, mframe)

///< 自定义
- (TVUPLViewData *(^)(NSString *key, id value))custom {
    return ^(NSString *key, id value) {
        if ([key isKindOfClass:NSString.class]) {
            self.mdataDict[key] = value;
        }
        return self;
    };
}

- (id)customForKey:(NSString *)key {
    return [key isKindOfClass:NSString.class] ? self.mdataDict[key] : nil;
}

- (void)configure:(UIView *)view {
    view.backgroundColor =
    self.mbackgroundColor ? self.mbackgroundColor : [UIColor clearColor];

    if ([self isSet:@"mcornerRadius"]) {
        view.layer.cornerRadius  = self.mcornerRadius;
        view.layer.masksToBounds = self.mcornerRadius != 0;
    }
    if ([self isSet:@"mhidden"]) {
        view.hidden = self.mhidden;
    }
}
@end
