//
//  UIControl+TVURSignal.h
//  TestPrj
//
//  Created by sharexia on 2/21/24.
//

#import "TVURSignal.h"
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN


@interface UIControl (TVURSignal)
- (TVURSignal *)rs_signalForControlEvents:(UIControlEvents)controlEvents;
@end
NS_ASSUME_NONNULL_END
