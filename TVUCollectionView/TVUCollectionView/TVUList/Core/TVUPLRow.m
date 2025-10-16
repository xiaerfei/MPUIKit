//
//  TVUPLRow.m
//  TVUCollectionView
//
//  Created by erfeixia on 2025/9/13.
//

#import "TVUPLRow.h"

@interface TVUPLRow ()
@property (nonatomic,   copy, readwrite) NSString *rKey;
@property (nonatomic,   copy, readwrite) NSString *rIdentifier;
@property (nonatomic, assign, readwrite) UIEdgeInsets rInsets;
@property (nonatomic, assign, readwrite) UIEdgeInsets rLineInsets;
@property (nonatomic, strong, readwrite) UIColor *rLineColor;
@property (nonatomic, assign, readwrite) BOOL rHiddenLine;
@property (nonatomic, assign, readwrite) BOOL rHidden;
@property (nonatomic, assign, readwrite) BOOL rShowIndicator;
@property (nonatomic,   copy, readwrite) NSString *rIndicatorImageName;
@property (nonatomic, strong, readwrite) UIColor *rIndicatorColor;
@property (nonatomic, assign, readwrite) BOOL rUnselected;
@property (nonatomic, assign, readwrite) BOOL rUnselectedStyle;
@property (nonatomic, assign, readwrite) BOOL rShowLeftImage;
@property (nonatomic, assign, readwrite) CGFloat rHeight;

@property (nonatomic, strong, readwrite) id rRowData;

@property (nonatomic, assign, readwrite) NSInteger section;
@property (nonatomic, assign, readwrite) NSInteger row;

@property (nonatomic,   copy, readwrite) void (^rDidSelectedBlock)(TVUPLRow *row, id value);
@property (nonatomic,   copy, readwrite) void (^rFetchRowParameterBlock)(TVUPLRow *row);

@property (nonatomic, assign, readwrite) TVUPLRowType rrowType;
@end

@implementation TVUPLRow
#pragma mark - Chainable Setters
- (TVUPLRow *(^)(NSString *key))key {
    return ^(NSString *key) {
        self.rKey = key;
        return self;
    };
}

- (TVUPLRow *(^)(NSString *identifier))identifier {
    return ^(NSString *identifier) {
        self.rIdentifier = identifier;
        return self;
    };
}

- (TVUPLRow *(^)(UIEdgeInsets insets))insets {
    return ^(UIEdgeInsets insets) {
        self.rInsets = insets;
        return self;
    };
}

- (TVUPLRow *(^)(UIEdgeInsets lineInsets))lineInsets {
    return ^(UIEdgeInsets lineInsets) {
        self.rLineInsets = lineInsets;
        return self;
    };
}

- (TVUPLRow *(^)(UIColor *lineColor))lineColor {
    return ^(UIColor *lineColor) {
        self.rLineColor = lineColor;
        return self;
    };
}

- (TVUPLRow *(^)(BOOL hiddenLine))hiddenLine {
    return ^(BOOL hiddenLine) {
        self.rHiddenLine = hiddenLine;
        return self;
    };
}

- (TVUPLRow *(^)(BOOL hidden))hidden {
    return ^(BOOL hidden) {
        self.rHidden = hidden;
        return self;
    };
}

- (TVUPLRow *(^)(BOOL showIndicator))showIndicator {
    return ^(BOOL showIndicator) {
        self.rShowIndicator = showIndicator;
        return self;
    };
}

- (TVUPLRow *(^)(NSString *indicatorImageName))indicatorImageName {
    return ^(NSString *indicatorImageName) {
        self.rIndicatorImageName = indicatorImageName;
        return self;
    };
}

- (TVUPLRow *(^)(UIColor *indicatorColor))indicatorColor {
    return ^(UIColor *indicatorColor) {
        self.rIndicatorColor = indicatorColor;
        return self;
    };
}

- (TVUPLRow *(^)(BOOL unselected))unselected {
    return ^(BOOL unselected) {
        self.rUnselected = unselected;
        return self;
    };
}

- (TVUPLRow *(^)(BOOL unselectedStyle))unselectedStyle {
    return ^(BOOL unselectedStyle) {
        self.rUnselectedStyle = unselectedStyle;
        return self;
    };
}

- (TVUPLRow *(^)(BOOL showLeftImage))showLeftImage {
    return ^(BOOL showLeftImage) {
        self.rShowLeftImage = showLeftImage;
        return self;
    };
}

- (TVUPLRow *(^)(CGFloat height))height {
    return ^(CGFloat height) {
        self.rHeight = height;
        return self;
    };
}

- (TVUPLRow *(^)(id rowData))rowData {
    return ^(id rowData) {
        self.rRowData = rowData;
        return self;
    };
}

- (TVUPLRow *(^)(void (^)(TVUPLRow *, id)))tap {
    return ^(void (^block)(TVUPLRow *row, id value)) {
        self.rDidSelectedBlock = block;
        return self;
    };
}

- (TVUPLRow *(^)(void (^)(TVUPLRow *)))fetchRowParameterBlock {
    return ^(void (^block)(TVUPLRow *row)) {
        self.rFetchRowParameterBlock = block;
        return self;
    };
}

- (TVUPLRow *(^)(TVUPLRowType rowType))rowType {
    return ^(TVUPLRowType rowType) {
        self.rrowType = rowType;
        return self;
    };
}

#pragma mark - Class Methods
- (instancetype)initWithIdentifier:(NSString *)identifier {
    self = [super init];
    if (self) {
        self.rIdentifier = identifier;
    }
    return self;
}
@end
