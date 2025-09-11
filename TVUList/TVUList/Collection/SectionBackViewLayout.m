//
//  SectionBackViewLayout.m
//  TVUList
//
//  Created by erfeixia on 2025/8/4.
//

#import "SectionBackViewLayout.h"
@interface SectionBackViewLayout ()
@property (nonatomic, strong) NSArray *layoutAttributes;
@property (nonatomic, assign) CGSize contentSize;
@end
@implementation SectionBackViewLayout
- (instancetype)init {
    self = [super init];
    if (self) {
        _headerHeight = 40; // 默认header高度
        _defaultHeaderWidth = UIScreen.mainScreen.bounds.size.width; // 默认宽度
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    NSMutableArray *attributes = [NSMutableArray array];
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    CGFloat currentY = self.sectionInset.top;
    
    for (NSInteger section = 0; section < numberOfSections; section++) {
        NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
        
        // 1. 计算Header尺寸
        CGFloat headerWidth = self.defaultHeaderWidth;
        CGFloat headerHeight = self.headerHeight;
        // 检查是否实现了代理方法来获取宽度
        if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:widthForHeaderInSection:)]) {
            headerWidth = [(id<SectionBackgroundCollectionViewLayoutDelegate>)self.collectionView.delegate
                          collectionView:self.collectionView
                          layout:self
                          widthForHeaderInSection:section];
        }
        
        if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:heightForHeaderInSection:)]) {
            headerHeight = [(id<SectionBackgroundCollectionViewLayoutDelegate>)self.collectionView.delegate
                            collectionView:self.collectionView
                            layout:self
                            heightForHeaderInSection:section];
        }
        
        CGSize headerSize = CGSizeMake(headerWidth, headerHeight);
        
        // 2. 创建Header的布局属性
        NSIndexPath *headerIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        UICollectionViewLayoutAttributes *headerAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:headerIndexPath];
        headerAttributes.frame = CGRectMake((self.collectionView.bounds.size.width - headerWidth) / 2, currentY, headerWidth, headerSize.height);
        [attributes addObject:headerAttributes];
        
        currentY += headerSize.height;
        
        // 3. 处理单元格布局
        for (NSInteger item = 0; item < numberOfItems; item++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            
            // 让单元格宽度与header保持一致
            CGFloat itemWidth = headerWidth;
            CGFloat itemHeight = 60; // 单元格高度
            
            itemAttributes.frame = CGRectMake((self.collectionView.bounds.size.width - itemWidth) / 2, currentY, itemWidth, itemHeight);
            [attributes addObject:itemAttributes];
            
            currentY += itemHeight;
        }
        
        // 4. 处理分区背景布局
        UICollectionViewLayoutAttributes *backgroundAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:@"SectionBackground" withIndexPath:headerIndexPath];
        CGFloat sectionHeight = headerSize.height + (numberOfItems * 60);
        CGFloat gap = self.sectionInset.left + self.sectionInset.right;
        backgroundAttributes.frame = CGRectMake(self.sectionInset.left, headerAttributes.frame.origin.y, self.collectionView.bounds.size.width - gap, sectionHeight);
        backgroundAttributes.zIndex = -1; // 确保在最底层
        [attributes addObject:backgroundAttributes];
        currentY += self.sectionInset.bottom;
    }
    
    self.layoutAttributes = attributes;
    self.contentSize = CGSizeMake(self.collectionView.bounds.size.width, currentY);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *result = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *attrs in self.layoutAttributes) {
        if (CGRectIntersectsRect(attrs.frame, rect)) {
            [result addObject:attrs];
        }
    }
    return result;
}

//- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
//    // 实现此方法以支持动态单元格尺寸
//    return nil;
//}

- (CGSize)collectionViewContentSize {
    return self.contentSize;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    // 当 bounds 变化时（如旋转屏幕），重新计算布局
    return YES;
}

@end
