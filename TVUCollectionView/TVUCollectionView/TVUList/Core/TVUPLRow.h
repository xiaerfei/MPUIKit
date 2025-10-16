//
//  TVUPLRow.h
//  TVUCollectionView
//
//  Created by erfeixia on 2025/9/13.
//
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TVUPLRowType) {
    TVUPLRowTypeDefault,
    TVUPLRowTypeHeader,
    TVUPLRowTypeFooter
};

@interface TVUPLRow : NSObject
@property (nonatomic,   copy, readonly) NSString *rKey;
@property (nonatomic,   copy, readonly) NSString *rIdentifier;
@property (nonatomic, assign, readonly) UIEdgeInsets rInsets;
@property (nonatomic, assign, readonly) UIEdgeInsets rLineInsets;
@property (nonatomic, strong, readonly) UIColor *rLineColor;
@property (nonatomic, assign, readonly) BOOL rHiddenLine;
@property (nonatomic, assign, readonly) BOOL rHidden;
@property (nonatomic, assign, readonly) BOOL rShowIndicator;
@property (nonatomic,   copy, readonly) NSString *rIndicatorImageName;
@property (nonatomic, strong, readonly) UIColor *rIndicatorColor;
@property (nonatomic, assign, readonly) BOOL rUnselected;
@property (nonatomic, assign, readonly) BOOL rUnselectedStyle;
@property (nonatomic, assign, readonly) BOOL rShowLeftImage;
@property (nonatomic, assign, readonly) CGFloat rHeight;

@property (nonatomic, strong, readonly) id rRowData;

@property (nonatomic, assign, readonly) NSInteger section;
@property (nonatomic, assign, readonly) NSInteger row;

@property (nonatomic,   copy, readonly) void (^rDidSelectedBlock)(TVUPLRow *row, id value);
@property (nonatomic,   copy, readonly) void (^rFetchRowParameterBlock)(TVUPLRow *row);

@property (nonatomic, assign) NSInteger tag;

@property (nonatomic, assign, readonly) TVUPLRowType rrowType;

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
- (TVUPLRow *(^)(BOOL showLeftImage))showLeftImage;
- (TVUPLRow *(^)(CGFloat height))height;

- (TVUPLRow *(^)(id rowData))rowData;

- (TVUPLRow *(^)(void(^)(TVUPLRow *row, id value)))tap;
- (TVUPLRow *(^)(void(^)(TVUPLRow *row)))fetchRowParameterBlock;

- (TVUPLRow *(^)(TVUPLRowType rowType))rowType;

- (instancetype)initWithIdentifier:(NSString *)identifier;


- (void)reload;
@end
