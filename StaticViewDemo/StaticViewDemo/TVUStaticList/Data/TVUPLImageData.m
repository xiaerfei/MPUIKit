//
//  TVUPLImageData.m
//  StaticViewDemo
//
//  Created by erfeixia on 2026/1/24.
//

#import "TVUPLImageData.h"

@interface TVUPLImageData ()
@property (nonatomic, strong, readwrite) UIImage *mimage;
@property (nonatomic,   copy, readwrite) NSString *micon;
@property (nonatomic,   copy, readwrite) NSString *msystemIcon;
@property (nonatomic, assign, readwrite) CGSize msize;
@property (nonatomic, strong, readwrite) id mtintColor;
@end

@implementation TVUPLImageData
#define DotMethod(TYPE, NAME, PRONAME) \
- (TVUPLImageData *(^)(TYPE NAME))NAME { \
return ^(TYPE NAME) { \
self.PRONAME = NAME; \
return self; \
}; \
}

DotMethod(UIImage  *, image, mimage)
DotMethod(NSString *, icon, micon)
DotMethod(NSString *, systemIcon, msystemIcon)
DotMethod(CGSize, size, msize)
DotMethod(id, tintColor, mtintColor)

- (void)configure:(UIImageView *)imageView {
    if (self.mimage) {
        imageView.image = self.mimage;
    } else {
        if (self.msystemIcon) {
            imageView.image = [UIImage systemImageNamed:self.msystemIcon];
        } else if (self.micon) {
            imageView.image = [UIImage imageNamed:self.micon];
        } else {
            imageView.image = nil;
        }
    }
    imageView.tintColor = self.mtintColor ? self.mtintColor : nil;
}

@end
