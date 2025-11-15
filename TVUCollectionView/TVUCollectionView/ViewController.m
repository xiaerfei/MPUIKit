//
//  ViewController.m
//  TVUCollectionView
//
//  Created by erfeixia on 2025/9/13.
//

#import "ViewController.h"
#import "TVUPLListView.h"
#import "Masonry.h"

#define DictMake(Key, Value) \
    Key : (Value ?: [NSNull null])

#define RowData  return [TVUPLRowData new]

#define RowDataMake(properties) \
    rowData(^id { return \
        (properties); \
    })

@interface ViewController ()
@property (nonatomic, strong) TVUPLListView *listView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromHex(0x141414);
    
    self.listView = [[TVUPLListView alloc] init];
    [self.view addSubview:self.listView];
    
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view.mas_safeAreaLayoutGuide);
    }];
    
    [self.listView registerClassForRow:@"CustomCell"];
    [self.listView registerClassForRow:kTVUPLDefaultRow];
    [self.listView registerClassForRow:kTVUPLSwitchRow];
    [self.listView registerClassForRow:kTVUPLLoginRow];
    [self.listView registerClassForRow:kTVUPLRightValueRow];

    
    
    self.listView
        .prefetch(^(TVUPLListView *list) { list
            .cornerRadius(8)
            .insets(UIEdgeInsetsZero)
            .sectionColor(UIColor.lightGrayColor)
            .sections(@[
                [self loginSection],
                [self testSection],
            ]);
        });
    [self.listView reload];
}
- (TVUPLSection *)loginSection {
    return SectionReuse
        .prefetch(^(TVUPLSection *section) { section
            .key(@"LoginSection")
            .cornerRadius(8)
            .insets(UIEdgeInsetsMake(0, 20, 0, 20))
            .backgroundColor(UIColorFromHex(0x1F1F1F))
            .rows(@[
                RowReuse(kTVUPLDefaultRow)
                    .key(@"login")
                    .showIndicator(YES)
                    .hidden(NO)
                    .rowData(@{
                        kTVUPLRowTitle : @"Login",
                        kTVUPLRowTitleFont : @16,
                        kTVUPLRowSystemIcon : @"person.crop.circle",
                        kTVUPLRowIconTintColor : [UIColor grayColor],
                        kTVUPLRowIconSize : [NSValue valueWithCGSize:CGSizeMake(40, 40)]
                    })
                    .tap(^(TVUPLRow *row, id value) {
                        NSLog(@"1 click");
                    }),
                RowReuse(kTVUPLLoginRow)
                    .key(@"login")
                    .showIndicator(YES)
                    .rowData(@{
                        kTVUPLRowTitle : @"sharexia@tvunetworks.com",
                        kTVUPLRowTitleFont : @20,
                        kTVUPLRowSubtitle : @"sharexia@tvunetworks.com",
                        kTVUPLRowLoginBigWord : @"S",
                    })
                    .tap(^(TVUPLRow *row, id value) {
                        NSLog(@"1 click");
                    }),
                RowReuse(kTVUPLDefaultRow)
                    .key(@"login")
                    .showIndicator(YES)
                    .rowData(@{
                        kTVUPLRowTitle : @"RTMP(s)Push",
                        //                        kTVUPLRowSubtitle : @"rtmp://127.0.0.1/app",
                        kTVUPLRowIcon : @"tvu_cover_rtmp",
                        kTVUPLRowIconSize : [NSValue valueWithCGSize:CGSizeMake(30, 30)]
                    })
                    .tap(^(TVUPLRow *row, id value) {
                        NSLog(@"1 click");
                    }),
                RowReuse(kTVUPLDefaultRow)
                    .key(@"login")
                    .showIndicator(YES)
                    .rowData(@{
                        kTVUPLRowTitle : @"增加了用户指定的常量定义，统一了数据字典的键名，避免硬编码.调整默认样式：title 默认白色 15 号字体，subtitle 默认灰色 13 号字体，icon 默认",
                        kTVUPLRowIcon : @"tvu_cover_tiktok",
                        DictMake(kTVUPLRowTitleFont, @(19))
                    })
                    .tap(^(TVUPLRow *row, id value) {
                        NSLog(@"1 click");
                    }),
                RowReuse(kTVUPLDefaultRow)
                    .key(@"login")
                    .showIndicator(YES)
                    .rowData(@{
                        kTVUPLRowTitle : @"YouTube",
                        kTVUPLRowIcon : @"tvu_cover_youtube",
                    })
                    .tap(^(TVUPLRow *row, id value) {
                        NSLog(@"1 click");
                    }),
                RowReuse(kTVUPLDefaultRow)
                    .key(@"login")
                    .showIndicator(YES)
                    .rowData(@{
                        kTVUPLRowTitle : @"增加了用户指定的常量定义，统一了数据字典的键名，避免硬编码.调整默认样式：title 默认白色 15 号字体，subtitle 默认灰色 13 号字体，icon 默认 20x20.提取了布局相关的常量（如间距），方便后续统一修改.优化了约束更新逻辑，使用mas_remakeConstraints更清晰地重置约束.完善了各种边缘情况的布局处理，确保显示符合预期",
                    })
                    .tap(^(TVUPLRow *row, id value) {
                        NSLog(@"1 click");
                    }),
                RowReuse(kTVUPLSwitchRow)
                    .key(@"login")
                    .showIndicator(YES)
                    .rowData(@{
                        kTVUPLRowTitle : @"Twitch",
                        kTVUPLRowSubtitle : @"好戏开场了,新增常量：添加了kTVUPLRowSwitchOn（开关状态）和kTVUPLRowSwitchEnabled（开关可用性），统一配置入口。",
                        kTVUPLRowIcon  : @"tvu_cover_twitch",
                        kTVUPLRowSwitchOn : @YES,
                    })
                    .tap(^(TVUPLRow *row, id value) {
                        NSLog(@"1 click");
                    }),
                RowReuse(kTVUPLDefaultRow)
                    .key(@"login")
                    .showIndicator(YES)
                    .rowData(@{
                        kTVUPLRowSubtitle : @"继承与复用：复用了TVUPLDefaultRow的核心布局逻辑（icon、title、subtitle 的排列），仅在右侧新增UISwitch. 新增常量：添加了kTVUPLRowSwitchOn（开关状态）和kTVUPLRowSwitchEnabled（开关可用性），统一配置入口。",
                    })
                    .tap(^(TVUPLRow *row, id value) {
                        NSLog(@"1 click");
                    }),
                RowReuse(kTVUPLDefaultRow)
                    .key(@"login")
                    .showIndicator(YES)
                    .rowData(@{
                        kTVUPLRowTitle : @"This is title",
                        kTVUPLRowSubtitle : @"继承与复用：复用了TVUPLDefaultRow的核心布局逻辑（icon、title、subtitle 的排列），仅在右侧新增UISwitch. 新增常量：添加了kTVUPLRowSwitchOn（开关状态）和kTVUPLRowSwitchEnabled（开关可用性），统一配置入口。",
                    })
                    .tap(^(TVUPLRow *row, id value) {
                        NSLog(@"1 click");
                    }),
                RowReuse(kTVUPLRightValueRow)
                    .key(@"login")
                    .showIndicator(YES)
                    .rowData(@{
                        kTVUPLRowTitle : @"Screenshare",
                        kTVUPLRowRightValue : @"Mix",
                        kTVUPLRowRightScale : @(0.7),
                    })
                    .tap(^(TVUPLRow *row, id value) {
                        NSLog(@"1 click");
                    }),
                RowReuse(kTVUPLRightValueRow)
                    .key(@"login")
                    .showIndicator(YES)
                    .rowData(^id {
                        RowData
                            .title(@"")
                            .titleFont(@"")
                            .titleColor(UIColor.grayColor)
                            .custom(@"", @"");
                    })
                    .tap(^(TVUPLRow *row, id value) {
                        NSLog(@"1 click");
                    }),
            ]);
        });
}

- (TVUPLSection *)loginTestSection {
    return SectionReuse
        .prefetch(^(TVUPLSection *section) { section
            .key(@"LoginSection")
            .insets(UIEdgeInsetsMake(0, 20, 0, 20))
            .cornerRadius(8)
            .backgroundColor(UIColorFromHex(0x1F1F1F))
            .rows(@[
                RowReuse(@"CustomCell")
                    .type(TVUPLRowTypeHeader)
                    .rowData(@"Header")
                    .tap(^(TVUPLRow *row, id value) {
                        NSLog(@"first header click");
                    }),
                RowReuse(kTVUPLDefaultRow)
                    .key(@"login")
                    .rowData(@{
                        kTVUPLRowTitle : @"RTMP(s)Push",
                        kTVUPLRowSubtitle : @"rtmp://127.0.0.1/app",
                        kTVUPLRowIcon : [UIImage imageNamed:@"tvu_cover_rtmp"]
                    })
                    .tap(^(TVUPLRow *row, id value) {
                        NSLog(@"1 click");
                    }),
                RowReuse(kTVUPLDefaultRow)
                    .key(@"unlogin")
                    .hidden(NO)
                    .insets(UIEdgeInsetsMake(0, 20, 0, 0))
                    .rowData(@{
                        kTVUPLRowTitle : @"YouTube",
                    })
                    .tap(^(TVUPLRow *row, id value) {
                        NSLog(@"2 click");
                    }),
                RowReuse(@"CustomCell")
                    .key(@"unlogin")
                    .rowData(@"第 3 行")
                    .tap(^(TVUPLRow *row, id value) {
                        NSLog(@"3 click");
                    }),
                RowReuse(@"CustomCell")
                    .key(@"unlogin")
                    .hidden(NO)
                    .rowData(@"第 4 行")
                    .tap(^(TVUPLRow *row, id value) {
                        NSLog(@"4 click");
                    }),
                RowReuse(@"CustomCell")
                    .key(@"unlogin")
                    .rowData(@"第 5 行")
                    .tap(^(TVUPLRow *row, id value) {
                        NSLog(@"5 click");
                    }),
                RowReuse(@"CustomCell")
                    .key(@"unlogin")
                    .rowData(@"第 6 行")
                    .tap(^(TVUPLRow *row, id value) {
                        NSLog(@"6 click");
                    }),
                RowReuse(@"CustomCell")
                    .type(TVUPLRowTypeFooter)
                    .rowData(@"Footer")
                    .height(40).tap(^(TVUPLRow *row, id value) {
                        NSLog(@"first footer click");
                    }),
            ]);
        });
}

- (TVUPLSection *)testSection {
    NSMutableArray *rows = @[].mutableCopy;
    [rows addObject:RowReuse(@"CustomCell")
     .type(TVUPLRowTypeHeader)
     .rowData(@"Header")
     .height(20)
     .insets(UIEdgeInsetsMake(0, 0, 0, 0))
     .tap(^(TVUPLRow *row, id value) {
         NSLog(@"2-Header click");
     })];
    for (int i = 0; i < 20; i++) {
        NSString *dataStr = [NSString stringWithFormat:@"2-%d", i];
        NSString *clickStr = [NSString stringWithFormat:@"%@ click", dataStr];
        [rows addObject:RowReuse(@"CustomCell")
         .rowData(dataStr)
         .tap(^(TVUPLRow *row, id value) {
             NSLog(@"%@", clickStr);
         })];
    }
    [rows addObject:RowReuse(@"CustomCell")
     .type(TVUPLRowTypeFooter)
     .rowData(@"Footer")
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
