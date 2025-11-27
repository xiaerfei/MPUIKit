//
//  TVUPLRowData.h
//  TVUCollectionView
//
//  Created by erfeixia on 2025/11/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TVUPLRowLayoutPriority) {
    TVUPLRowTitleRequired,
    TVUPLRowRightRequired,
    TVUPLRowCustomScale
};

@interface TVUPLRowData : NSObject

- (TVUPLRowData *(^)(NSString *title))title;
- (TVUPLRowData *(^)(id font))titleFont;
- (TVUPLRowData *(^)(id color))titleColor;
- (TVUPLRowData *(^)(NSNumber *alignment))titleAlignment;
- (TVUPLRowData *(^)(NSNumber *lines))titleNumberOfLines;
- (TVUPLRowData *(^)(NSString *title))subtitle;
- (TVUPLRowData *(^)(id font))subtitleFont;
- (TVUPLRowData *(^)(id color))subtitleColor;
- (TVUPLRowData *(^)(id icon))icon;
- (TVUPLRowData *(^)(id icon))systemIcon;
- (TVUPLRowData *(^)(CGSize size))iconSize;
- (TVUPLRowData *(^)(id color))iconTintColor;
- (TVUPLRowData *(^)(BOOL on))switchOn;
- (TVUPLRowData *(^)(BOOL enabled))switchEnabled;
- (TVUPLRowData *(^)(NSString *bigWord))loginBigWord;
- (TVUPLRowData *(^)(NSString *value))rightValue;
- (TVUPLRowData *(^)(CGFloat scale))rightScale;
- (TVUPLRowData *(^)(TVUPLRowLayoutPriority layout))layoutPriority;

///< 自定义
- (TVUPLRowData *(^)(NSString *key, id value))custom;

- (NSDictionary *)toRowDataDict;
@end

NS_ASSUME_NONNULL_END
