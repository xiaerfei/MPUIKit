//
//  TVUPLRowProtocol.h
//  TVURequestAPIDemo
//
//  Created by TVUM4Pro on 2025/7/16.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN
extern NSString *const kTVUPLRowHeight;
extern NSString *const kTVUPLRowData;
extern NSString *const kTVUPLRowType;
extern NSString *const kTVUPLRowKey;

extern NSString *const kTVUPLRowTitle;
extern NSString *const kTVUPLRowSubtitle;
extern NSString *const kTVUPLRowImage;
extern NSString *const kTVUPLRowValue;

extern NSString *const kTVUPLRowIndicatorImage;
extern NSString *const kTVUPLRowShowIndicator;
typedef NS_ENUM(NSInteger, TVUPLRowType) {
    TVUPLRowTypeDefault,
    TVUPLRowTypeSwitch,
    TVUPLRowTypeLogin,
    TVUPLRowTypeUnLogin,
    TVUPLRowTypeCenterText,
    TVUPLRowTypeButton,
};

#define TVUColorWithRHedix(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@protocol TVUPLRowProtocol <NSObject>
@property (nonatomic,   copy) void (^didSelectedBlock)(id _Nullable value);
- (void)reloadWithData:(id)data;

@end

NS_ASSUME_NONNULL_END
