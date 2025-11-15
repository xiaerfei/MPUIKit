//
//  TVUPLRowData.h
//  TVUCollectionView
//
//  Created by erfeixia on 2025/11/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TVUPLRowData : NSObject
- (TVUPLRowData *(^)(NSString *title))title;
- (TVUPLRowData *(^)(id titleFont))titleFont;
- (TVUPLRowData *(^)(id titleColor))titleColor;
- (TVUPLRowData *(^)(NSString *key, id value))custom;
@end

NS_ASSUME_NONNULL_END
