//
//  TVUPLLabelData.m
//  StaticViewDemo
//
//  Created by erfeixia on 2026/1/24.
//

#import "TVUPLLabelData.h"

#define DotMethod(TYPE, NAME, PRONAME) \
- (TVUPLLabelData *(^)(TYPE NAME))NAME { \
return ^(TYPE NAME) { \
self.PRONAME = NAME; \
[self markSet:@#PRONAME]; \
return self; \
}; \
}

@interface TVUPLLabelData ()
@property (nonatomic,   copy, readwrite) NSString *mtext;
@property (nonatomic, strong, readwrite) UIFont *mfont;
@property (nonatomic, strong, readwrite) id mtextColor;
@property (nonatomic, assign, readwrite) NSTextAlignment mtextAlignment;
@property (nonatomic, assign, readwrite) NSLineBreakMode mlineBreakMode;
@property (nonatomic, assign, readwrite) NSInteger mnumberOfLines;
@property (nonatomic,   copy, readwrite) NSAttributedString *mattributedText;
@end

@implementation TVUPLLabelData

DotMethod(NSString *, text, mtext)
DotMethod(UIFont *, font, mfont)
DotMethod(id, textColor, mtextColor)
DotMethod(NSTextAlignment, textAlignment, mtextAlignment)
DotMethod(NSLineBreakMode, lineBreakMode, mlineBreakMode)
DotMethod(NSInteger, numberOfLines, mnumberOfLines)
DotMethod(NSAttributedString *, attributedText, mattributedText)

- (void)configure:(UILabel *)label {
    [super configure:label];
    
    ///< 没显式设置过的属性不碰，保留 label 自身的默认样式
    if ([self isSet:@"mtextColor"])     label.textColor     = self.mtextColor;
    if ([self isSet:@"mfont"])          label.font          = self.mfont;
    if ([self isSet:@"mtextAlignment"]) label.textAlignment = self.mtextAlignment;
    if ([self isSet:@"mlineBreakMode"]) label.lineBreakMode = self.mlineBreakMode;
    if ([self isSet:@"mnumberOfLines"]) label.numberOfLines = self.mnumberOfLines;
    if (self.mattributedText) {
        label.attributedText = self.mattributedText;
    } else if (self.mtext) {
        label.text = self.mtext;
    } else {
        label.text = @"";
    }
}
@end
