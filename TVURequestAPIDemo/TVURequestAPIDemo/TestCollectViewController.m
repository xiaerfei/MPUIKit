//
//  TestCollectViewController.m
//  TVURequestAPIDemo
//
//  Created by TVUM4Pro on 2025/7/23.
//

#import "TestCollectViewController.h"
#import "SectionHeaderView.h"
#import "CustomCell.h"

#define TVUColorWithRHedix(rgbValue) \
    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0  \
                    green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                     blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface TestCollectViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArray;

// 数据源：每个分区的数据
@property (nonatomic, strong) NSArray *sectionTitles;
@property (nonatomic, strong) NSArray *sectionData;
@end

@implementation TestCollectViewController

static NSString *const cellIdentifier = @"CustomCell";
static NSString *const HeaderIdentifier = @"SectionHeaderView";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.title = @"CollectionView as TableView";
    
    // 准备数据
    [self setupData];
    
    // 配置CollectionView
    [self setupCollectionView];
}

- (void)setupData {
    // 分区标题
    self.sectionTitles = @[@"第一组", @"第二组", @"第三组", @"第四组", @"第五组"];
    
    // 每个分区的数据
    self.sectionData = @[
        @[@"项目 1-1", @"项目 1-2", @"项目 1-3", @"项目 1-4"],
        @[@"项目 2-1", @"项目 2-2", @"项目 2-3"],
        @[@"项目 3-1", @"项目 3-2"],
        @[@"项目 4-1", @"项目 4-2", @"项目 4-3"],
        @[@"项目 5-1", @"项目 5-2", @"项目 5-3"],
    ];
}

- (void)setupCollectionView {
    // 创建流式布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    // 设置为垂直滚动
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    // 没有间距，模拟表格
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    layout.sectionInset = UIEdgeInsetsZero;
    layout.headerReferenceSize = CGSizeMake(self.collectionView.bounds.size.width, 40);
    
    // 创建CollectionView
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.backgroundColor = UIColor.whiteColor;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    // 注册单元格
    [self.collectionView registerClass:[CustomCell class] forCellWithReuseIdentifier:cellIdentifier];
    // 注册分区头部
    [self.collectionView registerClass:[SectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HeaderIdentifier];

    // 自动布局设置
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.collectionView];
    
    // 添加约束，让CollectionView充满整个视图
    [NSLayoutConstraint activateConstraints:@[
        [self.collectionView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.collectionView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.collectionView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.collectionView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
    ]];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.sectionTitles.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.sectionData[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // 设置单元格数据
    cell.textLabel.text = self.sectionData[indexPath.section][indexPath.item];
    
    // 交替行颜色
//    if (indexPath.item % 2 == 0) {
//        cell.backgroundColor = UIColor.whiteColor;
//    } else {
//        cell.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1.0];
//    }
    
    return cell;
}
#pragma mark - Supplementary Views (Section Headers)

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        SectionHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HeaderIdentifier forIndexPath:indexPath];
        header.titleLabel.text = self.sectionTitles[indexPath.section];
        return header;
    }
    return nil;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 单元格宽度等于collectionView宽度，高度固定为60
    return CGSizeMake(collectionView.bounds.size.width, 40);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    // 确保旋转时更新头部宽度
    return CGSizeMake(collectionView.bounds.size.width, 40);
}
#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 处理单元格点击事件，类似表格的didSelectRowAtIndexPath
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSString *title = self.sectionData[indexPath.section][indexPath.item];
    NSLog(@"sharexia: title did select=%@", title);
}
#pragma mark - 屏幕旋转处理

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    // 旋转时刷新布局
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self.collectionView.collectionViewLayout invalidateLayout];
    } completion:nil];
}
@end
