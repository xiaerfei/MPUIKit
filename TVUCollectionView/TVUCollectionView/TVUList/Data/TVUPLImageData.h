//
//  TVUPLImageData.h
//  TVUCollectionView
//
//  Created by TVUM4Pro on 2026/1/8.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface TVUPLImageData : NSObject

@property (nonatomic,   copy, readonly) NSString *mkey;
@property (nonatomic, strong, readonly) UIImage *mimage;
@property (nonatomic,   copy, readonly) NSString *micon;
@property (nonatomic,   copy, readonly) NSString *msystemIcon;
@property (nonatomic, assign, readonly) CGSize msize;
@property (nonatomic, strong, readonly) id mtintColor;

- (TVUPLImageData *(^)( NSString * _Nullable key))key;
- (TVUPLImageData *(^)(UIImage * _Nullable image))image;
- (TVUPLImageData *(^)(NSString * _Nullable icon))icon;
- (TVUPLImageData *(^)(NSString * _Nullable systemIcon))systemIcon;
- (TVUPLImageData *(^)(CGSize size))size;
///< 支持 UIColor 实例、"#141414"、"0x141414"
- (TVUPLImageData *(^)(id _Nullable color))tintColor;
///< 自定义
- (TVUPLImageData *(^)(NSString *key, id value))custom;
- (id)customForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
