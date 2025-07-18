//
//  ViewController.m
//  TVURequestAPIDemo
//
//  Created by sharexia on 5/6/25.
//

#import "ViewController.h"
#import "TVUPLUidInfoAPI.h"
#import "TVUPLUsersAPI.h"
#import "TVUPLTimeoutAPI.h"
#import "TVUPLListView.h"
#import "Masonry.h"
@interface ViewController ()
@property (nonatomic, strong) TVUPLListView *listView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.listView = [[TVUPLListView alloc] init];
    [self.view addSubview:self.listView];
    
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    __weak typeof(self) weakSelf = self;
    [self.listView setFetchSectionsBlock:^NSArray<TVUPLSection *> * _Nonnull {
        __strong typeof(weakSelf) self = weakSelf;
        return @[[self firstSection]];
    }];
}

- (TVUPLSection *)firstSection {
    TVUPLRow *row0 = [[TVUPLRow alloc] init];
    row0.type = TVUPLRowTypeDefault;
    [row0 setFetchRowParameterBlock:^id _Nonnull(TVUPLRow * _Nonnull row) {
        return @{
            kTVUPLRowData : @{ @"text" : @"row0"},
            kTVUPLRowKey : @"row0"
        };
    }];
    TVUPLRow *row1 = [[TVUPLRow alloc] init];
    [row1 setFetchRowParameterBlock:^id _Nonnull(TVUPLRow * _Nonnull row) {
        return @{
            kTVUPLRowData : @{ @"text" : @"row1"},
            kTVUPLRowKey : @"row1"
        };
    }];

    TVUPLRow *row2 = [[TVUPLRow alloc] init];
    [row2 setFetchRowParameterBlock:^id _Nonnull(TVUPLRow * _Nonnull row) {
        return @{
            kTVUPLRowData : @{ @"text" : @"row2"},
            kTVUPLRowKey : @"row2"
        };
    }];

    TVUPLSection *section0 = [[TVUPLSection alloc] init];
    section0.rows = @[row0, row1, row2].mutableCopy;
    section0.cornerRadius = 6;
    section0.backgroundColor = [UIColor whiteColor];
    return section0;
}

- (TVUPLRow *)createRowWithString:(NSString *)string {
    TVUPLRow *row0 = [[TVUPLRow alloc] init];
    row0.type = TVUPLRowTypeDefault;
    [row0 setFetchRowParameterBlock:^id _Nonnull(TVUPLRow * _Nonnull row) {
        return @{
            kTVUPLRowData : @{ @"text" : string},
            kTVUPLRowKey : string
        };
    }];
    return row0;
}

- (void)testApi {
    TVUPLUsersAPI
        .get()
        .mainQueue()
        .name(@"UidInfo")
        .then(^BOOL(TVUTuple *tuple) {
            
            NSError *error = [tuple[2] toErrorValue];
            if (error) {
                return NO;
            }
            
            NSLog(@"sharexia: info=%@", [tuple[1] toStringValue]);
            return YES; // 返回 NO 表示需要 Retry
        });
}

- (void)testSync {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        TVUTuple *result0 = TVUPLUsersAPI.parameter(@(1)).sync();
        NSError *error0 = [result0[1] toErrorValue];
        if (error0) {
            NSLog(@"error0:%@", error0.localizedDescription);
            return;
        } else {
            NSLog(@"info0=%@", [result0[1] toStringValue]);
        }
        TVUTuple *result1 = TVUPLUsersAPI.parameter(@(2)).sync();
        NSError *error1 = [result0[1] toErrorValue];
        if (error1) {
            NSLog(@"error1:%@", error1.localizedDescription);
            return;
        } else {
            NSLog(@"info1=%@", [result1[1] toStringValue]);
        }
    });
}

- (void)testTimeout {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        TVUTuple *result0 = TVUPLTimeoutAPI.parameter(nil).sync();
        NSError *error0 = [result0[1] toErrorValue];
        if (error0) {
            NSLog(@"error0:%@", error0.localizedDescription);
            return;
        } else {
            NSLog(@"info0=%@", [result0[1] toStringValue]);
        }
    });
}



@end
