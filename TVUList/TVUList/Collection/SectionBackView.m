//
//  SectionBackView.m
//  TVUList
//
//  Created by erfeixia on 2025/8/4.
//

#import "SectionBackView.h"

@implementation SectionBackView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 8; // 可选：添加圆角
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
}
@end
