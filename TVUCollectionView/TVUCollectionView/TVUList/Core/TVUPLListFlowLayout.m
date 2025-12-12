#import "TVUPLListFlowLayout.h"
#import "UIView+AutoLayoutHelper.h"
#import "TVUPLSection.h"
#import "TVUPLBaseRow.h"
#import "TVUPLRow.h"

extern NSString *const kTVUPLSectionBackReuse;

@interface TVUPLListFlowLayout ()
/// 按indexPath缓存布局属性（cell + 背景）
@property (nonatomic, strong) NSMutableDictionary<NSIndexPath *, UICollectionViewLayoutAttributes *> *layoutAttributesCache;
/// 缓存每个section的起始Y坐标（用于局部刷新时快速定位）
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSNumber *> *sectionStartYCache;
@property (nonatomic, assign) CGSize contentSize;
@end

@implementation TVUPLListFlowLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        _layoutAttributesCache = [NSMutableDictionary dictionary];
        _sectionStartYCache = [NSMutableDictionary dictionary];
        self.estimatedItemSize = CGSizeZero;
    }
    return self;
}

#pragma mark - 核心布局方法

- (void)prepareLayout {
    [super prepareLayout];
    [self.layoutAttributesCache removeAllObjects];
    [self.sectionStartYCache removeAllObjects];
    
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    CGFloat currentY = 0;
    CGFloat width = CGRectGetWidth(self.collectionView.bounds); // 用bounds而非frame，适配滚动和尺寸变化
    
    for (NSInteger section = 0; section < numberOfSections; section++) {
        // 缓存当前section的起始Y坐标
        self.sectionStartYCache[@(section)] = @(currentY);
        
        NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
        TVUPLSection *plSection = [self section:section];
        NSIndexPath *headerIndexPath = [NSIndexPath indexPathForItem:-1 inSection:section];
        
        CGFloat stop    = plSection.rhidden ? 0 : plSection.rinsets.top;
        CGFloat sbottom = plSection.rhidden ? 0 : plSection.rinsets.bottom;
        
        currentY += stop; // 加上section顶部内边距
        
        // 计算当前section内所有item的布局
        for (NSInteger item = 0; item < numberOfItems; item++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            [self calculateAndCacheAttributesForIndexPath:indexPath currentY:&currentY width:width section:plSection];
        }
        
        currentY += sbottom; // 加上section底部内边距
        
        // 计算section背景布局
        [self calculateAndCacheBackgroundAttributesForSection:section headerIndexPath:headerIndexPath
                                                      width:width startY:self.sectionStartYCache[@(section)].floatValue
                                                      endY:currentY section:plSection];
        
        currentY += self.sectionInset.bottom; // 加上section之间的间距
    }
    
    self.contentSize = CGSizeMake(width, currentY);
}

/// 计算单个item的布局属性并缓存
- (void)calculateAndCacheAttributesForIndexPath:(NSIndexPath *)indexPath
                                       currentY:(CGFloat *)currentY
                                          width:(CGFloat)width
                                        section:(TVUPLSection *)section {
    TVUPLRow *row = [self rowAtIndexPath:indexPath];
    UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    if (row.rHeight == 0) {
        
        TVUPLBaseRow *cell = [(TVUPLBaseRow *)[NSClassFromString(row.rIdentifier) alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
        [cell updateWithData:row.rRowData];
        // 2. 强制更新约束 (如果需要)
        [cell.contentView setNeedsLayout];
        [cell.contentView layoutIfNeeded];
        [cell.contentView applyPreferredMaxLayoutWidthToAllLabels];
        // 计算自适应大小
        // 3. 调用 API 计算高度
        CGSize size = [cell.contentView systemLayoutSizeFittingSize:CGSizeMake(width, 0)
                                      withHorizontalFittingPriority:UILayoutPriorityRequired
                                            verticalFittingPriority:UILayoutPriorityFittingSizeLevel]; // 高度尽可能紧凑 (Hug content)
        NSLog(@"size=%@", NSStringFromCGSize(size));
        row.height(size.height);
    }
    
    CGFloat rwidth = width - section.rinsets.left - section.rinsets.right;
    CGFloat rheight = row.rHeight;
    CGFloat x = section.rinsets.left;
    CGFloat y = *currentY;
    
    itemAttributes.frame = CGRectMake(x, y, rwidth, rheight);
    itemAttributes.hidden = row.rhidden || section.rhidden;
    
    // 缓存属性
    self.layoutAttributesCache[indexPath] = itemAttributes;
    
    // 只有item不隐藏时才累加Y坐标
    if (!row.rhidden && !section.rhidden) {
        *currentY += rheight;
    }
}

/// 计算section背景的布局属性并缓存
- (void)calculateAndCacheBackgroundAttributesForSection:(NSInteger)section
                                       headerIndexPath:(NSIndexPath *)headerIndexPath
                                                width:(CGFloat)width
                                                startY:(CGFloat)startY
                                                  endY:(CGFloat)endY
                                                section:(TVUPLSection *)plSection {
    CGFloat sleft = plSection.rinsets.left;
    CGFloat sright = plSection.rinsets.right;
    
    // 计算背景高度（排除header和footer的特殊处理，保持原逻辑）
    CGFloat headerHeight = endY - startY - plSection.rinsets.top - plSection.rinsets.bottom;
    CGFloat headerOffset = startY + plSection.rinsets.top;
    
    if (plSection.rrows.firstObject.rrowType == TVUPLRowTypeHeader) {
        UICollectionViewLayoutAttributes *firstAttr = self.layoutAttributesCache[[NSIndexPath indexPathForItem:0 inSection:section]];
        headerOffset = CGRectGetMaxY(firstAttr.frame);
        headerHeight -= CGRectGetHeight(firstAttr.frame);
    }
    if (plSection.rrows.lastObject.rrowType == TVUPLRowTypeFooter) {
        UICollectionViewLayoutAttributes *lastAttr = self.layoutAttributesCache[[NSIndexPath indexPathForItem:plSection.rrows.count-1 inSection:section]];
        headerHeight -= CGRectGetHeight(lastAttr.frame);
    }
    
    // 使用 item=-1 的 indexPath 缓存背景视图属性
    UICollectionViewLayoutAttributes *backgroundAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kTVUPLSectionBackReuse withIndexPath:headerIndexPath];
    backgroundAttributes.frame = CGRectMake(sleft, headerOffset, width - sleft - sright, headerHeight);
    backgroundAttributes.zIndex = -1;
    backgroundAttributes.hidden = plSection.rhidden;
    self.layoutAttributesCache[headerIndexPath] = backgroundAttributes; // 用section的headerIndexPath作为key
}

#pragma mark - 布局属性获取

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *result = [NSMutableArray array];
    [self.layoutAttributesCache enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attrs, BOOL *stop) {
        if (CGRectIntersectsRect(attrs.frame, rect)) {
            [result addObject:attrs];
        }
    }];
    return result;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.layoutAttributesCache[indexPath]; // 从缓存获取，确保最新
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if ([elementKind isEqualToString:kTVUPLSectionBackReuse]) {
        return self.layoutAttributesCache[indexPath]; // 背景视图属性
    }
    return [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
}

- (CGSize)collectionViewContentSize {
    return self.contentSize;
}

#pragma mark - 局部刷新处理（核心修复）

- (void)invalidateLayoutWithContext:(UICollectionViewLayoutInvalidationContext *)context {
    [super invalidateLayoutWithContext:context];
    
    // 如果是局部刷新（有失效的item），只更新受影响的布局
    if ([context invalidatedItemIndexPaths].count > 0) {
        NSArray<NSIndexPath *> *invalidItems = [context invalidatedItemIndexPaths];
        [self updateLayoutForInvalidatedIndexPaths:[NSSet setWithArray:invalidItems]];
    } else {
        // 全局刷新时清空缓存（prepareLayout会重新计算）
        [self.layoutAttributesCache removeAllObjects];
        [self.sectionStartYCache removeAllObjects];
    }
}

/// 针对失效的indexPath，重新计算其及后续受影响的布局
- (void)updateLayoutForInvalidatedIndexPaths:(NSSet<NSIndexPath *> *)invalidIndexPaths {
    // 按section分组处理（同一section的item变化可能相互影响）
    NSMutableDictionary<NSNumber *, NSMutableSet<NSIndexPath *>*> *sectionToIndexPaths = [NSMutableDictionary dictionary];
    for (NSIndexPath *indexPath in invalidIndexPaths) {
        NSNumber *sectionKey = @(indexPath.section);
        if (!sectionToIndexPaths[sectionKey]) {
            sectionToIndexPaths[sectionKey] = [NSMutableSet set];
        }
        [sectionToIndexPaths[sectionKey] addObject:indexPath];
    }
    
    CGFloat width = CGRectGetWidth(self.collectionView.bounds);
    // 遍历每个受影响的section，重新计算布局
    [sectionToIndexPaths enumerateKeysAndObjectsUsingBlock:^(NSNumber *sectionKey, NSMutableSet<NSIndexPath *> *indexPaths, BOOL *stop) {
        NSInteger section = sectionKey.integerValue;
        TVUPLSection *plSection = [self section:section];
        NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
        
        // 从section起始Y坐标重新计算
        CGFloat currentY = self.sectionStartYCache[sectionKey].floatValue + plSection.rinsets.top;
        
        // 重新计算当前section所有item（因为某个item变化可能影响后续所有item的Y坐标）
        for (NSInteger item = 0; item < numberOfItems; item++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            [self calculateAndCacheAttributesForIndexPath:indexPath currentY:&currentY width:width section:plSection];
        }
        
        // 重新计算section背景
        CGFloat sectionEndY = currentY + plSection.rinsets.bottom;
        NSIndexPath *headerIndexPath = [NSIndexPath indexPathForItem:-1 inSection:section];
        [self calculateAndCacheBackgroundAttributesForSection:section headerIndexPath:headerIndexPath
                                                      width:width startY:self.sectionStartYCache[sectionKey].floatValue
                                                      endY:sectionEndY section:plSection];
        
        // 更新后续section的起始Y坐标（如果当前section高度变化，后续section位置会变）
        [self updateSubsequentSectionsStartYAfterSection:section newEndY:sectionEndY + self.sectionInset.bottom];
    }];
    
    // 重新计算内容大小
    self.contentSize = CGSizeMake(width, [self calculateTotalContentHeight]);
}

/// 更新当前section之后所有section的起始Y坐标
- (void)updateSubsequentSectionsStartYAfterSection:(NSInteger)section newEndY:(CGFloat)newEndY {
    CGFloat currentEndY = newEndY;
    // 遍历后续所有section
    for (NSInteger s = section + 1; s < [self.collectionView numberOfSections]; s++) {
        self.sectionStartYCache[@(s)] = @(currentEndY); // 更新起始Y
        
        // 重新计算该section的结束Y（用于更新下一个section）
        TVUPLSection *plSection = [self section:s];
        NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:s];
        
        CGFloat sectionY = currentEndY + plSection.rinsets.top;
        for (NSInteger item = 0; item < numberOfItems; item++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:s];
            TVUPLRow *row = [self rowAtIndexPath:indexPath];
            if (!row.rhidden) {
                sectionY += row.rHeight;
            }
        }
        sectionY += plSection.rinsets.bottom;
        currentEndY = sectionY + self.sectionInset.bottom;
    }
}

/// 计算总内容高度（最后一个section的结束Y）
- (CGFloat)calculateTotalContentHeight {
    NSInteger lastSection = [self.collectionView numberOfSections] - 1;
    if (lastSection < 0) return 0;
    
    TVUPLSection *lastPlSection = [self section:lastSection];
    CGFloat startY = self.sectionStartYCache[@(lastSection)].floatValue;
    CGFloat endY = startY + lastPlSection.rinsets.top;
    
    NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:lastSection];
    for (NSInteger item = 0; item < numberOfItems; item++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:lastSection];
        TVUPLRow *row = [self rowAtIndexPath:indexPath];
        if (!row.rhidden) {
            endY += row.rHeight;
        }
    }
    endY += lastPlSection.rinsets.bottom + self.sectionInset.bottom;
    return endY;
}

#pragma mark - 边界变化时重新布局

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    CGRect oldBounds = self.collectionView.bounds;
    // 宽度变化时重新布局（如旋转屏幕）
    if (ABS(CGRectGetWidth(newBounds) - CGRectGetWidth(oldBounds)) > 1) {
        return YES;
    }
    return [super shouldInvalidateLayoutForBoundsChange:newBounds];
}

#pragma mark - Private Methods

- (TVUPLSection *)section:(NSInteger)section {
    id <TVUPLListFlowLayoutDelegate> delegate = (id)self.collectionView.delegate;
    return [delegate layout:self section:section];
}

- (TVUPLRow *)rowAtIndexPath:(NSIndexPath *)indexPath {
    id <TVUPLListFlowLayoutDelegate> delegate = (id)self.collectionView.delegate;
    return [delegate layout:self rowAtIndexPath:indexPath];
}



@end
