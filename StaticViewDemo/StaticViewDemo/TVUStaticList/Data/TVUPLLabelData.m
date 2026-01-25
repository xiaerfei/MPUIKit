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
    
    label.textColor = self.mtextColor;
    label.font = self.mfont;
    label.textAlignment = self.mtextAlignment;
    label.lineBreakMode = self.mlineBreakMode;
    label.numberOfLines = self.mnumberOfLines;
    if (self.mattributedText) {
        label.attributedText = self.mattributedText;
    } else if (self.mtext) {
        label.text = self.mtext;
    } else {
        label.text = @"";
    }
}
@end
