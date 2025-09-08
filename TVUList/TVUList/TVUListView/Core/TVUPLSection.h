//
//  TVUPLSection.h
//  TVUList
//
//  Created by erfeixia on 2025/8/8.
//

#import <UIKit/UIKit.h>
#import "TVUSectionView.h"

NS_ASSUME_NONNULL_BEGIN

@class TVUPLRow;

@interface TVUPLSection : NSObject
@property (nonatomic,   copy) NSString *key;
@property (nonatomic, assign) BOOL hidden;
@property (nonatomic, assign) BOOL separateLine;
@property (nonatomic, assign) UIEdgeInsets insets;
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) TVUSectionView *bindView;
@property (nonatomic,   copy) void (^fetchSectionParameterBlock)(TVUPLSection *section);
@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, strong) NSMutableArray <TVUPLRow *> *rows;

- (instancetype)initWithKey:(NSString *)key;
- (void)addRow:(TVUPLRow *)row;

@end

NS_ASSUME_NONNULL_END
