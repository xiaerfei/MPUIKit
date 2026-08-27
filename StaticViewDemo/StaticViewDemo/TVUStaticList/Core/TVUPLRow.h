//
//  TVUPLRow.h
//  TVUCollectionView
//
//  Created by erfeixia on 2025/9/13.
//
#import <UIKit/UIKit.h>
#import "TVUPLLabelData.h"
#import "TVUPLImageData.h"
#import "TVUPLViewData.h"
#import "TVUPLState.h"

#define RowUse(identifier) [[TVUPLRow alloc] initWithIdentifier:identifier]
///< 默认样式行（kTVUPLDefaultRow），绝大多数行用它
#define RowDefault RowUse(kTVUPLDefaultRow)
#define RowData  return [TVUPLRowData new]

extern NSString *const kTVUPLDataTitle   ;
extern NSString *const kTVUPLDataSubtitle;
extern NSString *const kTVUPLDataValue   ;
extern NSString *const kTVUPLDataScale   ;
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

extern NSString *const kTVUPLDataLine;
extern NSString *const kTVUPLDataRow;

typedef NS_ENUM(NSInteger, TVUPLRowType) {
    TVUPLRowTypeDefault,
    TVUPLRowTypeHeader,
    TVUPLRowTypeFooter
};

@class TVUPLSection, TVUPLBaseRow, TVUStaticView, TVUPLState;

@interface TVUPLRow : NSObject
@property (nonatomic,   copy, readonly) NSString *mkey;
@property (nonatomic,   copy, readonly) NSString *midentifier;
@property (nonatomic, assign, readonly) UIEdgeInsets rInsets;
@property (nonatomic, assign, readonly) UIEdgeInsets rLineInsets;
@property (nonatomic, strong, readonly) UIColor *rLineColor;
@property (nonatomic, assign, readonly) BOOL rhiddenLine;
///< header、footer 或者 Cell 只有一行则强制显示
@property (nonatomic, assign, readonly) BOOL rforceShowLine;
@property (nonatomic, assign, readonly) BOOL rhidden;
@property (nonatomic, assign, readonly) BOOL mshowIndicator;
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
@property (nonatomic, weak) TVUStaticView *rstaticView;
@property (nonatomic, strong) TVUPLBaseRow *rowView;
///< 本行依赖的 TVUPLState 集合（弱引用），供下次求值前解绑
@property (nonatomic, strong, readonly) NSHashTable <TVUPLState *>*rstates;

// 链式调用方法
- (TVUPLRow *(^)(NSString *key))key;
- (TVUPLRow *(^)(NSString *identifier))identifier;
- (TVUPLRow *(^)(BOOL hidden))hidden;
- (TVUPLRow *(^)(BOOL showIndicator))showIndicator;
- (TVUPLRow *(^)(BOOL unselected))unselected;
- (TVUPLRow *(^)(BOOL unselectedStyle))unselectedStyle;
- (TVUPLRow *(^)(CGFloat height))height;

- (TVUPLRow *(^)(void(^)(TVUPLRow *row, id value)))tap;
- (TVUPLRow *(^)(void(^)(TVUPLRow *row)))fetchRowParameterBlock;

- (TVUPLRow *(^)(TVUPLRowType rowType))type;
- (TVUPLRow *(^)(void(^)(TVUPLRow *row)))prefetch;

- (TVUPLRow *(^)(TVUPLViewData *data))viewData;
- (id)customForKey:(NSString *)key;

#pragma mark - 常用槽位
///< 与 .viewData 可组合：槽位方法只更新文字/图名，同 key 已有的数据对象保留其余样式
- (TVUPLRow *(^)(NSString *title))title;
- (TVUPLRow *(^)(NSString *subtitle))subtitle;
- (TVUPLRow *(^)(NSString *value))value;
- (TVUPLRow *(^)(NSString *icon))icon;

#pragma mark - 绑定
///< 绑定 State 到槽位：渲染时读取并自动订阅，State 变化只刷本行。
///< 与 prefetch 不同，绑定写在哪里都有效；"内容 = 单个 State"的行用它即可免掉 prefetch
- (TVUPLRow *(^)(TVUPLState<NSString *> *state))bindTitle;
- (TVUPLRow *(^)(TVUPLState<NSString *> *state))bindSubtitle;
- (TVUPLRow *(^)(TVUPLState<NSString *> *state))bindValue;

#pragma mark - 框架内部
///< 由 TVUStaticView 在求值作用域内调用：读取各绑定的 value 并写入对应槽位
- (void)resolveBindings;

- (instancetype)initWithIdentifier:(NSString *)identifier;
@end
