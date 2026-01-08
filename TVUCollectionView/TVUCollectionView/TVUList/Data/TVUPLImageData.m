//
//  TVUPLImageData.m
//  TVUCollectionView
//
//  Created by TVUM4Pro on 2026/1/8.
//

#import "TVUPLImageData.h"


@interface TVUPLImageData ()
@property (nonatomic,   copy, readwrite) NSString *mkey;
@property (nonatomic, strong, readwrite) UIImage *mimage;
@property (nonatomic,   copy, readwrite) NSString *micon;
@property (nonatomic,   copy, readwrite) NSString *msystemIcon;
@property (nonatomic, assign, readwrite) CGSize msize;
@property (nonatomic, strong, readwrite) id mtintColor;

@property (nonatomic, strong) NSMutableDictionary *dataDict;
@end

@implementation TVUPLImageData
- (instancetype)init {
    self = [super init];
    if (self) {
        self.dataDict = @{}.mutableCopy;
    }
    return self;
}



#define DotMethod(TYPE, NAME, PRONAME) \
- (TVUPLImageData *(^)(TYPE NAME))NAME { \
return ^(TYPE NAME) { \
self.PRONAME = NAME; \
return self; \
}; \
}

DotMethod(NSString *, key, mkey)
DotMethod(UIImage *, image, mimage)
DotMethod(NSString *, icon, micon)
DotMethod(NSString *, systemIcon, msystemIcon)
DotMethod(CGSize, size, msize)
DotMethod(id, tintColor, mtintColor)

///< 自定义
- (TVUPLImageData *(^)(NSString *key, id value))custom {
    return ^(NSString *key, id value) {
        if ([key isKindOfClass:NSString.class]) {
            self.dataDict[key] = value;
        }
        return self;
    };
}

- (id)customForKey:(NSString *)key {
    return [key isKindOfClass:NSString.class] ? self.dataDict[key] : nil;
}

@end
