//
//  ViewController.m
//  TVUCollectionView
//
//  Created by erfeixia on 2025/9/13.
//

#import "ViewController.h"
#import "TVUPLListView.h"
#import "Masonry.h"

@interface ViewController ()
@property (nonatomic, strong) TVUPLListView *listView;
@property (nonatomic, assign) BOOL loginHide;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromHex(0x141414);
    
    self.listView = [[TVUPLListView alloc] init];
    [self.view addSubview:self.listView];
    
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view.mas_safeAreaLayoutGuide);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuide).offset(-40);
    }];
    
    [self.listView registerClassForRow:@"CustomCell"];
    [self.listView registerClassForRow:kTVUPLDefaultRow];
    [self.listView registerClassForRow:kTVUPLSwitchRow];
    [self.listView registerClassForRow:kTVUPLLoginRow];
    [self.listView registerClassForRow:kTVUPLRightValueRow];

    
    
    self.listView
        .cornerRadius(8)
        .insets(UIEdgeInsetsZero)
        .sectionColor(UIColor.lightGrayColor)
        .prefetch(^(TVUPLListView *list) { list
            .sections(@[
                [self loginSection],
                [self videoSection],
                [self audioSection],
                [self multistreamSection],
                [self backupClipsSection]
            ]);
        });
    [self.listView reload];
}


#pragma mark - Action Methods

- (IBAction)testBtnAction:(id)sender {
    self.loginHide = !self.loginHide;
    [self.listView reloadSectionForKeys:@[@"LoginSection"]];
//    [self.listView reloadRowForKeys:@[@"UnloginRow", @"LoginRow"]];
}

#pragma mark - sections
- (TVUPLSection *)loginSection {
    return SectionReuse
        .key(@"LoginSection")
        .cornerRadius(8)
        .insets(UIEdgeInsetsMake(0, 20, 0, 20))
        .backgroundColor(UIColorFromHex(0x1F1F1F))
        .prefetch(^(TVUPLSection *section) { section
//            .hidden(self.loginHide)
            .rows(@[
                RowReuse(kTVUPLDefaultRow).key(@"UnloginRow")
                    .showIndicator(YES)
                    .height(60)
                    .prefetch(^(TVUPLRow *row) { row
                        .hidden(!self.loginHide)
                        .rowData(^ { RowData
                            .title(@"Login")
                            .titleFont(@16)
                            .systemIcon(@"person.crop.circle")
                            .iconTintColor([UIColor grayColor])
                            .iconSize(CGSizeMake(40, 40));
                        });
                    }),
                RowReuse(kTVUPLLoginRow)
                    .key(@"LoginRow")
                    .showIndicator(YES)
                    .height(60)
                    .prefetch(^(TVUPLRow *row) { row
                        .hidden(self.loginHide)
                        .rowData(^ { RowData
                            .title(@"sharexia")
                            .titleFont(@20)
                            .subtitle(@"sharexia@tvunetworks.com")
                            .loginBigWord(@"S");
                        });
                    })
                    .tap(^(TVUPLRow *row, id value) {
                        NSLog(@"1 click");
                    }),
            ]);
        });
}

- (TVUPLSection *)videoSection {
    return SectionReuse
        .key(@"VideoSection")
        .cornerRadius(8)
        .insets(UIEdgeInsetsMake(10, 20, 0, 20))
        .backgroundColor(UIColorFromHex(0x1F1F1F))
        .prefetch(^(TVUPLSection *section) { section
            .rows(@[
                RowReuse(kTVUPLDefaultRow)
                    .type(TVUPLRowTypeHeader)
                    .height(30)
                    .rowData(^ { RowData
                        .title(@"Video")
                        .titleColor([UIColor grayColor])
                        .icon(@"tvu_setting_camera")
                        .iconSize(CGSizeMake(16, 16));
                    }),
                RowReuse(kTVUPLRightValueRow)
                    .key(@"Resolution")
                    .showIndicator(YES)
                    .prefetch(^(TVUPLRow *row) { row
                        .rowData(^{ RowData
                            .title(@"Resolution")
                            .rightScale(0.6)
                            .rightValue(@"1280x720");
                        });
                    })
                    .tap(^(TVUPLRow *row, id value) {
                        NSLog(@"1 click");
                    }),
                RowReuse(kTVUPLRightValueRow)
                    .key(@"FrameRate")
                    .showIndicator(YES)
                    .prefetch(^(TVUPLRow *row) { row
                        .rowData(^{ RowData
                            .title(@"Frame rate")
                            .rightScale(0.6)
                            .rightValue(@"30P");
                        });
                    })
                    .tap(^(TVUPLRow *row, id value) {
                        NSLog(@"1 click");
                    }),
            ]);
        });
}

- (TVUPLSection *)audioSection {
    return SectionReuse
        .key(@"AudioSection")
        .cornerRadius(8)
        .insets(UIEdgeInsetsMake(10, 20, 0, 20))
        .backgroundColor(UIColorFromHex(0x1F1F1F))
        .prefetch(^(TVUPLSection *section) { section
            .rows(@[
                RowReuse(kTVUPLDefaultRow)
                    .type(TVUPLRowTypeHeader)
                    .height(30)
                    .rowData(^ { RowData
                        .title(@"Audio")
                        .titleColor([UIColor grayColor])
                        .icon(@"tvu_cover_mic")
                        .iconSize(CGSizeMake(16, 16));
                    }),
                RowReuse(kTVUPLRightValueRow)
                    .key(@"Screenshare")
                    .showIndicator(YES)
                    .prefetch(^(TVUPLRow *row) { row
                        .rowData(^{ RowData
                            .title(@"Screenshare")
                            .rightScale(0.6)
                            .rightValue(@"Mix");
                        });
                    })
                    .tap(^(TVUPLRow *row, id value) {
                        NSLog(@"1 click");
                    }),
            ]);
        });
}

- (TVUPLSection *)multistreamSection {
    return SectionReuse
        .key(@"MultistreamSection")
        .cornerRadius(8)
        .insets(UIEdgeInsetsMake(10, 20, 0, 20))
        .backgroundColor(UIColorFromHex(0x1F1F1F))
        .prefetch(^(TVUPLSection *section) { section
            .rows(@[
                RowReuse(kTVUPLDefaultRow)
                    .type(TVUPLRowTypeHeader)
                    .height(30)
                    .rowData(^ { RowData
                        .title(@"Multistream")
                        .titleColor([UIColor grayColor])
                        .icon(@"tvu_share_platforms")
                        .iconSize(CGSizeMake(16, 16));
                    }),
                RowReuse(kTVUPLDefaultRow)
                    .key(@"StreamInfo")
                    .showIndicator(YES)
                    .prefetch(^(TVUPLRow *row) { row
                        .rowData(^{ RowData
                            .title(@"Stream Info");
                        });
                    })
                    .tap(^(TVUPLRow *row, id value) {
                        NSLog(@"1 click");
                    }),
                RowReuse(kTVUPLDefaultRow)
                    .key(@"SocialPlatforms")
                    .showIndicator(YES)
                    .prefetch(^(TVUPLRow *row) { row
                        .rowData(^{ RowData
                            .title(@"Social Platforms");
                        });
                    })
                    .tap(^(TVUPLRow *row, id value) {
                        NSLog(@"1 click");
                    }),
            ]);
        });
}

- (TVUPLSection *)backupClipsSection {
    return SectionReuse
        .key(@"BackupClipsSection")
        .cornerRadius(8)
        .insets(UIEdgeInsetsMake(10, 20, 0, 20))
        .backgroundColor(UIColorFromHex(0x1F1F1F))
        .prefetch(^(TVUPLSection *section) { section
            .rows(@[
                RowReuse(kTVUPLDefaultRow)
                    .type(TVUPLRowTypeHeader)
                    .height(30)
                    .rowData(^ { RowData
                        .title(@"Backup Clips")
                        .titleColor([UIColor grayColor])
                        .icon(@"tvu_setting_backupclips")
                        .iconSize(CGSizeMake(16, 16));
                    }),
                RowReuse(kTVUPLSwitchRow)
                    .key(@"StreamInfo")
                    .prefetch(^(TVUPLRow *row) { row
                        .rowData(^{ RowData
                            .title(@"Disaster Recovery")
                            .subtitle(@"Switch backup source when detect black frame");
                        });
                    })
                    .tap(^(TVUPLRow *row, id value) {
                        NSLog(@"1 click");
                    }),
            ]);
        });
}

- (TVUPLSection *)loginSectionTest {
    return SectionReuse
        .key(@"LoginSectionTest")
        .cornerRadius(8)
        .insets(UIEdgeInsetsMake(0, 20, 0, 20))
        .backgroundColor(UIColorFromHex(0x1F1F1F))
        .prefetch(^(TVUPLSection *section) { section
            .rows(@[
                RowReuse(kTVUPLDefaultRow)
                .type(TVUPLRowTypeHeader)
                .rowData(^ { RowData
                    .title(@"header");
                }),
                RowReuse(kTVUPLDefaultRow)
                    .key(@"LoginTest")
                    .showIndicator(YES)
                    .prefetch(^(TVUPLRow *row) { row
                        .rowData(^{ RowData
                            .title(self.loginHide ? @"Login" : @"This is test")
                            .titleFont(@16)
                            .systemIcon(@"person.crop.circle")
                            .iconTintColor([UIColor grayColor])
                            .iconSize(CGSizeMake(40, 40));
                        });
                    })
                    .tap(^(TVUPLRow *row, id value) {
                        NSLog(@"1 click");
                    }),
                RowReuse(kTVUPLLoginRow)
                    .key(@"login")
                    .showIndicator(YES)
                    .prefetch(^(TVUPLRow *row) { row
                        .rowData(^ { RowData
                            .title(@"sharexia@tvunetworks.com")
                            .titleFont(@20)
                            .subtitle(@"sharexia@tvunetworks.com")
                            .loginBigWord(@"S");
                        });
                    })
                    .tap(^(TVUPLRow *row, id value) {
                        NSLog(@"1 click");
                    }),
                RowReuse(kTVUPLDefaultRow)
                    .key(@"xxxxxx")
                    .showIndicator(YES).prefetch(^(TVUPLRow *row) { row
                        .hidden(self.loginHide)
                        .rowData(^id { RowData
                            .title(@"RTMP(s)Push")
                            .subtitle(@"rtmp://127.0.0.1/app")
                            .icon(@"tvu_cover_rtmp")
                            .iconSize(CGSizeMake(30, 30));
                        });
                    })
                    .tap(^(TVUPLRow *row, id value) {
                        NSLog(@"1 click");
                    }),
                RowReuse(kTVUPLDefaultRow)
                    .key(@"login")
                    .showIndicator(YES)
                    .rowData(^ { RowData
                        .title(@"增加了用户指定的常量定义，统一了数据字典的键名，避免硬编码.调整默认样式：title 默认白色 15 号字体，subtitle 默认灰色 13 号字体，icon 默认")
                        .icon(@"tvu_cover_tiktok")
                        .titleFont(@19);
                    })
                    .tap(^(TVUPLRow *row, id value) {
                        NSLog(@"1 click");
                    }),
                RowReuse(kTVUPLDefaultRow)
                    .key(@"login")
                    .showIndicator(YES)
                    .rowData(^{
                        return @{
                            kTVUPLRowTitle : @"YouTube",
                            kTVUPLRowIcon : @"tvu_cover_youtube",
                        };
                    })
                    .tap(^(TVUPLRow *row, id value) {
                        NSLog(@"1 click");
                    }),
                RowReuse(kTVUPLDefaultRow)
                    .key(@"login")
                    .showIndicator(YES)
                    .rowData(^ { RowData
                        .title(@"增加了用户指定的常量定义，统一了数据字典的键名，避免硬编码.调整默认样式：title 默认白色 15 号字体，subtitle 默认灰色 13 号字体，icon 默认 20x20.提取了布局相关的常量（如间距），方便后续统一修改.优化了约束更新逻辑，使用mas_remakeConstraints更清晰地重置约束.完善了各种边缘情况的布局处理，确保显示符合预期");
                    })
                    .tap(^(TVUPLRow *row, id value) {
                        NSLog(@"1 click");
                    }),
                RowReuse(kTVUPLSwitchRow)
                    .key(@"login")
                    .rowData(^ { RowData
                        .title(@"Twitch")
                        .subtitle(@"好戏开场了,新增常量：添加了kTVUPLRowSwitchOn（开关状态）和kTVUPLRowSwitchEnabled（开关可用性），统一配置入口。")
                        .icon(@"tvu_cover_twitch")
                        .switchOn(NO);
                    })
                    .tap(^(TVUPLRow *row, id value) {
                        NSLog(@"1 click");
                    }),
                RowReuse(kTVUPLDefaultRow)
                    .key(@"login")
                    .showIndicator(YES)
                    .rowData(^ { RowData
                        .title(@"继承与复用：复用了TVUPLDefaultRow的核心布局逻辑（icon、title、subtitle 的排列），仅在右侧新增UISwitch. 新增常量：添加了kTVUPLRowSwitchOn（开关状态）和kTVUPLRowSwitchEnabled（开关可用性），统一配置入口。");
                    })
                    .tap(^(TVUPLRow *row, id value) {
                        NSLog(@"1 click");
                    }),
                RowReuse(kTVUPLDefaultRow)
                    .key(@"login")
                    .showIndicator(YES)
                    .rowData(^ { RowData
                        .title(@"This is title")
                        .subtitle(@"继承与复用：复用了TVUPLDefaultRow的核心布局逻辑（icon、title、subtitle 的排列），仅在右侧新增UISwitch. 新增常量：添加了kTVUPLRowSwitchOn（开关状态）和kTVUPLRowSwitchEnabled（开关可用性），统一配置入口。");
                    })
                    .tap(^(TVUPLRow *row, id value) {
                        NSLog(@"1 click");
                    }),
                RowReuse(kTVUPLRightValueRow)
                    .key(@"login")
                    .showIndicator(YES)
                    .rowData(^{ RowData
                        .title(@"Screenshare")
                        .rightValue(@"Mix")
                        .rightScale(0.7);
                    })
                    .tap(^(TVUPLRow *row, id value) {
                        NSLog(@"1 click");
                    }),
                RowReuse(kTVUPLRightValueRow)
                    .key(@"yyyyyy")
                    .showIndicator(YES)
                    .prefetch(^(TVUPLRow *row) { row
                        .hidden(self.loginHide)
                        .rowData(^ { RowData
                            .title([NSString stringWithFormat:@"%@", [NSDate date]])
                            .titleFont(@"")
                            .titleColor(UIColor.grayColor)
                            .custom(@"", @"");
                        });
                    })
                    .tap(^(TVUPLRow *row, id value) {
                        NSLog(@"1 click");
                    }),
                RowReuse(kTVUPLDefaultRow)
                .type(TVUPLRowTypeFooter)
                .rowData(^ { RowData
                    .title(@"footer");
                }),
            ]);
        });
}

- (TVUPLSection *)testSection {
    NSMutableArray *rows = @[].mutableCopy;
    [rows addObject:RowReuse(@"CustomCell")
     .type(TVUPLRowTypeHeader)
     .rowData(^ {return @"Header"; })
     .height(20)
     .tap(^(TVUPLRow *row, id value) {
         NSLog(@"2-Header click");
     })];
    for (int i = 0; i < 20; i++) {
        NSString *dataStr = [NSString stringWithFormat:@"2-%d", i];
        NSString *clickStr = [NSString stringWithFormat:@"%@ click", dataStr];
        [rows addObject:RowReuse(@"CustomCell")
         .rowData(^ { return dataStr; })
         .tap(^(TVUPLRow *row, id value) {
             NSLog(@"%@", clickStr);
         })];
    }
    [rows addObject:RowReuse(@"CustomCell")
     .type(TVUPLRowTypeFooter)
     .rowData(^ { return @"Footer"; })
     .tap(^(TVUPLRow *row, id value) {
         NSLog(@"2-Footer click");
     })];
    
    return SectionReuse
        .key(@"LoginSection")
        .prefetch(^(TVUPLSection *section) { section
            .insets(UIEdgeInsetsMake(0, 20, 0, 20))
            .cornerRadius(16)
            .backgroundColor(UIColorFromHex(0x1F1F1F))
            .rows(rows);
        });
}

@end
