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
    [super prepareLayout];
    NSMutableArray *attributes = [NSMutableArray array];
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    CGFloat currentY = 0;
    CGFloat width  = CGRectGetWidth(self.collectionView.frame);
    
    for (NSInteger section = 0; section < numberOfSections; section++) {
        NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
        TVUPLSection *plSection = [self section:section];
        NSIndexPath *headerIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        CGFloat headerHeight = 0;
        CGFloat itemHeights = 0;
        CGFloat headerOffset = currentY;
        NSMutableArray <UICollectionViewLayoutAttributes *>*rows = @[].mutableCopy;
        CGFloat sleft = plSection.rinsets.left;
        CGFloat sright = plSection.rinsets.right;
        CGFloat stop = plSection.rinsets.top;
        CGFloat sbottom = plSection.rinsets.bottom;
        currentY += stop;
        // 3. 处理单元格布局
        for (NSInteger item = 0; item < numberOfItems; item++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            TVUPLRow *row = [self rowAtIndexPath:indexPath];
            UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            CGFloat rwidth  = width - sleft - sright;
            CGFloat rheight = row.rHeight;
            CGFloat x = sleft;
            CGFloat y = currentY;
            itemAttributes.frame = CGRectMake(x, y, rwidth, rheight);
            
            itemAttributes.hidden = row.rhidden;
            [rows addObject:itemAttributes];
            
            if (row.rhidden == NO) {
                currentY    += rheight;
                itemHeights += rheight;
            }
        }
        
        currentY += sbottom;
        
        headerHeight = itemHeights;
        if (plSection.rrows.firstObject.rrowType == TVUPLRowTypeHeader) {
            CGRect rowRect = rows.firstObject.frame;
            headerOffset = CGRectGetMaxY(rowRect);
            headerHeight -= CGRectGetHeight(rowRect);
        }
        if (plSection.rrows.lastObject.rrowType == TVUPLRowTypeFooter) {
            CGRect rowRect = rows.lastObject.frame;
            headerHeight -= CGRectGetHeight(rowRect);
        }
        
        // 4. 处理分区背景布局
        UICollectionViewLayoutAttributes *backgroundAttributes =
        [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kTVUPLSectionBackReuse
                                                                       withIndexPath:headerIndexPath];
        backgroundAttributes.frame = CGRectMake(sleft,
                                                headerOffset,
                                                width - sleft - sright,
                                                headerHeight);
        backgroundAttributes.zIndex = -1; // 确保在最底层
        [attributes addObjectsFromArray:rows];
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
