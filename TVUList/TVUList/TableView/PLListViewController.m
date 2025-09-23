//
//  PLListViewController.m
//  TVUList
//
//  Created by erfeixia on 2025/8/5.
//

#import "PLListViewController.h"
#import "TVUPLListView.h"
#import "Masonry.h"

#if DEBUG
#define tvu_keywordify autoreleasepool {}
#else
#define tvu_keywordify try {} @catch (...) {}
#endif

#ifndef weakify
    #if __has_feature(objc_arc)
        #define weakify(object) \
            tvu_keywordify  \
            __weak __typeof__(object) weak##_##object = object;
    #else
        #define weakify(object) \
            tvu_keywordify  \
            __block __typeof__(object) block##_##object = object;
    #endif
#endif

#ifndef strongify
    #if __has_feature(objc_arc)
        #define strongify(object) \
            tvu_keywordify  \
            _Pragma("clang diagnostic push") \
            _Pragma("clang diagnostic ignored \"-Wshadow\"") \
            __strong __typeof__(object) object = weak##_##object; \
            _Pragma("clang diagnostic pop")
    #else
        #define strongify(object) \
            tvu_keywordify  \
            _Pragma("clang diagnostic push") \
            _Pragma("clang diagnostic ignored \"-Wshadow\"") \
            __strong __typeof__(object) object = block##_##object; \
            _Pragma("clang diagnostic pop")
    #endif
#endif

#define TVUColorWithRHedix(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface PLListViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSArray *datasource;
@end

@implementation PLListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TVUColorWithRHedix(0x141414);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"kReuseCell"];
}
- (IBAction)refreshAction:(id)sender {
    
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kReuseCell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld-%ld", indexPath.section, indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    if (indexPath.section == 0) {
        cell.backgroundColor = TVUColorWithRHedix(0x1F1F1F);
    }
    return cell;
}


@end
