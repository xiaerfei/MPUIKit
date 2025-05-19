//
//  HTStack.h
//  TVUMPIOS
//
//  Created by erfeixia on 2025/3/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class HTStack;
HTStack *HStack(NSArray <UIView *>*views);

@interface HTStack : UIStackView
+ (HTStack* (^)(NSArray <UIView *>*))stack;


- (HTStack *(^)(CGFloat))padding;
- (HTStack *(^)(UIView *))bind;

@end

NS_ASSUME_NONNULL_END
