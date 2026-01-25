//
//  TVUPLLabelData.h
//  StaticViewDemo
//
//  Created by erfeixia on 2026/1/24.
//

#import "TVUPLViewData.h"

NS_ASSUME_NONNULL_BEGIN

#define LabelData(KEY) ((TVUPLLabelData *)[TVUPLLabelData new].key(KEY))

@interface TVUPLLabelData : TVUPLViewData

@property (nonatomic,   copy, readonly) NSString *mtext;
@property (nonatomic, strong, readonly) UIFont *mfont;
@property (nonatomic, strong, readonly) id mtextColor;
@property (nonatomic, assign, readonly) NSTextAlignment mtextAlignment;
@property (nonatomic, assign, readonly) NSLineBreakMode mlineBreakMode;
@property (nonatomic, assign, readonly) NSInteger mnumberOfLines;
@property (nonatomic,   copy, readonly) NSAttributedString *mattributedText;

- (TVUPLLabelData *(^)(NSString * _Nullable text))text;
- (TVUPLLabelData *(^)(UIFont * _Nullable font))font;
- (TVUPLLabelData *(^)(id _Nullable textColor))textColor;
- (TVUPLLabelData *(^)(NSTextAlignment textAlignment))textAlignment;
- (TVUPLLabelData *(^)(NSLineBreakMode lineBreakMode))lineBreakMode;
- (TVUPLLabelData *(^)(NSInteger numberOfLines))numberOfLines;
- (TVUPLLabelData *(^)(NSAttributedString * _Nullable attributedText))attributedText;
@end

NS_ASSUME_NONNULL_END
