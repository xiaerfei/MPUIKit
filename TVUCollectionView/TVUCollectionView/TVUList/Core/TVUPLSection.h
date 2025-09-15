//
//  TVUPLSection.h
//  TVUCollectionView
//
//  Created by erfeixia on 2025/9/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TVUPLRow;

@interface TVUPLSection : NSObject
@property (nonatomic,   copy) NSString *key;
@property (nonatomic,   copy) NSString *identifier;
/// 默认显示分割线
@property (nonatomic, assign) BOOL separateLine;
@property (nonatomic, assign) UIEdgeInsets insets;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, strong) UIColor *backgroundColor;

@property (nonatomic, assign) NSInteger section;
@property (nonatomic, strong) NSMutableArray <TVUPLRow *> *rows;

@property (nonatomic,   copy) void (^fetchSectionsBlock)(TVUPLSection *section);

+ (instancetype)fetch:(void(^)(TVUPLSection *section))fetch;

- (void)addRow:(TVUPLRow *)row;
- (void)addRows:(NSArray <TVUPLRow *>*)rows;
@end

NS_ASSUME_NONNULL_END
