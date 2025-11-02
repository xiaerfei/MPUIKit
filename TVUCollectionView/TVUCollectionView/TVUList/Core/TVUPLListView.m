//
//  TVUPLListView.m
//  TVUCollectionView
//
//  Created by erfeixia on 2025/9/13.
//

#import "TVUPLListView.h"
#import "TVUPLSectionBackView.h"
#import "TVUPLListFlowLayout.h"
#import "Masonry.h"

#import "CustomCell.h"

@interface TVUPLListView ()<UICollectionViewDelegate,
UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) TVUPLListFlowLayout *flowLayout;
@property (nonatomic, strong) NSArray <TVUPLSection *> *ssections;

@property (nonatomic, copy) void(^fetchSectionsBlock)(TVUPLListView *list);
@end

@implementation TVUPLListView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self configureUI];
    }
    return self;
}
#pragma mark - Public Methods
- (void)reload {
    [self fetchSections];
    [self.collectionView reloadData];
}

- (void)reloadSectionForKey:(NSString *)key {
    
}

- (void)reloadRowForKey:(NSString *)key {
    
}

- (void)registerForCell:(NSString *)cellName
                 bundle:(NSBundle *)bundle
                 useNib:(BOOL)useNib {
    if (useNib) {
        UINib *nib = [UINib nibWithNibName:cellName bundle:bundle];
        [self.collectionView registerNib:nib forCellWithReuseIdentifier:cellName];
    } else {
        [self.collectionView registerClass:NSClassFromString(cellName)
                forCellWithReuseIdentifier:cellName];
    }
}

- (void)registerForHeader:(NSString *)cellName
                   bundle:(NSBundle *)bundle
                   useNib:(BOOL)useNib {
    if (useNib) {
        UINib *nib = [UINib nibWithNibName:cellName bundle:bundle];
        [self.collectionView registerNib:nib
              forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                     withReuseIdentifier:cellName];
    } else {
        [self.collectionView registerClass:NSClassFromString(cellName)
                forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                       withReuseIdentifier:cellName];
    }
}

- (void)registerForFooter:(NSString *)cellName
                   bundle:(NSBundle *)bundle
                   useNib:(BOOL)useNib {
    if (useNib) {
        UINib *nib = [UINib nibWithNibName:cellName bundle:bundle];
        [self.collectionView registerNib:nib
              forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                     withReuseIdentifier:cellName];
    } else {
        [self.collectionView registerClass:NSClassFromString(cellName)
                forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                       withReuseIdentifier:cellName];
    }
}

- (TVUPLListView *(^)(NSArray *sections))sections {
    return ^(NSArray *sections) {
        self.ssections = sections;
        return self;
    };
}

- (TVUPLListView *(^)(UIEdgeInsets insets))insets {
    return ^(UIEdgeInsets insets) {
        return self;
    };
}
- (TVUPLListView *(^)(CGFloat cornerRadius))cornerRadius {
    return ^(CGFloat cornerRadius) {
        return self;
    };
}
- (TVUPLListView *(^)(UIColor *backgroundColor))sectionColor {
    return ^(UIColor *backgroundColor) {
        return self;
    };
}
- (TVUPLListView *(^)(void(^)(TVUPLListView *list)))prefetch {
    return ^(void(^block)(TVUPLListView *list)) {
        self.fetchSectionsBlock = block;
        return self;
    };
}

#pragma mark - Private Methods
- (void)configureUI {
    self.flowLayout = [[TVUPLListFlowLayout alloc] init];
    
    // 初始化CollectionView
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self addSubview:self.collectionView];

    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [self.collectionView registerClass:[TVUPLSectionBackView class]
            forSupplementaryViewOfKind:kTVUPLSectionBackReuse
                   withReuseIdentifier:kTVUPLSectionBackReuse];
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.ssections.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.ssections[section].rrows.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TVUPLRow *row = self.ssections[indexPath.section].rrows[indexPath.row];
    TVUPLBaseRow *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:row.rIdentifier
                                              forIndexPath:indexPath];
    cell.section = indexPath.section;
    cell.row = indexPath.row;
    [self configureWithCell:cell indexPath:indexPath];
    [cell updateWithData:row.rRowData];
    return cell;
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    TVUPLRow *row = self.ssections[indexPath.section].rrows[indexPath.row];
    if (row.rDidSelectedBlock) row.rDidSelectedBlock(row, nil);
}
#pragma mark - 分区头部和背景
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:kTVUPLSectionBackReuse]) {
        TVUPLSection *section = self.ssections[indexPath.section];
        UICollectionReusableView *backgroundView =
        [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                           withReuseIdentifier:kTVUPLSectionBackReuse
                                                  forIndexPath:indexPath];
        backgroundView.backgroundColor = section.rbackgroundColor;
        backgroundView.layer.cornerRadius  = section.rcornerRadius;
        backgroundView.layer.masksToBounds = YES;
        return backgroundView;
    }
    
    return nil;
}
#pragma mark - TVUPLListFlowLayoutDelegate
- (TVUPLSection *)layout:(TVUPLListFlowLayout *)layout section:(NSInteger)section {
    return self.ssections[section];
}

- (TVUPLRow *)layout:(TVUPLListFlowLayout *)layout rowAtIndexPath:(NSIndexPath *)indexPath {
    return self.ssections[indexPath.section].rrows[indexPath.row];
}

#pragma mark - Private Methods
- (void)fetchSections {
    if (self.fetchSectionsBlock) {
        self.fetchSectionsBlock(self);
    }
}

- (void)configureWithCell:(TVUPLBaseRow *)baseRow
                indexPath:(NSIndexPath *)indexPath {
    TVUPLSection *section = self.ssections[indexPath.section];
    TVUPLRow *row = section.rrows[indexPath.row];
    
    void(^hiddenBlock)(BOOL hidden) = ^(BOOL hidden) {
        baseRow.lineView.hidden = hidden;
        [baseRow.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(baseRow).offset(row.rLineInsets.left);
            make.right.equalTo(baseRow).offset(-row.rLineInsets.right);
        }];
    };
    
    if (row.rrowType == TVUPLRowTypeHeader ||
        row.rrowType == TVUPLRowTypeFooter) {
        hiddenBlock(row.rforceShowLine ? NO : YES);
        return;
    }
    
    if ((indexPath.row + 1) >= section.rrows.count) {
        hiddenBlock(row.rforceShowLine ? NO : YES);
        return;
    }
    
    TVUPLRow *nextRow = [self findNextRowAtIndexPath:indexPath];
    if (nextRow.rrowType == TVUPLRowTypeFooter) {
        hiddenBlock(row.rforceShowLine ? NO : YES);
        return;
    }
    hiddenBlock(row.rhiddenLine ? YES : NO);
}

- (TVUPLRow *)findNextRowAtIndexPath:(NSIndexPath *)indexPath {
    TVUPLSection *section = self.ssections[indexPath.section];
    for (NSInteger index = indexPath.row + 1;
         index < section.rrows.count;
         index++) {
        TVUPLRow *row = section.rrows[index];
        if (row.rhidden) continue;
        return row;
    }
    return nil;
}

@end
