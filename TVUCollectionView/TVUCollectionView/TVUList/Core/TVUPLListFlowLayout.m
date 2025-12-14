#import "TVUPLListFlowLayout.h"
#import "TVUPLSection.h"
#import "TVUPLBaseRow.h"
#import "TVUPLRow.h"

extern NSString *const kTVUPLSectionBackReuse;

@interface TVUPLListFlowLayout ()
@property (nonatomic, strong) NSMutableArray <UICollectionViewLayoutAttributes *>*backgroundLayoutAttributes;
@end

@implementation TVUPLListFlowLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundLayoutAttributes = [NSMutableArray array];
    }
    return self;
}

#pragma mark - 核心布局方法

- (void)prepareLayout {
    [super prepareLayout];
    
    [self.backgroundLayoutAttributes removeAllObjects];
    
    NSInteger numberOfSections = [self.collectionView numberOfSections];
    CGFloat width = CGRectGetWidth(self.collectionView.bounds); // 用bounds而非frame，适配滚动和尺寸变化
    
    for (NSInteger section = 0; section < numberOfSections; section++) {
        NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
        if (numberOfItems == 0) continue;
        
        TVUPLSection *plSection = [self plsection:section];
        
        NSArray <TVUPLRow *> *rows = plSection.rrows;
        NSInteger fromIndex = -1, toIndex = -1;
        // 检查 header 是否存在（只能在第一个位置）
        BOOL hasHeader = (rows[0].rrowType == TVUPLRowTypeHeader);
        // 检查 footer 是否存在（只能在最后一个位置）
        BOOL hasFooter = (rows[rows.count - 1].rrowType == TVUPLRowTypeFooter);
        
        // 计算 fromIndex（第一个内容行的起始索引）
        fromIndex = hasHeader ? (rows.count > 1 ? 1 : -1) : 0;
        
        // 计算 toIndex（最后一个内容行的结束索引）
        toIndex = hasFooter ? (rows.count > 1 ? rows.count - 2 : -1) : rows.count - 1;
        
        // 如果没有内容行（比如 [header, footer] 或单元素 header/footer），重置为 -1
        if (fromIndex > toIndex || fromIndex == -1 || toIndex == -1) {
            continue;
        }
        UICollectionViewLayoutAttributes *firstItemAttr  =
        [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:fromIndex inSection:section]];
        
        UICollectionViewLayoutAttributes *secondItemAttr = fromIndex == toIndex ? firstItemAttr :
        [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:toIndex inSection:section]];
        NSIndexPath *backIndexPath = [NSIndexPath indexPathForItem:-1 inSection:section];
        
        UICollectionViewLayoutAttributes *backgroundAttributes =
        [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kTVUPLSectionBackReuse
                                                                       withIndexPath:backIndexPath];
        CGFloat sleft  = plSection.rinsets.left;
        CGFloat sright = plSection.rinsets.right;
        CGFloat minY = firstItemAttr.frame.origin.y;
        CGFloat maxY = CGRectGetMaxY(secondItemAttr.frame);
        backgroundAttributes.frame = CGRectMake(sleft, minY, width - sleft - sright, maxY - minY);
        backgroundAttributes.zIndex = -1;
        backgroundAttributes.hidden = plSection.rhidden;
        [self.backgroundLayoutAttributes addObject:backgroundAttributes];
    }
}
#pragma mark - 布局属性获取

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *attrs = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    for (UICollectionViewLayoutAttributes *attr in self.backgroundLayoutAttributes) {
        [attrs addObject:attr];
    }
    return attrs;
}
#pragma mark - Private Methods

- (TVUPLSection *)plsection:(NSInteger)section {
    id <TVUPLListFlowLayoutDelegate> delegate = (id)self.collectionView.delegate;
    return [delegate layout:self section:section];
}

- (TVUPLRow *)rowAtIndexPath:(NSIndexPath *)indexPath {
    id <TVUPLListFlowLayoutDelegate> delegate = (id)self.collectionView.delegate;
    return [delegate layout:self rowAtIndexPath:indexPath];
}



@end
