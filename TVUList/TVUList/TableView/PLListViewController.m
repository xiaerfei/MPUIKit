//
//  PLListViewController.m
//  TVUList
//
//  Created by erfeixia on 2025/8/5.
//

#import "PLListViewController.h"
#import "TVUPLListView.h"
#import "Masonry.h"

#define TVUColorWithRHedix(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface PLListViewController ()
@property (nonatomic, strong) TVUPLListView *listView;
@end

@implementation PLListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TVUColorWithRHedix(0x141414);
    self.listView = [[TVUPLListView alloc] init];
    [self.view addSubview:self.listView];
    
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view.mas_safeAreaLayoutGuide);
    }];
    __weak typeof(self) weakSelf = self;
    [self.listView setFetchSectionsBlock:^NSArray<TVUPLSection *> * _Nonnull{
        __strong typeof(weakSelf) self = weakSelf;
        return @[
            [self loginSection],
            [self commonSection],
        ];
    }];
    [self.listView reload];
}
- (IBAction)refreshAction:(id)sender {
    [self.listView reload];
}

#pragma mark - Sections
#pragma mark Login
- (TVUPLSection *)loginSection {
    TVUPLSection *section =
    [[TVUPLSection alloc] initWithKey:@"Login"];
    section.insets = UIEdgeInsetsMake(0, 15, 20, 15);
    section.backgroundColor = TVUColorWithRHedix(0x1F1F1F);
    section.cornerRadius = 8;
    
    __weak typeof(self) weakSelf = self;
    [section setFetchSectionParameterBlock:^(TVUPLSection * _Nonnull section) {
        __strong typeof(weakSelf) self = weakSelf;
        [section addRow:[self loginRow]];
        [section addRow:[self unloginRow]];
    }];
    
    
    return section;
}

- (TVUPLRow *)loginRow {
    TVUPLRow *row =
    [[TVUPLRow alloc] initWithType:TVUPLRowTypeLogin
                               key:@"Login"];
    [row setFetchRowParameterBlock:^(TVUPLRow * _Nonnull row) {
        row.showIndicator = NO;
        row.height = 60;
        row.rowData = @{
            @"name" : @"sharexia",
            @"email" : @"sharexia@tvunetworks.com",
            @"first" : @"s",
        };
    }];
    return row;
}

- (TVUPLRow *)unloginRow {
    TVUPLRow *row =
    [[TVUPLRow alloc] initWithType:TVUPLRowTypeUnLogin
                               key:@"unLogin"];
    [row setFetchRowParameterBlock:^(TVUPLRow * _Nonnull row) {
        row.showIndicator = YES;
        row.height = 60;
        row.rowData = @{
            @"text" : @"登录",
        };
    }];
    return row;
}
#pragma mark - Common
- (TVUPLSection *)commonSection {
    TVUPLSection *section =
    [[TVUPLSection alloc] initWithKey:@"Common"];
    section.insets = UIEdgeInsetsMake(20, 15, 20, 15);
    section.backgroundColor = TVUColorWithRHedix(0x1F1F1F);
    section.cornerRadius = 8;
    __weak typeof(self) weakSelf = self;
    [section setFetchSectionParameterBlock:^(TVUPLSection * _Nonnull section) {
        __strong typeof(weakSelf) self = weakSelf;
        [section addRow:[self audioDeviceRow]];
        [section addRow:[self videoDeviceRow]];
        [section addRow:[self pgmPreviewRow]];
        [section addRow:[self audioOnlyRow]];
        [section addRow:[self mirrorRow]];
        [section addRow:[self regionRow]];
        [section addRow:[self debugRow]];
        [section addRow:[self ntpOffsetRow]];
    }];
    
    return section;
}

- (TVUPLRow *)audioDeviceRow {
    TVUPLRow *row =
    [[TVUPLRow alloc] initWithType:TVUPLRowTypeDefault
                               key:@"AudioDevice"];
    [row setFetchRowParameterBlock:^(TVUPLRow * _Nonnull row) {
        row.showIndicator = YES;
        row.height = 44;
        row.rowData = @{
            @"text" : @"音频设备",
        };
    }];
    return row;
}

- (TVUPLRow *)videoDeviceRow {
    TVUPLRow *row =
    [[TVUPLRow alloc] initWithType:TVUPLRowTypeDefault
                               key:@"VideoDevice"];
    [row setFetchRowParameterBlock:^(TVUPLRow * _Nonnull row) {
        row.showIndicator = YES;
        row.height = 44;
        row.rowData = @{
            @"text" : @"视频设备",
        };
    }];
    return row;
}

- (TVUPLRow *)pgmPreviewRow {
    TVUPLRow *row =
    [[TVUPLRow alloc] initWithType:TVUPLRowTypeSwitch
                               key:@"PGMPreview"];
    [row setFetchRowParameterBlock:^(TVUPLRow * _Nonnull row) {
        row.showIndicator = NO;
        row.unselected = YES;
        row.height = 44;
        row.rowData = @{
            @"text" : @"PGM 预览",
            @"value" : @YES
        };
    }];
    return row;
}

- (TVUPLRow *)audioOnlyRow {
    TVUPLRow *row =
    [[TVUPLRow alloc] initWithType:TVUPLRowTypeSwitch
                               key:@"AudioOnly"];
    [row setFetchRowParameterBlock:^(TVUPLRow * _Nonnull row) {
        row.showIndicator = NO;
        row.unselected = YES;
        row.height = 44;
        row.rowData = @{
            @"text" : @"纯音频模式",
            @"value" : @NO
        };
    }];
    return row;
}

- (TVUPLRow *)mirrorRow {
    TVUPLRow *row =
    [[TVUPLRow alloc] initWithType:TVUPLRowTypeSwitch
                               key:@"Mirror"];
    [row setFetchRowParameterBlock:^(TVUPLRow * _Nonnull row) {
        row.showIndicator = NO;
        row.unselected = YES;
        row.height = 44;
        row.rowData = @{
            @"text" : @"镜像输出前置摄像头",
            @"value" : @NO
        };
    }];
    return row;
}

- (TVUPLRow *)regionRow {
    TVUPLRow *row =
    [[TVUPLRow alloc] initWithType:TVUPLRowTypeDefault
                               key:@"Region"];
    [row setFetchRowParameterBlock:^(TVUPLRow * _Nonnull row) {
        row.showIndicator = YES;
        row.height = 44;
        row.rowData = @{
            @"text" : @"区域",
            @"value" : @"Global"
        };
    }];
    return row;
}

- (TVUPLRow *)debugRow {
    TVUPLRow *row =
    [[TVUPLRow alloc] initWithType:TVUPLRowTypeSwitch
                               key:@"Debug"];
    [row setFetchRowParameterBlock:^(TVUPLRow * _Nonnull row) {
        row.showIndicator = NO;
        row.unselected = YES;
        row.height = 44;
        row.rowData = @{
            @"text" : @"调试",
            @"value" : @NO
        };
    }];
    return row;
}

- (TVUPLRow *)ntpOffsetRow {
    TVUPLRow *row =
    [[TVUPLRow alloc] initWithType:TVUPLRowTypeDefault
                               key:@"NTPOffset"];
    [row setFetchRowParameterBlock:^(TVUPLRow * _Nonnull row) {
        row.showIndicator = NO;
        row.unselected = YES;
        row.height = 44;
        row.rowData = @{
            @"text" : @"NTP",
            @"value" : @"33ms"
        };
    }];
    return row;
}
@end
