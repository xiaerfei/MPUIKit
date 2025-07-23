//
//  TestCollectViewController.m
//  TVURequestAPIDemo
//
//  Created by TVUM4Pro on 2025/7/23.
//

#import "TestCollectViewController.h"

#define TVUColorWithRHedix(rgbValue) \
    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0  \
                    green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                     blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// 自定义背景视图类
@interface SectionBackgroundView : UICollectionReusableView
@end

@implementation SectionBackgroundView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = TVUColorWithRHedix(0x1C1C1E);
        self.layer.cornerRadius = 8.0;
        self.layer.masksToBounds = YES;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 1);
        self.layer.shadowOpacity = 0.15;
        self.layer.shadowRadius = 2.0;
        self.layer.masksToBounds = NO;
    }
    return self;
}

@end



@interface TestCollectViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *sectionTitles;
@property (nonatomic, strong) NSArray *sectionData;
@end

@implementation TestCollectViewController

static NSString *const CellIdentifier = @"Cell";
static NSString *const SectionBackgroundElementKind = @"SectionBackground";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TVUColorWithRHedix(0x141414);
    // 设置数据
    self.sectionTitles = @[@"第一部分", @"第二部分", @"第三部分"];
    self.sectionData = @[
        @[@"第一部分 项目1", @"第一部分 项目2"],
        @[@"第二部分 项目1", @"第二部分 项目2", @"第二部分 项目3"],
        @[@"第三部分 项目1", @"第三部分 项目2", @"第三部分 项目3", @"第三部分 项目4"]
    ];
    
    // 创建布局
    UICollectionViewCompositionalLayout *layout = [self createLayout];
    
    // 注册背景装饰视图
    [layout registerClass:[SectionBackgroundView class] forDecorationViewOfKind:SectionBackgroundElementKind];
    
    // 初始化集合视图
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
    [self.view addSubview:self.collectionView];
    self.collectionView.backgroundColor = [UIColor clearColor];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.sectionTitles.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.sectionData[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UILabel *label = (UILabel *)[cell viewWithTag:100];
    if (!label) {
        label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, cell.contentView.bounds.size.width - 20, cell.contentView.bounds.size.height)];
        label.tag = 100;
        label.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:label];
    }
    
    label.text = self.sectionData[indexPath.section][indexPath.item];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    return cell;
}

#pragma mark - Layout
- (UICollectionViewCompositionalLayout *)createLayout {
    UICollectionViewCompositionalLayout *layout = [[UICollectionViewCompositionalLayout alloc] initWithSectionProvider:^NSCollectionLayoutSection *(NSInteger section, id<NSCollectionLayoutEnvironment> environment) {
        
        // 定义项目大小和布局
        NSCollectionLayoutSize *itemSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0]
                                                                          heightDimension:[NSCollectionLayoutDimension estimatedDimension:44]];
        NSCollectionLayoutItem *item = [NSCollectionLayoutItem itemWithLayoutSize:itemSize];
        // 定义组大小和布局
        NSCollectionLayoutSize *groupSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.0]
                                                                           heightDimension:[NSCollectionLayoutDimension estimatedDimension:44]];
        NSCollectionLayoutGroup *group = [NSCollectionLayoutGroup verticalGroupWithLayoutSize:groupSize subitems:@[item]];
        
        // 定义分区大小和布局
        NSCollectionLayoutSection *sectionLayout = [NSCollectionLayoutSection sectionWithGroup:group];
        
        // 设置section之间的间距
        sectionLayout.contentInsets = NSDirectionalEdgeInsetsMake(15, 15, 15, 15);
        sectionLayout.interGroupSpacing = 1;
        
        // 创建背景装饰视图，使其小于section的实际尺寸
        NSCollectionLayoutDecorationItem *background =
        [NSCollectionLayoutDecorationItem backgroundDecorationItemWithElementKind:SectionBackgroundElementKind]; // 底部间距为30
        
        sectionLayout.decorationItems = @[background];
        
        return sectionLayout;
    }];
    
    return layout;
}

@end
