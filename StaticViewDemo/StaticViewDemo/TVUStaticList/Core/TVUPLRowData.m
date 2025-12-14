//
//  TVUPLRowData.m
//  TVUCollectionView
//
//  Created by erfeixia on 2025/11/16.
//

#import "TVUPLRowData.h"
#import "TVUPLListConst.h"

@interface TVUPLRowData ()
@property (nonatomic, strong) NSMutableDictionary *rowDataDict;
@end

@implementation TVUPLRowData

- (instancetype)init {
    self = [super init];
    if (self) {
        self.rowDataDict = @{}.mutableCopy;
    }
    return self;
}

#pragma mark - Public Methods
- (TVUPLRowData *(^)(NSString *title))title {
    return ^(id title) {
        self.rowDataDict[kTVUPLRowTitle] = title;
        return self;
    };
}
- (TVUPLRowData *(^)(id font))titleFont {
    return ^(id font) {
        self.rowDataDict[kTVUPLRowTitleFont] = font;
        return self;
    };
}
- (TVUPLRowData *(^)(id color))titleColor {
    return ^(id color) {
        self.rowDataDict[kTVUPLRowTitleColor] = color;
        return self;
    };
}
- (TVUPLRowData *(^)(NSNumber *alignment))titleAlignment {
    return ^(NSNumber *alignment) {
        self.rowDataDict[kTVUPLRowTitleAlignment] = alignment;
        return self;
    };
}
- (TVUPLRowData *(^)(NSNumber *lines))titleNumberOfLines {
    return ^(NSNumber *lines) {
        self.rowDataDict[kTVUPLRowTitleNumberOfLines] = lines;
        return self;
    };
}
- (TVUPLRowData *(^)(NSString *title))subtitle {
    return ^(id title) {
        self.rowDataDict[kTVUPLRowSubtitle] = title;
        return self;
    };
}
- (TVUPLRowData *(^)(id font))subtitleFont {
    return ^(id font) {
        self.rowDataDict[kTVUPLRowSubtitleFont] = font;
        return self;
    };
}
- (TVUPLRowData *(^)(id color))subtitleColor {
    return ^(id color) {
        self.rowDataDict[kTVUPLRowSubtitleColor] = color;
        return self;
    };
}
- (TVUPLRowData *(^)(id icon))icon {
    return ^(id icon) {
        self.rowDataDict[kTVUPLRowIcon] = icon;
        return self;
    };
}
- (TVUPLRowData *(^)(id icon))systemIcon {
    return ^(id icon) {
        self.rowDataDict[kTVUPLRowSystemIcon] = icon;
        return self;
    };
}
- (TVUPLRowData *(^)(CGSize size))iconSize {
    return ^(CGSize size) {
        self.rowDataDict[kTVUPLRowIconSize] = [NSValue valueWithCGSize:size];
        return self;
    };
}
- (TVUPLRowData *(^)(id color))iconTintColor {
    return ^(id color) {
        self.rowDataDict[kTVUPLRowIconTintColor] = color;
        return self;
    };
}
- (TVUPLRowData *(^)(BOOL on))switchOn {
    return ^(BOOL on) {
        self.rowDataDict[kTVUPLRowSwitchOn] = @(on);
        return self;
    };
}
- (TVUPLRowData *(^)(BOOL enabled))switchEnabled {
    return ^(BOOL enabled) {
        self.rowDataDict[kTVUPLRowSwitchEnabled] = @(enabled);
        return self;
    };
}
- (TVUPLRowData *(^)(NSString *bigWord))loginBigWord {
    return ^(NSString * bigWord) {
        self.rowDataDict[kTVUPLRowLoginBigWord] = bigWord;
        return self;
    };
}
- (TVUPLRowData *(^)(NSString *value))rightValue {
    return ^(NSString * value) {
        self.rowDataDict[kTVUPLRowRightValue] = value;
        return self;
    };
}
- (TVUPLRowData *(^)(CGFloat scale))rightScale {
    return ^(CGFloat scale) {
        self.rowDataDict[kTVUPLRowRightScale] = @(scale);
        return self;
    };
}

- (TVUPLRowData *(^)(TVUPLRowLayoutPriority layout))layoutPriority {
    return ^(TVUPLRowLayoutPriority layout) {
        self.rowDataDict[kTVUPLRightPriority] = @(layout);
        return self;
    };
}

- (TVUPLRowData *(^)(NSString *key, id value))custom {
    return ^(NSString *key, id value) {
        if ([key isKindOfClass:NSString.class] == NO ||
            key.length == 0) {
            return self;
        } else {
            self.rowDataDict[key] = value;
            return self;
        }
    };
}

- (NSDictionary *)toRowDataDict {
    return self.rowDataDict.copy;
}

@end
