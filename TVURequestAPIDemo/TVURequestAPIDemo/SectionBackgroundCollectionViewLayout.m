#import "SectionBackgroundCollectionViewLayout.h"

@implementation SectionBackgroundCollectionViewLayout

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    
    // 获取所有分区
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    for (NSInteger section = 0; section < numberOfSections; section++) {
        // 检查分区是否有元素
        NSInteger itemsCount = [self.collectionView numberOfItemsInSection:section];
        if (itemsCount == 0) continue;
        
        // 创建分区背景的布局属性
        UICollectionViewLayoutAttributes *backgroundAttrs = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:@"SectionBackground" withIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
        
        // 计算分区的整体frame
        NSIndexPath *firstItemIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        NSIndexPath *lastItemIndexPath = [NSIndexPath indexPathForItem:itemsCount - 1 inSection:section];
        
        UICollectionViewLayoutAttributes *firstItemAttrs = [self layoutAttributesForItemAtIndexPath:firstItemIndexPath];
        UICollectionViewLayoutAttributes *lastItemAttrs = [self layoutAttributesForItemAtIndexPath:lastItemIndexPath];
        
        // 包含header的frame
        CGRect headerFrame = CGRectZero;
        if ([self.collectionView.dataSource respondsToSelector:@selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:)]) {
            UICollectionViewLayoutAttributes *headerAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:section]];
            headerFrame = headerAttrs.frame;
        }
        
        // 计算分区背景的frame
        CGFloat backgroundX = 0;
        CGFloat backgroundY = headerFrame.origin.y;
        CGFloat backgroundWidth = self.collectionView.bounds.size.width;
        CGFloat backgroundHeight = CGRectGetMaxY(lastItemAttrs.frame) - backgroundY;
        
        backgroundAttrs.frame = CGRectMake(backgroundX, backgroundY, backgroundWidth, backgroundHeight);
        backgroundAttrs.zIndex = -1; // 确保背景在内容下方
        [attributes addObject:backgroundAttrs];
    }
    
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES; //  bounds变化时重新计算布局（如旋转屏幕）
}

@end
