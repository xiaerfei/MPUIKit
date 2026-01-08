//
//  TVUPLLabelData.h
//  TVUCollectionView
//
//  Created by TVUM4Pro on 2026/1/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TVUPLLabelData : NSObject

@property (nonatomic,   copy, readonly) NSString *mkey;
@property (nonatomic,   copy, readonly) NSString *mtext;
@property (nonatomic, strong, readonly) UIFont *mfont;
@property (nonatomic, strong, readonly) id mtextColor;
@property (nonatomic, assign, readonly) NSTextAlignment mtextAlignment;
@property (nonatomic, assign, readonly) NSLineBreakMode mlineBreakMode;
@property (nonatomic, assign, readonly) NSInteger mnumberOfLines;
@property (nonatomic,   copy, readonly) NSAttributedString *mattributedText;


- (TVUPLLabelData *(^)(NSString * _Nullable key))key;
- (TVUPLLabelData *(^)(NSString * _Nullable text))text;
- (TVUPLLabelData *(^)(UIFont * _Nullable font))font;
- (TVUPLLabelData *(^)(id _Nullable textColor))textColor;
- (TVUPLLabelData *(^)(NSTextAlignment textAlignment))textAlignment;
- (TVUPLLabelData *(^)(NSLineBreakMode lineBreakMode))lineBreakMode;
- (TVUPLLabelData *(^)(NSInteger numberOfLines))numberOfLines;
- (TVUPLLabelData *(^)(NSAttributedString * _Nullable attributedText))attributedText;
///< 自定义
- (TVUPLLabelData *(^)(NSString *key, id value))custom;
- (id)customForKey:(NSString *)key;


@end

NS_ASSUME_NONNULL_END
