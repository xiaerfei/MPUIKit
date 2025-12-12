//
//  OtherViewController.m
//  TVUCollectionView
//
//  Created by TVUM4Pro on 2025/12/12.
//

#import "OtherViewController.h"
#import "JJCollectionViewRoundFlowLayout.h"
#import "MyCustomCell.h"
#import "TVUPLListView.h"
// 遵循 UICollectionView 必要的协议
@interface OtherViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<NSString *> *dataArray;

@end

@implementation OtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"动态高度 CollectionView";

    // 示例数据，包含不同长度的字符串
    self.dataArray = @[
        @"这是第一条短文本。",
        @"这是第二条非常长的文本，它将占据多行以证明 Cell 的动态高度功能是生效的。通过设置 flowLayout.estimatedItemSize，并正确配置 Cell 内部的 Auto Layout，我们可以让 CollectionView 自动计算 Cell 的高度。这大大简化了布局工作。",
        @"第三条文本。",
        @"第四条中等长度文本，也是一个很好的测试用例。",
        @"第五条文本，非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常非常"];
    UICollectionViewFlowLayout *layout = [[JJCollectionViewRoundFlowLayout alloc] init];
    // **最关键的设置：启用 Self-Sizing Cells**
    // 只需要设置一个非零的宽度和高度，系统就知道你需要动态计算尺寸。
    layout.estimatedItemSize = CGSizeMake(1.0, 1.0);
    // 或者使用 Apple 推荐的常量，如果你的部署目标支持：
     layout.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize;

    // 确保没有行间距和 item 间距 (如果需要)
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;

    // 初始化 CollectionView
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    // 注册 Cell
    [self.collectionView registerClass:MyCustomCell.class
            forCellWithReuseIdentifier:NSStringFromClass(MyCustomCell.class)];

    // 添加到视图
    [self.view addSubview:self.collectionView];

    // 约束 collectionView 充满整个 view
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    UILayoutGuide *safeArea = self.view.safeAreaLayoutGuide;
    [NSLayoutConstraint activateConstraints:@[
        [self.collectionView.topAnchor constraintEqualToAnchor:safeArea.topAnchor],
        [self.collectionView.leadingAnchor constraintEqualToAnchor:safeArea.leadingAnchor],
        [self.collectionView.trailingAnchor constraintEqualToAnchor:safeArea.trailingAnchor],
        [self.collectionView.bottomAnchor constraintEqualToAnchor:safeArea.bottomAnchor]
    ]];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyCustomCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(MyCustomCell.class) forIndexPath:indexPath];
    [cell configureWithText:self.dataArray[indexPath.item]];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

// 关键方法：设置 Cell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    return CGSizeMake(screenWidth, 40.0); // 宽度是屏幕宽度，高度留给 self-sizing 计算。
}

// 确保在屏幕旋转时 CollectionView 能够重新布局
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        // 旋转时使 CollectionView 布局失效，触发 sizeForItemAtIndexPath 重新计算
        [self.collectionView.collectionViewLayout invalidateLayout];
    } completion:nil];
}


#pragma mark - JJCollectionViewDelegateRoundFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout borderEdgeInsertsForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (JJCollectionViewRoundConfigModel *)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout configModelForSectionAtIndex:(NSInteger)section{

    JJCollectionViewRoundConfigModel *model = [[JJCollectionViewRoundConfigModel alloc]init];
    model.backgroundColor = UIColorFromHex(0x1F1F1F);
    model.cornerRadius = 10;
    return model;
    
}

@end
