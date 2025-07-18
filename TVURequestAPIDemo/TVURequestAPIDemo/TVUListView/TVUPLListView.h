//
//  TVUPLListView.h
//  TVURequestAPIDemo
//
//  Created by TVUM4Pro on 2025/6/24.
//

#import <UIKit/UIKit.h>
#import "TVUPLRowProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface TVUPLRow : NSObject
@property (nonatomic, assign) TVUPLRowType type;
@property (nonatomic,   copy) NSString *key;
@property (nonatomic, assign) UIEdgeInsets insets;
@property (nonatomic, assign) UIEdgeInsets lineInsets;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic,   copy) void (^didSelectedBlock)(TVUPLRow *row, id _Nullable value);
@property (nonatomic,   copy) id(^fetchRowParameterBlock)(TVUPLRow *row);
@property (nonatomic, strong, readonly) UIView <TVUPLRowProtocol> *bindView;
@end


@interface TVUPLSection : NSObject
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) UIEdgeInsets insets;
@property (nonatomic, assign) BOOL separateLine;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic,   copy) NSString *key;
@property (nonatomic, strong) UIView *bindView;
@property (nonatomic, strong) NSMutableArray <TVUPLRow *> *rows;
@end


@interface TVUPLListView : UIView
@property (nonatomic, copy) NSArray <TVUPLSection *>*(^fetchSectionsBlock)(void);

- (void)reload;
- (void)reloadRowWithKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
