//
//  TVUPLSectionBackView.m
//  TVUCollectionView
//
//  Created by erfeixia on 2025/9/13.
//

#import "TVUPLSectionBackView.h"

NSString *const kTVUPLSectionBackReuse = @"kTVUPLSectionBackReuse";

@implementation TVUPLSectionBackView
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
