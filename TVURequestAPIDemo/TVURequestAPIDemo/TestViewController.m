//
//  TestViewController.m
//  TVURequestAPIDemo
//
//  Created by TVUM4Pro on 2025/7/22.
//


#define TVUColorWithRHedix(rgbValue) \
    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0  \
                    green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                     blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "TestViewController.h"

@interface TestViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *sectionTitles;
@property (nonatomic, strong) NSArray *sectionData;
@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置数据
    self.sectionTitles = @[@"第一部分", @"第二部分", @"第三部分"];
    self.sectionData = @[
        @[@"第一部分 第一行", @"第一部分 第二行"],
        @[@"第二部分 第一行", @"第二部分 第二行", @"第二部分 第三行"],
        @[@"第三部分 第一行"]
    ];
    
    // 初始化表格视图
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    // 设置表格视图背景色为透明，以便看到section背景
//    self.tableView.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.0];
    
    // 重要：设置表格视图背景色为透明，以便看到section背景
     self.tableView.backgroundColor = [UIColor clearColor];

    // 设置分隔线样式和颜色
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionTitles.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sectionData[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = self.sectionData[indexPath.section][indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    
    // 设置单元格背景色为透明
    cell.backgroundColor = [UIColor clearColor];
    
    // 只有当单元格不是section的最后一行时才显示分隔线
    if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section] - 1) {
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width);
    } else {
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    cell.layer.masksToBounds = YES;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - UITableViewDelegate

// 返回自定义的section背景视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, tableView.bounds.size.width - 30, 20)];
    label.text = self.sectionTitles[section];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    [headerView addSubview:label];
    
    return headerView;
}

// 设置section头部高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

// 设置section底部高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 15;
}

// 返回空的footer视图，但设置高度，用于创建section之间的间距
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

// 为每个section创建带圆角的背景视图
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 创建一个自定义的背景视图
    UIView *sectionBackgroundView = [[UIView alloc] init];
    sectionBackgroundView.backgroundColor = TVUColorWithRHedix(0x1C1C1E);
    
    // 获取section的行数
    NSInteger numberOfRowsInSection = [tableView numberOfRowsInSection:indexPath.section];
    
    // 根据单元格在section中的位置调整圆角
    if (numberOfRowsInSection == 1) {
        // 只有一行的section，四个角都圆角
        sectionBackgroundView.layer.cornerRadius = 8.0;
        sectionBackgroundView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner | kCALayerMinXMaxYCorner | kCALayerMaxXMaxYCorner;
    } else if (indexPath.row == 0) {
        // 第一行，只设置左上和右上圆角
        sectionBackgroundView.layer.cornerRadius = 8.0;
        sectionBackgroundView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    } else if (indexPath.row == numberOfRowsInSection - 1) {
        // 最后一行，只设置左下和右下圆角
        sectionBackgroundView.layer.cornerRadius = 8.0;
        sectionBackgroundView.layer.maskedCorners = kCALayerMinXMaxYCorner | kCALayerMaxXMaxYCorner;
    } else {
        // 中间行，不设置圆角
        sectionBackgroundView.layer.cornerRadius = 0;
    }
    
    // 设置背景视图
    cell.backgroundView = sectionBackgroundView;
    
    // 添加阴影效果
    UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(8, 0, cell.bounds.size.width - 16, cell.bounds.size.height)];
    shadowView.backgroundColor = [UIColor clearColor];
    shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
    shadowView.layer.shadowOffset = CGSizeMake(0, 1);
    shadowView.layer.shadowOpacity = 0.15;
    shadowView.layer.shadowRadius = 2.0;
    shadowView.layer.masksToBounds = NO;
    
    // 将阴影视图添加到单元格的contentView中
    [cell.contentView addSubview:shadowView];
    [cell.contentView sendSubviewToBack:shadowView];
}

@end
