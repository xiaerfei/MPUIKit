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
    [self.collectionView registerClass:[SectionBackView class] forSupplementaryViewOfKind:kSectionBackView withReuseIdentifier:kSectionBackView];
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

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    NSLog(@"viewWillLayoutSubviews");
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    NSLog(@"viewDidLayoutSubviews");
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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 单元格宽度等于collectionView宽度，高度固定为60
//    CGFloat headerWidth = [self collectionView:collectionView layout:collectionViewLayout referenceSizeForHeaderInSection:indexPath.section].width;
    return CGSizeMake(0, 60);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSLog(@"%@", indexPath.description);
}
#pragma mark - SectionBackgroundCollectionViewLayoutDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
           sizeInSection:(NSInteger)section {
    UIEdgeInsets insets = ((SectionBackViewLayout *)collectionView.collectionViewLayout).sectionInset;
    return CGSizeMake(CGRectGetWidth(collectionView.frame) - insets.left - insets.right, 0);
}
#pragma mark - 分区头部和背景
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:kSectionBackView]) {
        SectionBackView *backgroundView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kSectionBackView forIndexPath:indexPath];
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
