//
//  TVUPLCListFlowLayout.m
//  TVUCollectionView
//
//  Created by erfeixia on 2025/12/13.
//

#import "TVUPLCListFlowLayout.h"
static NSString *const TVUPLSectionBackground = @"TVUPLSectionBackground";

@implementation TVUPLConfigModel
@end

// 自定义布局属性
@interface TVUPLBackgroundLayoutAttributes : UICollectionViewLayoutAttributes
@property (nonatomic, strong) TVUPLConfigModel *config;
@property (nonatomic, assign) UIEdgeInsets borderInsets;
@end

@implementation TVUPLBackgroundLayoutAttributes
- (id)copyWithZone:(NSZone *)zone {
    TVUPLBackgroundLayoutAttributes *attr = [super copyWithZone:zone];
    attr.config = _config;
    attr.borderInsets = _borderInsets;
    return attr;
}
@end

// 背景装饰视图
@interface TVUPLBackgroundView : UICollectionReusableView
@property (nonatomic, strong) TVUPLBackgroundLayoutAttributes *attr;
@end

@implementation TVUPLBackgroundView
- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
    TVUPLBackgroundLayoutAttributes *attr = (TVUPLBackgroundLayoutAttributes *)layoutAttributes;
    self.attr = attr;
    [self updateStyle];
}

- (void)updateStyle {
    TVUPLConfigModel *config = self.attr.config;
    self.backgroundColor = config.backgroundColor ?: [UIColor clearColor];
    self.layer.cornerRadius = config.cornerRadius;
    self.layer.borderWidth = config.borderWidth;
    self.layer.borderColor = config.borderColor.CGColor ?: [UIColor clearColor].CGColor;
    self.layer.masksToBounds = YES; // 简单处理：圆角裁切
}
@end

@implementation TVUPLCListFlowLayout

- (instancetype)init {
    if (self = [super init]) {
        [self registerClass:[TVUPLBackgroundView class] forDecorationViewOfKind:TVUPLSectionBackground];
    }
    return self;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attrs = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    
    // 按section分组处理
    NSMutableDictionary<NSNumber *, NSMutableArray<UICollectionViewLayoutAttributes *> *> *sectionAttrs = [NSMutableDictionary dictionary];
    for (UICollectionViewLayoutAttributes *attr in attrs) {
        if (attr.representedElementCategory == UICollectionElementCategoryCell) {
            NSNumber *key = @(attr.indexPath.section);
            if (!sectionAttrs[key]) {
                sectionAttrs[key] = [NSMutableArray array];
            }
            [sectionAttrs[key] addObject:attr];
        }
    }
    
    // 为每个section添加背景装饰视图
    [sectionAttrs enumerateKeysAndObjectsUsingBlock:^(NSNumber *sectionKey, NSArray *cellAttrs, BOOL *stop) {
        NSInteger section = sectionKey.integerValue;
        TVUPLBackgroundLayoutAttributes *bgAttr = [TVUPLBackgroundLayoutAttributes layoutAttributesForDecorationViewOfKind:TVUPLSectionBackground withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
        
        // 计算section的整体范围（包含所有cell）
        CGRect sectionFrame = CGRectZero;
        for (UICollectionViewLayoutAttributes *cellAttr in cellAttrs) {
            sectionFrame = CGRectUnion(sectionFrame, cellAttr.frame);
        }
        
        // 应用边框间距
        UIEdgeInsets borderInsets = [self borderInsetsForSection:section];
        sectionFrame = UIEdgeInsetsInsetRect(sectionFrame, borderInsets);
        bgAttr.frame = sectionFrame;
        
        // 设置配置信息
        bgAttr.config = [self configModelForSection:section];
        bgAttr.borderInsets = borderInsets;
        bgAttr.zIndex = -1; // 置于底层
        
        [attrs addObject:bgAttr];
    }];
    
    return attrs;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES; // 滚动时更新布局
}

#pragma mark - 代理方法封装
- (TVUPLConfigModel *)configModelForSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:configModelForSection:)]) {
        return [self.delegate collectionView:self.collectionView layout:self configModelForSection:section];
    }
    return [[TVUPLConfigModel alloc] init];
}

- (UIEdgeInsets)borderInsetsForSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(collectionView:layout:borderEdgeInsetsForSection:)]) {
        return [self.delegate collectionView:self.collectionView layout:self borderEdgeInsetsForSection:section];
    }
    return UIEdgeInsetsZero;
}

@end
