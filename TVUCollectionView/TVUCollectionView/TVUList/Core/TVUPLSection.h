//
//  TVUPLSection.h
//  TVUCollectionView
//
//  Created by erfeixia on 2025/9/13.
//

#import <UIKit/UIKit.h>

#define SectionUse [TVUPLSection new]

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

@property (nonatomic,   copy, readonly) void(^rprefetch)(TVUPLSection *section);

#pragma mark - Chainable Methods

/// 设置 Section 的唯一标识 Key
/// 使用示例: SectionUse.key(@"sectionKey")
- (TVUPLSection *(^)(NSString *key))key;

/// 设置 Section 是否隐藏
/// 使用示例: SectionUse.hidden(YES)
- (TVUPLSection *(^)(BOOL hidden))hidden;

/// 设置 Section 的内边距 (Insets)
/// 使用示例: SectionUse.insets(UIEdgeInsetsMake(10, 10, 10, 10))
- (TVUPLSection *(^)(UIEdgeInsets insets))insets;

/// 设置 Section 背景的圆角半径
/// 使用示例: SectionUse.cornerRadius(8.0)
- (TVUPLSection *(^)(CGFloat cornerRadius))cornerRadius;

/// 设置 Section 的背景颜色
/// 使用示例: SectionUse.backgroundColor([UIColor redColor])
- (TVUPLSection *(^)(UIColor *backgroundColor))backgroundColor;

/// 设置 Section 包含的行 (Rows)
/// 使用示例: SectionUse.rows(@[row1, row2])
- (TVUPLSection *(^)(NSArray *rows))rows;

/// 设置 Section 的预加载或配置回调
/// 在 Section 渲染或数据准备阶段被调用
/// 使用示例: SectionUse.prefetch(^(TVUPLSection *s) { ... })
- (TVUPLSection *(^)(void(^)(TVUPLSection *section)))prefetch;

@end

NS_ASSUME_NONNULL_END
