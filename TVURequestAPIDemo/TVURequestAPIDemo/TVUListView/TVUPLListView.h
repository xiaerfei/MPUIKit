//
//  TVUPLListView.h
//  TVURequestAPIDemo
//
//  Created by TVUM4Pro on 2025/6/24.
//

#import <UIKit/UIKit.h>
#import "TVUPLRowProtocol.h"
#import "TVUPLCRows.h"
NS_ASSUME_NONNULL_BEGIN

@interface TVUPLRow : NSObject
@property (nonatomic, assign, readonly) TVUPLRowType type;
@property (nonatomic,   copy, readonly) NSString *key;
@property (nonatomic, assign) UIEdgeInsets insets;
@property (nonatomic, assign) UIEdgeInsets lineInsets;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) BOOL hiddenLine;
@property (nonatomic, assign) BOOL hidden;
@property (nonatomic, assign) BOOL showIndicator;
@property (nonatomic, assign) BOOL unselected;
@property (nonatomic, assign) BOOL unselectedStyle;
///< 不再通过 rowData 刷新数据
@property (nonatomic, assign) BOOL dataByUser;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) id rowData;
@property (nonatomic,   copy) void (^didSelectedBlock)(TVUPLRow *row, id _Nullable value);
@property (nonatomic,   copy) void (^fetchRowParameterBlock)(TVUPLRow *row);
@property (nonatomic, strong, readonly) TVUPLBaseRow <TVUPLRowProtocol> *bindView;

- (instancetype)initWithType:(TVUPLRowType)type key:(NSString *)key;
@end


@interface TVUPLSection : NSObject
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) UIEdgeInsets insets;
@property (nonatomic, assign) BOOL separateLine;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic,   copy) NSString *key;
@property (nonatomic, strong) UIView *bindView;

- (void)addRow:(TVUPLRow *)row;
@end


@interface TVUPLListView : UIScrollView
@property (nonatomic, copy) NSArray <TVUPLSection *>*(^fetchSectionsBlock)(void);

- (void)reload;
- (void)reloadRowWithKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
