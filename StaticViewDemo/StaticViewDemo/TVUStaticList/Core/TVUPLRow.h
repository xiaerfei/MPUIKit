//
//  TVUPLRow.h
//  TVUCollectionView
//
//  Created by erfeixia on 2025/9/13.
//
#import <UIKit/UIKit.h>
#import "TVUPLRowData.h"


#define RowUse(identifier) [[TVUPLRow alloc] initWithIdentifier:identifier]
#define RowData  return [TVUPLRowData new]

extern NSString *const kTVUPLDataTitle   ;
extern NSString *const kTVUPLDataSubtitle;
extern NSString *const kTVUPLDataImage   ;
extern NSString *const kTVUPLDataKey0    ;
extern NSString *const kTVUPLDataKey1    ;
extern NSString *const kTVUPLDataKey2    ;
extern NSString *const kTVUPLDataKey3    ;
extern NSString *const kTVUPLDataKey4    ;
extern NSString *const kTVUPLDataKey5    ;
extern NSString *const kTVUPLDataKey6    ;
extern NSString *const kTVUPLDataKey7    ;
extern NSString *const kTVUPLDataKey8    ;
extern NSString *const kTVUPLDataKey9    ;


typedef NS_ENUM(NSInteger, TVUPLRowType) {
    TVUPLRowTypeDefault,
    TVUPLRowTypeHeader,
    TVUPLRowTypeFooter
};

@class TVUPLSection, TVUPLBaseRow;

@interface TVUPLRow : NSObject
@property (nonatomic,   copy, readonly) NSString *rKey;
@property (nonatomic,   copy, readonly) NSString *rIdentifier;
@property (nonatomic, assign, readonly) UIEdgeInsets rInsets;
@property (nonatomic, assign, readonly) UIEdgeInsets rLineInsets;
@property (nonatomic, strong, readonly) UIColor *rLineColor;
@property (nonatomic, assign, readonly) BOOL rhiddenLine;
///< header、footer 或者 Cell 只有一行则强制显示
@property (nonatomic, assign, readonly) BOOL rforceShowLine;
@property (nonatomic, assign, readonly) BOOL rhidden;
@property (nonatomic, assign, readonly) BOOL rshowIndicator;
@property (nonatomic,   copy, readonly) NSString *rIndicatorImageName;
@property (nonatomic, strong, readonly) UIColor *rIndicatorColor;
@property (nonatomic, assign, readonly) BOOL rUnselected;
@property (nonatomic, assign, readonly) BOOL rUnselectedStyle;
@property (nonatomic, assign, readonly) BOOL rShowLeftImage;
@property (nonatomic, assign, readonly) CGFloat rHeight;

@property (nonatomic, strong, readonly) id rRowData;

@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) NSInteger row;

@property (nonatomic,   copy, readonly) void (^rDidSelectedBlock)(TVUPLRow *row, id value);
@property (nonatomic,   copy, readonly) void (^rFetchRowParameterBlock)(TVUPLRow *row);

@property (nonatomic, assign) NSInteger tag;

@property (nonatomic, assign, readonly) TVUPLRowType rrowType;
@property (nonatomic,   copy, readonly) void(^rprefetch)(TVUPLRow *row);

@property (nonatomic, weak) TVUPLSection *rsection;
@property (nonatomic, strong) TVUPLBaseRow *rowView;

// 链式调用方法
- (TVUPLRow *(^)(NSString *key))key;
- (TVUPLRow *(^)(NSString *identifier))identifier;
- (TVUPLRow *(^)(UIEdgeInsets insets))insets;
- (TVUPLRow *(^)(UIEdgeInsets lineInsets))lineInsets;
- (TVUPLRow *(^)(UIColor *lineColor))lineColor;
- (TVUPLRow *(^)(BOOL hiddenLine))hiddenLine;
- (TVUPLRow *(^)(BOOL hidden))hidden;
- (TVUPLRow *(^)(BOOL showIndicator))showIndicator;
- (TVUPLRow *(^)(NSString *indicatorImageName))indicatorImageName;
- (TVUPLRow *(^)(UIColor *indicatorColor))indicatorColor;
- (TVUPLRow *(^)(BOOL unselected))unselected;
- (TVUPLRow *(^)(BOOL unselectedStyle))unselectedStyle;
- (TVUPLRow *(^)(CGFloat height))height;

- (TVUPLRow *(^)(void(^)(TVUPLRow *row, id value)))tap;
- (TVUPLRow *(^)(void(^)(TVUPLRow *row)))fetchRowParameterBlock;

- (TVUPLRow *(^)(TVUPLRowType rowType))type;
- (TVUPLRow *(^)(void(^)(TVUPLRow *row)))prefetch;

- (TVUPLRow *(^)(id (^)(void)))viewData;
- (id)customForKey:(NSString *)key;

- (instancetype)initWithIdentifier:(NSString *)identifier;
@end
