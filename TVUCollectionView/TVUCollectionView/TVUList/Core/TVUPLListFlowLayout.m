//
//  TVUPLListFlowLayout.m
//  TVUCollectionView
//
//  Created by erfeixia on 2025/9/13.
//

#import "TVUPLListFlowLayout.h"
#import "TVUPLSection.h"
#import "TVUPLRow.h"


extern NSString *const kTVUPLSectionBackReuse;

@interface TVUPLListFlowLayout ()
@property (nonatomic, strong) NSArray *layoutAttributes;
@property (nonatomic, assign) CGSize contentSize;
@end

@implementation TVUPLListFlowLayout

- (void)prepareLayout {
    NSLog(@"sharexia: before --> prepareLayout");
    [super prepareLayout];
    NSLog(@"sharexia: after --> prepareLayout");
    NSMutableArray *attributes = [NSMutableArray array];
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    CGFloat currentY = self.sectionInset.top;
    CGFloat width  = CGRectGetWidth(self.collectionView.frame);
    
    for (NSInteger section = 0; section < numberOfSections; section++) {
        NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
        TVUPLSection *plSection = [self section:section];
        
        TVUPLRow *header = plSection.header;
        TVUPLRow *footer = plSection.footer;
        NSIndexPath *headerIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        CGFloat headerHeight = 0;
        CGFloat headerOffset = currentY;
        if (header) {
            // 1. 计算Header尺寸
            CGFloat headerWidth  = width - header.insets.left - header.insets.right;
            headerHeight = header.height;
            // 2. 创建Header的布局属性
            UICollectionViewLayoutAttributes *headerAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader withIndexPath:headerIndexPath];
            headerAttributes.frame = CGRectMake((width - headerWidth) / 2,
                                                currentY,
                                                headerWidth,
                                                headerHeight);
            [attributes addObject:headerAttributes];

            currentY += headerHeight;
        }
        
        CGFloat itemHeights = 0;
        // 3. 处理单元格布局
        for (NSInteger item = 0; item < numberOfItems; item++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            TVUPLRow *row = [self rowAtIndexPath:indexPath];
            
            UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            CGSize itemSize = CGSizeZero;
            
            itemSize.width = width - row.insets.left - row.insets.right;
            itemSize.height = row.height;

            itemAttributes.frame = CGRectMake((width - itemSize.width) / 2,
                                              currentY,
                                              itemSize.width,
                                              itemSize.height);
            [attributes addObject:itemAttributes];
            
            currentY    += itemSize.height;
            itemHeights += itemSize.height;
        }
        
        // 4. 处理分区背景布局
        UICollectionViewLayoutAttributes *backgroundAttributes =
        [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kTVUPLSectionBackReuse
                                                                       withIndexPath:headerIndexPath];
        backgroundAttributes.frame = CGRectMake(self.sectionInset.left,
                                                headerOffset + headerHeight,
                                                width - plSection.insets.left - plSection.insets.right,
                                                itemHeights);
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

#pragma mark - Private Methods
- (TVUPLSection *)section:(NSInteger)section {
    id <TVUPLListFlowLayoutDelegate> delegate = (id)self.collectionView.delegate;
    return [delegate layout:self section:section];
}

- (TVUPLRow *)headerForSection:(NSInteger)section {
    return [self section:section].header;
}

- (TVUPLRow *)footerForSection:(NSInteger)section {
    return [self section:section].footer;
}

- (TVUPLRow *)rowAtIndexPath:(NSIndexPath *)indexPath {
    id <TVUPLListFlowLayoutDelegate> delegate = (id)self.collectionView.delegate;
    return [delegate layout:self rowAtIndexPath:indexPath];
}



@end
