//
//  TVUPLImageData.h
//  StaticViewDemo
//
//  Created by erfeixia on 2026/1/24.
//

#import "TVUPLViewData.h"

NS_ASSUME_NONNULL_BEGIN

#define ImageData(KEY) ((TVUPLImageData *)[TVUPLImageData new].key(KEY))

@interface TVUPLImageData : TVUPLViewData
@property (nonatomic, strong, readonly) UIImage *mimage;
@property (nonatomic,   copy, readonly) NSString *micon;
@property (nonatomic,   copy, readonly) NSString *msystemIcon;
@property (nonatomic, assign, readonly) CGSize msize;
@property (nonatomic, strong, readonly) id mtintColor;

- (TVUPLImageData *(^)(UIImage * _Nullable image))image;
- (TVUPLImageData *(^)(NSString * _Nullable icon))icon;
- (TVUPLImageData *(^)(NSString * _Nullable systemIcon))systemIcon;
- (TVUPLImageData *(^)(CGSize size))size;
///< 支持 UIColor 实例、"#141414"、"0x141414"
- (TVUPLImageData *(^)(id _Nullable color))tintColor;

@end

NS_ASSUME_NONNULL_END
