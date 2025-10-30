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
@property (nonatomic,   copy) NSString *rkey;
@property (nonatomic, assign) UIEdgeInsets rinsets;
@property (nonatomic, assign) BOOL rhidden;
@property (nonatomic, assign) CGFloat rcornerRadius;
@property (nonatomic, strong) UIColor *rbackgroundColor;

@property (nonatomic, assign) NSInteger section;
@property (nonatomic, strong) NSArray <TVUPLRow *> *rrows;

@property (nonatomic, strong) TVUPLRow *header;
@property (nonatomic, strong) TVUPLRow *footer;
@property (nonatomic, assign) NSInteger tag;

// 链式调用方法
- (TVUPLSection *(^)(NSString *key))key;
- (TVUPLSection *(^)(BOOL hidden))hidden;
- (TVUPLSection *(^)(UIEdgeInsets insets))insets;
- (TVUPLSection *(^)(CGFloat cornerRadius))cornerRadius;
- (TVUPLSection *(^)(UIColor *backgroundColor))backgroundColor;
- (TVUPLSection *(^)(NSArray *rows))rows;

- (void)reload;
@end

NS_ASSUME_NONNULL_END
