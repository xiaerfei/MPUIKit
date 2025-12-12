//
//  TVUPLSection.m
//  TVUCollectionView
//
//  Created by erfeixia on 2025/9/13.
//

#import "TVUPLSection.h"
#import "NSObject+BaseDataType.h"

@interface TVUPLSection ()
@property (nonatomic, copy) void(^attributesBlock)(TVUPLSection *section);
@property (nonatomic, copy) NSArray <TVUPLRow *>*(^rowsBlock)(void);
@property (nonatomic, copy, readwrite)void(^rprefetch)(TVUPLSection *section);
@end

@implementation TVUPLSection

- (instancetype)init {
    self = [super init];
    if (self) {
        self.rrows = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Public Methods

/// 设置 Section 的唯一标识 Key
/// 使用示例: Section().key(@"sectionKey")
- (TVUPLSection *(^)(NSString *key))key {
    return ^(NSString *key) {
        self.rkey = key;
        return self;
    };
}

/// 设置 Section 是否隐藏
/// 使用示例: Section().hidden(YES)
- (TVUPLSection *(^)(BOOL hidden))hidden {
    return ^(BOOL hidden) {
        self.rhidden = hidden;
        return self;
    };
}

/// 设置 Section 的内边距 (Insets)
/// 使用示例: Section().insets(UIEdgeInsetsMake(10, 10, 10, 10))
- (TVUPLSection *(^)(UIEdgeInsets insets))insets {
    return ^(UIEdgeInsets insets) {
        self.rinsets = insets;
        return self;
    };
}

/// 设置 Section 背景的圆角半径
/// 使用示例: Section().cornerRadius(8.0)
- (TVUPLSection *(^)(CGFloat cornerRadius))cornerRadius {
    return ^(CGFloat cornerRadius) {
        self.rcornerRadius = cornerRadius;
        return self;
    };
}

/// 设置 Section 的背景颜色
/// 使用示例: Section().backgroundColor([UIColor redColor])
- (TVUPLSection *(^)(UIColor *backgroundColor))backgroundColor {
    return ^(UIColor *backgroundColor) {
        self.rbackgroundColor = backgroundColor;
        return self;
    };
}

/// 设置 Section 包含的行 (Rows)
/// 使用示例: Section().rows(@[row1, row2])
- (TVUPLSection *(^)(NSArray *rows))rows {
    return ^(NSArray *rows) {
        self.rrows = rows;
        return self;
    };
}

/// 设置 Section 的预加载或配置回调
/// 在 Section 渲染或数据准备阶段被调用
/// 使用示例: Section().prefetch(^(TVUPLSection *s) { ... })
- (TVUPLSection *(^)(void(^)(TVUPLSection *section)))prefetch {
    return ^(void(^prefetch)(TVUPLSection *section)) {
        self.rprefetch = prefetch;
        return self;
    };
}
@end
