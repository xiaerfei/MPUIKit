//
//  TVUPLLabelData.m
//  TVUCollectionView
//
//  Created by TVUM4Pro on 2026/1/8.
//

#import "TVUPLLabelData.h"

@interface TVUPLLabelData ()
@property (nonatomic,   copy, readwrite) NSString *mkey;
@property (nonatomic,   copy, readwrite) NSString *mtext;
@property (nonatomic, strong, readwrite) UIFont *mfont;
@property (nonatomic, strong, readwrite) id mtextColor;
@property (nonatomic, assign, readwrite) NSTextAlignment mtextAlignment;
@property (nonatomic, assign, readwrite) NSLineBreakMode mlineBreakMode;
@property (nonatomic, assign, readwrite) NSInteger mnumberOfLines;
@property (nonatomic,   copy, readwrite) NSAttributedString *mattributedText;

@property (nonatomic, strong) NSMutableDictionary *dataDict;
@end

@implementation TVUPLLabelData
- (instancetype)init {
    self = [super init];
    if (self) {
        self.dataDict = @{}.mutableCopy;
    }
    return self;
}

#define DotMethod(TYPE, NAME, PRONAME) \
- (TVUPLLabelData *(^)(TYPE NAME))NAME { \
return ^(TYPE NAME) { \
self.PRONAME = NAME; \
return self; \
}; \
}

DotMethod(NSString *, key, mkey)
DotMethod(NSString *, text, mtext)
DotMethod(UIFont *, font, mfont)
DotMethod(id, textColor, mtextColor)
DotMethod(NSTextAlignment, textAlignment, mtextAlignment)
DotMethod(NSLineBreakMode, lineBreakMode, mlineBreakMode)
DotMethod(NSInteger, numberOfLines, mnumberOfLines)
DotMethod(NSAttributedString *, attributedText, mattributedText)

///< 自定义
- (TVUPLLabelData *(^)(NSString *key, id value))custom {
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
