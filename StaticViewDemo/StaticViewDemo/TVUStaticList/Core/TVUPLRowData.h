//
//  TVUPLRowData.h
//  TVUCollectionView
//
//  Created by erfeixia on 2025/11/16.
//

#import <UIKit/UIKit.h>
#import "TVUPLLabelData.h"
#import "TVUPLImageData.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, TVUPLRowLayoutPriority) {
    TVUPLRowTitleRequired,
    TVUPLRowRightRequired,
    TVUPLRowCustomScale
};

@interface TVUPLRowData : NSObject

- (TVUPLRowData *(^)(id(^)(void)))viewData;
- (TVUPLRowData *(^)(CGFloat scale))rightScale;
- (TVUPLRowData *(^)(TVUPLRowLayoutPriority layout))layoutPriority;

///< 自定义
- (TVUPLRowData *(^)(NSString *key, id value))custom;

- (id)customForKey:(NSString *)key;

- (NSDictionary *)toRowDataDict;
@end

NS_ASSUME_NONNULL_END
