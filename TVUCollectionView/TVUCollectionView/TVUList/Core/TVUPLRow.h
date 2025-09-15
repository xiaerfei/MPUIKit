//
//  TVUPLRow.h
//  TVUCollectionView
//
//  Created by erfeixia on 2025/9/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TVUPLRow : NSObject
@property (nonatomic,   copy) NSString *key;
@property (nonatomic,   copy) NSString *identifier;
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

@property (nonatomic, strong) id rowData;

@property (nonatomic, assign) NSInteger section;
@property (nonatomic, assign) NSInteger row;

@property (nonatomic,   copy) void (^didSelectedBlock)(TVUPLRow *row, id value);
@property (nonatomic,   copy) void (^fetchRowParameterBlock)(TVUPLRow *row);

- (void)parameter:(NSDictionary *)parameter;

+ (instancetype)fetch:(void(^)(TVUPLRow *row))fetch
             selected:(void(^)(TVUPLRow *row, id value))selected;

@end

NS_ASSUME_NONNULL_END
