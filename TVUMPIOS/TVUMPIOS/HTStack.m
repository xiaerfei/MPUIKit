//
//  HTStack.m
//  TVUMPIOS
//
//  Created by erfeixia on 2025/3/15.
//

#import "HTStack.h"

HTStack *HStack(NSArray <UIView *>*views) {
    return HTStack.stack(views);
}


@implementation HTStack
+ (HTStack *(^)(NSArray <UIView *>*))stack {
    return ^id(NSArray <UIView *>*views){
        HTStack *vstack = [[HTStack alloc] init];
        
        return vstack;
    };
}


- (HTStack *(^)(CGFloat))padding {
    return ^id(CGFloat padding) {
        

        return self;
    };
}

- (HTStack *(^)(UIView *))bind {
    return ^id(UIView * view) {
        
        return self;
    };
}

@end
