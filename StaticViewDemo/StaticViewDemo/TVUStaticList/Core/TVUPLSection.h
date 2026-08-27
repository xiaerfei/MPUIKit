//
//  TVUPLSection.h
//  TVUCollectionView
//
//  Created by erfeixia on 2025/9/13.
//

/*
 @property (nonatomic, strong) UIView *contentView;

 @property (nonatomic, strong) UIStackView *stackView;

 @property (nonatomic, strong) TVUPLRow *header;
 @property (nonatomic, strong) UIView *backgroundView;
 @property (nonatomic, strong) TVUPLRow *footer;

 @property (nonatomic, strong) UIStackView *rowsStackView;
 
 上面几个属性的关系如下:
 
                                         +---------------+                           +-------------+
                                       +-+     Header    |                         +-+     Row     |
                                       | +---------------+                         | +-------------+
                                       |                                           |
+-------------+     +-------------+    | +---------------+      +-------------+    | +-------------+
| ContentView +---->|  StackView  +--->+-+BackgroundView +----->|RowsStackView+--->+-+     Row     |
+-------------+     +-------------+    | +---------------+      +-------------+    | +-------------+
                                       |                                           |
                                       | +---------------+                         | +-------------+
                                       +-+     Footer    |                         +-+     Row     |
                                         +---------------+                           +-------------+
 */

#import <UIKit/UIKit.h>

#define SectionUse [TVUPLSection new]

NS_ASSUME_NONNULL_BEGIN

extern NSString *const kTVUPLDataSection;

@class TVUPLRow, TVUPLViewData;

@interface TVUPLSection : NSObject
@property (nonatomic,   copy) NSString *rkey;
@property (nonatomic, assign) BOOL rhidden;
@property (nonatomic, strong) NSArray <TVUPLRow *> *rrows;
@property (nonatomic,   copy, readonly) void(^rprefetch)(TVUPLSection *section);

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIStackView *stackView;

@property (nonatomic, strong) TVUPLRow *header;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) TVUPLRow *footer;

@property (nonatomic, strong) UIStackView *rowsStackView;

// 链式调用方法
- (TVUPLSection *(^)(NSString *key))key;
- (TVUPLSection *(^)(BOOL hidden))hidden;
- (TVUPLSection *(^)(NSArray *rows))rows;
- (TVUPLSection *(^)(void(^)(TVUPLSection *section)))prefetch;

- (TVUPLSection *(^)(TVUPLViewData *data))viewData;
- (id)customForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
