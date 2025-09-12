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
        
        CGFloat gap = self.sectionInset.left + self.sectionInset.right;
        CGSize headerSize = CGSizeMake(headerWidth - gap, headerHeight);
        // 2. 创建Header的布局属性
        NSIndexPath *headerIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        UICollectionViewLayoutAttributes *headerAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:headerIndexPath];
        headerAttributes.frame = CGRectMake((self.collectionView.bounds.size.width - headerSize.width) / 2, currentY, headerSize.width, headerSize.height);
        [attributes addObject:headerAttributes];
        
        currentY += headerSize.height;
        
        // 3. 处理单元格布局
        for (NSInteger item = 0; item < numberOfItems; item++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            CGSize itemSize = CGSizeZero;
            if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:sizeForItemWithIndexPath:)]) {
                itemSize = [(id<SectionBackgroundCollectionViewLayoutDelegate>)self.collectionView.delegate
                                collectionView:self.collectionView
                                layout:self
                                sizeForItemWithIndexPath:indexPath];
            }
            
            itemSize.width = headerSize.width;
            
            if (itemSize.height == 0) {
                itemSize.height = 44;
            }
            
            itemAttributes.frame = CGRectMake((self.collectionView.bounds.size.width - itemSize.width) / 2, currentY, itemSize.width, itemSize.height);
            [attributes addObject:itemAttributes];
            
            currentY += itemSize.height;
        }
        
        // 4. 处理分区背景布局
        UICollectionViewLayoutAttributes *backgroundAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:@"SectionBackground" withIndexPath:headerIndexPath];
        CGFloat sectionHeight = (numberOfItems * 60);
        
        backgroundAttributes.frame = CGRectMake(self.sectionInset.left,
                                                headerAttributes.frame.origin.y + headerSize.height,
                                                self.collectionView.bounds.size.width - gap,
                                                sectionHeight);
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

@end
