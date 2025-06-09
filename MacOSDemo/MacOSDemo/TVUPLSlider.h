// TVUPLSlider.h
#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface TVUPLSlider : NSView

// Single value slider
- (instancetype)initWithFrame:(NSRect)frameRect
                      minValue:(CGFloat)minValue
                      maxValue:(CGFloat)maxValue
                    currentValue:(CGFloat)currentValue;

@property (nonatomic, assign) CGFloat minValue;
@property (nonatomic, assign) CGFloat maxValue;
@property (nonatomic, assign) CGFloat currentValue;

@property (nonatomic, strong) NSColor *trackColor;


@property (nonatomic, copy) void (^valueChangedHandler)(CGFloat newValue);


@end

NS_ASSUME_NONNULL_END
