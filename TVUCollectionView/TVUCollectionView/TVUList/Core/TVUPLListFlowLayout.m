//
//  TVUPLListFlowLayout.m
//  TVUCollectionView
//
//  Created by erfeixia on 2025/9/13.
//

#import "TVUPLListFlowLayout.h"

extern NSString *const kTVUPLSectionBackReuse;

@interface TVUPLListFlowLayout ()
@property (nonatomic, strong) NSArray *layoutAttributes;
@property (nonatomic, assign) CGSize contentSize;
@end

@implementation TVUPLListFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    NSMutableArray *attributes = [NSMutableArray array];
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    CGFloat currentY = self.sectionInset.top;
    CGFloat width  = CGRectGetWidth(self.collectionView.frame);
    
    for (NSInteger section = 0; section < numberOfSections; section++) {
        NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
        
        // 1. 计算Header尺寸
        CGFloat headerWidth = width;
        CGFloat headerHeight = 40;

        CGFloat gap = self.sectionInset.left + self.sectionInset.right;
        CGSize headerSize = CGSizeMake(headerWidth - gap, headerHeight);
        // 2. 创建Header的布局属性
        NSIndexPath *headerIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        UICollectionViewLayoutAttributes *headerAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:headerIndexPath];
        headerAttributes.frame = CGRectMake((width - headerSize.width) / 2,
                                            currentY,
                                            headerSize.width,
                                            headerSize.height);
        [attributes addObject:headerAttributes];
        
        currentY += headerSize.height;
        
        // 3. 处理单元格布局
        for (NSInteger item = 0; item < numberOfItems; item++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            CGSize itemSize = CGSizeZero;
            
            itemSize.width = headerSize.width;
            
            if (itemSize.height == 0) {
                itemSize.height = 44;
            }
            
            itemAttributes.frame = CGRectMake((width - itemSize.width) / 2,
                                              currentY,
                                              itemSize.width,
                                              itemSize.height);
            [attributes addObject:itemAttributes];
            
            currentY += itemSize.height;
        }
        
        // 4. 处理分区背景布局
        UICollectionViewLayoutAttributes *backgroundAttributes =
        [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kTVUPLSectionBackReuse
                                                                       withIndexPath:headerIndexPath];
        CGFloat sectionHeight = (numberOfItems * 44);
        
        backgroundAttributes.frame = CGRectMake(self.sectionInset.left,
                                                headerAttributes.frame.origin.y + headerSize.height,
                                                width - gap,
                                                sectionHeight);
        backgroundAttributes.zIndex = -1; // 确保在最底层
        [attributes addObject:backgroundAttributes];
        currentY += self.sectionInset.bottom;
    }
    
    self.layoutAttributes = attributes;
    self.contentSize = CGSizeMake(width, currentY);
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

- (CGSize)collectionViewContentSize {
    return self.contentSize;
}
@end
