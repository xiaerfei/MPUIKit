//
//  TVUMPView.h
//  TVUMPOSX
//
//  Created by erfeixia on 2025/3/13.
//


#import <TargetConditionals.h>
#if TARGET_OS_OSX
#import <Cocoa/Cocoa.h>
#else
#import <UIKit/UIKit.h>
#endif

NS_ASSUME_NONNULL_BEGIN
#if TARGET_OS_OSX
@interface TVUMPView : NSView
#else
@interface TVUMPView : UIView
#endif

#if TARGET_OS_OSX
@property (nonatomic, strong) NSColor *backgroundColor;
#endif


@end

NS_ASSUME_NONNULL_END
