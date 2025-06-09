// TVUPLSlider.m
#import "TVUPLSlider.h"
#import <QuartzCore/QuartzCore.h>
#import "Masonry.h"

@interface TVUPLSlider ()

@property (nonatomic, strong) NSView *trackView;
@property (nonatomic, strong) NSView *progressView;
@property (nonatomic, strong) NSView *handleView;

@property (nonatomic) BOOL isDragging;
@property (nonatomic) NSInteger draggedHandleIndex;
@property (nonatomic, strong) MASConstraint *multiplieConstraint;
@property (nonatomic, assign) CGFloat lastNewValue;

@end

@implementation TVUPLSlider

- (instancetype)initWithFrame:(NSRect)frameRect {
    return [self initWithFrame:frameRect minValue:0 maxValue:1 currentValue:0.5];
}

- (instancetype)initWithFrame:(NSRect)frameRect
                     minValue:(CGFloat)minValue
                     maxValue:(CGFloat)maxValue
                 currentValue:(CGFloat)currentValue {
    self = [super initWithFrame:frameRect];
    if (self) {
        _minValue = minValue;
        _maxValue = maxValue;
        _currentValue = currentValue;
        [self configureUI];
    }
    return self;
}

- (void)configureUI {
    self.wantsLayer = YES;
    self.layer.backgroundColor = [NSColor clearColor].CGColor;

    [self configureTrackView];
    [self configureProgressView];
    [self configureHandleView];
    [self updateViews];
}


#pragma mark - Track view
- (void)configureTrackView {
    // Track view
    _trackView = [[NSView alloc] initWithFrame:NSZeroRect];
    _trackView.wantsLayer = YES;
    _trackView.layer.backgroundColor = [NSColor controlBackgroundColor].CGColor;
    [self addSubview:_trackView];
    [_trackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.right.mas_equalTo(self);
        make.height.mas_equalTo(self).multipliedBy(0.7f);
    }];
}
#pragma mark - Progress view
- (void)configureProgressView {
    // Progress view
    _progressView = [[NSView alloc] initWithFrame:NSZeroRect];
    _progressView.wantsLayer = YES;
    [self addSubview:_progressView];
    
    // 创建渐变层
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    // 设置渐变色 (这里是从蓝色到绿色的渐变)
    gradientLayer.colors = @[
        (id)[[NSColor systemBlueColor] colorWithAlphaComponent:0.8].CGColor,
        (id)[NSColor systemBlueColor].CGColor
    ];
    
    // 设置渐变方向 (0,0)到(1,1)表示从左上到右下
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    
    // 设置图层大小与视图相同
    gradientLayer.frame = _progressView.bounds;
    // 随着父视图 frame 改变
    gradientLayer.autoresizingMask = kCALayerWidthSizable | kCALayerHeightSizable;
    // 将渐变层添加到视图的图层中
    [_progressView.layer insertSublayer:gradientLayer atIndex:0];
}
#pragma mark - Handle view
- (void)configureHandleView {
    NSView *handle = [[NSView alloc] initWithFrame:NSZeroRect];
    handle.wantsLayer = YES;
    handle.layer.backgroundColor = [NSColor whiteColor].CGColor;
    handle.layer.borderColor = [NSColor systemBlueColor].CGColor;
    handle.layer.borderWidth = 2;

    _handleView = handle;
    [self addSubview:_handleView];
}

- (void)updateViews {
    // Position track and progress views
    CGFloat trackHeight = NSHeight(self.frame);
    if (trackHeight == 0) return;
    CGFloat trackWidth = NSWidth(self.frame);
    
    if (_handleView) {
        // Single value
        CGFloat position = [self positionForValue:_currentValue];
        CGFloat x = position - trackHeight/2.0f;
        CGFloat offset = 0;
        CGFloat handleWidth = trackHeight + offset;
        CGFloat progressHeight = trackHeight * 0.7;
        CGFloat progressY = (trackHeight - progressHeight) / 2.0f;
        if (x < 0) x = 0;

        if ((x + handleWidth) > trackWidth || NSMaxX(_handleView.frame) > trackWidth) {
            _progressView.frame = NSMakeRect(0, progressY, trackWidth, progressHeight);
            _handleView.frame = NSMakeRect(trackWidth - handleWidth, -offset/2.0f, handleWidth, handleWidth);
        } else {
            CGFloat progressWidth = position;
            _progressView.frame = NSMakeRect(0, progressY, progressWidth, progressHeight);
            _handleView.frame = NSMakeRect(x, -offset/2.0f, handleWidth, handleWidth);
        }
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        _progressView.layer.sublayers.firstObject.frame = _progressView.bounds;
        [CATransaction commit];
        
        if (_handleView.layer.cornerRadius == 0) {
            _handleView.layer.cornerRadius   = handleWidth / 2.0f;
            _trackView.layer.cornerRadius    = progressHeight / 2.0f;
            _progressView.layer.cornerRadius = progressHeight / 2.0f;
        }
    }
}

- (CGFloat)positionForValue:(CGFloat)value {
    CGFloat normalizedValue = (value - _minValue) / (_maxValue - _minValue);
    return normalizedValue * self.bounds.size.width;
}

- (CGFloat)valueForPosition:(CGFloat)position {
    CGFloat normalizedValue = position / self.bounds.size.width;
    CGFloat value = _minValue + normalizedValue * (_maxValue - _minValue);
    return MAX(_minValue, MIN(_maxValue, value));
}

- (void)mouseDown:(NSEvent *)event {
    NSPoint location = [self convertPoint:event.locationInWindow fromView:nil];
    
    if (_handleView) {
        // Single value
        if (NSPointInRect(location, _handleView.frame)) {
            _isDragging = YES;
        }
    }
}

- (void)mouseDragged:(NSEvent *)event {
    if (!_isDragging) return;
    
    NSPoint location = [self convertPoint:event.locationInWindow fromView:nil];
    CGFloat position = MAX(0, MIN(self.bounds.size.width, location.x));
    CGFloat newValue = [self valueForPosition:position];
    
    if (_handleView) {
        CGFloat value = (NSWidth(_progressView.frame)) / (NSWidth(self.bounds)) * 100;
        
        // Single value
        _currentValue = newValue;
        if (_valueChangedHandler &&
            value != self.lastNewValue) {
            _valueChangedHandler(value);
        }
        self.lastNewValue = value;
    }
    [self updateViews];
}

- (void)mouseUp:(NSEvent *)event {
    _isDragging = NO;
    _draggedHandleIndex = NSNotFound;
}

- (void)setFrame:(NSRect)frame {
    [super setFrame:frame];
    [self updateViews];
}

@end
