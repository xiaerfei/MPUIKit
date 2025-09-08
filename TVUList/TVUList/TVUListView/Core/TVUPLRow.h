//
//  TVUPLRow.h
//  TVUList
//
//  Created by TVUM4Pro on 2025/8/13.
//

#import <UIKit/UIKit.h>
#import "TVUPLRowProtocol.h"

NS_ASSUME_NONNULL_BEGIN
@class TVUPLBaseRow, TVUPLSection;

@interface TVUPLRow : NSObject
@property (nonatomic, assign, readonly) TVUPLRowType type;
@property (nonatomic,   copy, readonly) NSString *key;
@property (nonatomic, assign) UIEdgeInsets insets;
@property (nonatomic, assign) UIEdgeInsets lineInsets;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) BOOL hiddenLine;
@property (nonatomic, assign) BOOL hidden;
@property (nonatomic, assign) BOOL showIndicator;
@property (nonatomic,   copy) NSString *indicatorImageName;
@property (nonatomic, strong) UIColor *indicatorColor;
@property (nonatomic, assign) BOOL unselected;
@property (nonatomic, assign) BOOL unselectedStyle;
@property (nonatomic, assign) BOOL showLeftImage;
///< 不再通过 rowData 刷新数据
@property (nonatomic, strong) id rowData;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) BOOL dataByUser;
@property (nonatomic,   copy) void (^didSelectedBlock)(TVUPLRow *row, id _Nullable value);
@property (nonatomic,   copy) void (^fetchRowParameterBlock)(TVUPLRow *row);
@property (nonatomic, strong) TVUPLBaseRow <TVUPLRowProtocol> *bindView;

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, weak) TVUPLSection *section;
@property (nonatomic, assign) BOOL headerOrFooter;

- (instancetype)initWithType:(TVUPLRowType)type key:(NSString *)key;

- (instancetype)initWithData:(NSDictionary *)data;

@end

NS_ASSUME_NONNULL_END
