//
//  TVUMPView.m
//  TVUMPOSX
//
//  Created by erfeixia on 2025/3/13.
//

#import "TVUMPView.h"

@implementation TVUMPView

- (instancetype)init
{
    self = [super init];
    if (self) {
#if TARGET_OS_OSX
        self.wantsLayer = YES;
        self.backgroundColor = [NSColor clearColor];
#endif
    }
    return self;
}

#if TARGET_OS_OSX
- (BOOL)wantsUpdateLayer {
    return YES;
}
- (void)updateLayer {
    if (self.backgroundColor) {
        self.layer.backgroundColor = self.backgroundColor.CGColor;
    } else {
        self.layer.backgroundColor = [NSColor clearColor].CGColor;
    }
}
#endif

@end
