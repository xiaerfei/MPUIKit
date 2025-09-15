//
//  ListViewController.m
//  TVUList
//
//  Created by erfeixia on 2025/8/4.
//

#import "ListViewController.h"
#import "SectionBackViewLayout.h"
#import "SectionHeaderView.h"
#import "SectionBackView.h"
#import "CustomCell.h"
#import "Common.h"

@interface ListViewController () <UICollectionViewDelegate, UICollectionViewDataSource,SectionBackgroundCollectionViewLayoutDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic,   copy) NSArray *sectionTitles;
@property (nonatomic,   copy) NSArray *sectionData;
@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromHex(0x141414);
    // 初始化布局
    SectionBackViewLayout *layout = [[SectionBackViewLayout alloc] init];
//    layout.minimumLineSpacing = 0;
//    layout.headerReferenceSize = CGSizeMake(self.view.bounds.size.width - 30, 40);
    layout.sectionInset = UIEdgeInsetsMake(5, 15, 20, 15);
    
    // 初始化CollectionView
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[CustomCell class] forCellWithReuseIdentifier:@"CustomCell"];
    [self.collectionView registerClass:[SectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"SectionHeaderView"];
    [self.collectionView registerClass:[SectionBackView class] forSupplementaryViewOfKind:@"SectionBackground" withReuseIdentifier:@"SectionBackgroundView"];
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.collectionView];
    
    // 添加约束
    [NSLayoutConstraint activateConstraints:@[
        [self.collectionView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
        [self.collectionView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
        [self.collectionView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [self.collectionView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
    ]];
    
    // 准备数据
    [self prepareData];
}
#pragma mark - 数据准备
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
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.sectionTitles.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.sectionData[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CustomCell" forIndexPath:indexPath];
    cell.textLabel.text = self.sectionData[indexPath.section][indexPath.item];
    cell.backgroundColor = UIColor.clearColor; // 单元格背景色
    return cell;
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSLog(@"%@", indexPath.description);
}
#pragma mark - SectionBackgroundCollectionViewLayoutDelegate
// 实现此代理方法来设置每个section的header宽度
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
  widthForHeaderInSection:(NSInteger)section {
    return CGRectGetWidth(collectionView.frame);
}
// 控制header高度
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
 heightForHeaderInSection:(NSInteger)section {
    // 如果是隐藏的分区，高度设为0
    return 40; // 正常高度
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
sizeForItemWithIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(CGRectGetWidth(collectionView.frame), 60);
}

#pragma mark - 分区头部和背景
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        SectionHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"SectionHeaderView" forIndexPath:indexPath];
        header.titleLabel.text = self.sectionTitles[indexPath.section];
        return header;
    }
    else if ([kind isEqualToString:@"SectionBackground"]) {
        SectionBackView *backgroundView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"SectionBackgroundView" forIndexPath:indexPath];
        
        // 为不同分区设置不同背景色
//        NSArray *sectionColors = @[
//            [UIColor colorWithRed:0.95 green:0.95 blue:1.0 alpha:1.0], // 浅蓝色
//            [UIColor colorWithRed:0.95 green:1.0 blue:0.95 alpha:1.0], // 浅绿色
//            [UIColor colorWithRed:1.0 green:0.95 blue:0.95 alpha:1.0]  // 浅红色
//        ];
        
        backgroundView.backgroundColor = [UIColor colorWithRed:31.0f/255.0f
                                                         green:31.0f/255.0f
                                                          blue:31.0f/255.0f
                                                         alpha:1];
        return backgroundView;
    }
    
    return nil;
}

#pragma mark - 屏幕旋转处理
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        [self.collectionView.collectionViewLayout invalidateLayout];
    } completion:nil];
}
@end
