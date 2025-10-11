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
#import "SectionHeaderView.h"

@interface TVUPLListView ()<UICollectionViewDelegate,
UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) TVUPLListFlowLayout *flowLayout;

@property (nonatomic,   copy) NSArray *sectionTitles;
@property (nonatomic,   copy) NSArray *sectionData;

@property (nonatomic, strong) NSArray <TVUPLSection *> *sections;

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

    self.sections = [NSMutableArray array];
    [self prepareData];
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSLog(@"sharexia: section count");
    return self.sections.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"sharexia: section row count");
    return self.sections[section].rows.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"sharexia: row cell");
    TVUPLRow *row = self.sections[indexPath.section].rows[indexPath.row];
    UICollectionViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:row.rIdentifier
                                              forIndexPath:indexPath];
    // - (void)reloadWithData:(nonnull id)data
    
    return cell;
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSLog(@"%@", indexPath.description);
}

#pragma mark - 分区头部和背景
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        TVUPLRow *headerRow = self.sections[indexPath.section].header;
        if (headerRow.identifier == nil) {
            return [UICollectionReusableView new];
        }
        SectionHeaderView *header =
        [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                           withReuseIdentifier:headerRow.rIdentifier
                                                  forIndexPath:indexPath];
        header.titleLabel.text = self.sectionTitles[indexPath.section];
        return header;
    }
    else if ([kind isEqualToString:kTVUPLSectionBackReuse]) {
        UICollectionReusableView *backgroundView =
        [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                           withReuseIdentifier:kTVUPLSectionBackReuse
                                                  forIndexPath:indexPath];
                
        backgroundView.backgroundColor = [UIColor colorWithRed:31.0f/255.0f
                                                         green:31.0f/255.0f
                                                          blue:31.0f/255.0f
                                                         alpha:1];
        return backgroundView;
    }
    
    return nil;
}
#pragma mark - TVUPLListFlowLayoutDelegate
- (TVUPLSection *)layout:(TVUPLListFlowLayout *)layout section:(NSInteger)section {
    return self.sections[section];
}

- (TVUPLRow *)layout:(TVUPLListFlowLayout *)layout rowAtIndexPath:(NSIndexPath *)indexPath {
    return self.sections[indexPath.section].rows[indexPath.row];
}

#pragma mark - Private Methods
- (void)fetchSections {
    if (self.fetchSectionsBlock) {
        NSArray <TVUPLSection *> *sections = self.fetchSectionsBlock();
        for (TVUPLSection *section in sections) {
            if (section.fetchSectionsBlock) section.fetchSectionsBlock(section);
            for (TVUPLRow *row in section.rows) {
                if (row.rFetchRowParameterBlock) row.rFetchRowParameterBlock(row);
            }
        }
        self.sections = sections;
    }
}


#pragma mark - 测试数据
- (void)prepareData {
    // 假设这是你的分区标题数组
    self.sectionTitles = @[@"第一组", @"第二组", @"第三组", @"第四组", @"第五组"];
    
    // 假设这是你的分区数据数组
    self.sectionData = @[
        @[@"项目 1-1", @"项目 1-2", @"项目 1-3"],
        @[@"项目 2-1", @"项目 2-2"],
        @[@"项目 3-1", @"项目 3-2", @"项目 3-3", @"项目 3-4"],
        @[@"项目 4-1", @"项目 4-2", @"项目 4-3", @"项目 4-4"],
        @[@"项目 5-1", @"项目 5-2", @"项目 5-3", @"项目 5-4"],
    ];
}
@end
