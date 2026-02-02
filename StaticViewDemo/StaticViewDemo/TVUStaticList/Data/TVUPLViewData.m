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
return self; \
}; \
}

@interface TVUPLViewData ()
@property (nonatomic,   copy, readwrite) NSString *mkey;
@property (nonatomic, strong, readwrite) id mbackgroundColor;
@property (nonatomic, assign, readwrite) CGFloat mcornerRadius;
@property (nonatomic, assign, readwrite) UIEdgeInsets minsets;
@property (nonatomic, assign, readwrite) BOOL mhidden;
@property (nonatomic, strong, readwrite) NSMutableDictionary *mdataDict;
@end

@implementation TVUPLViewData
- (instancetype)init {
    self = [super init];
    if (self) {
        self.mdataDict = @{}.mutableCopy;
    }
    return self;
}

DotMethod(NSString *, key, mkey)
DotMethod(id, backgroundColor, mbackgroundColor)
DotMethod(CGFloat, cornerRadius, mcornerRadius)
DotMethod(UIEdgeInsets, insets, minsets)
DotMethod(BOOL, hidden, mhidden)

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
    if (self.mbackgroundColor) {
        view.backgroundColor = self.mbackgroundColor;
    } else {
        view.backgroundColor = [UIColor clearColor];
    }
    
    view.layer.cornerRadius = self.mcornerRadius;
    view.layer.masksToBounds = self.mcornerRadius != 0;
    view.hidden = self.mhidden;
}
@end
