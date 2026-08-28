//
//  ViewController.m
//  StaticViewDemo
//
//  Created by erfeixia on 2025/12/14.
//

#import "ViewController.h"
#import "TVUPLListConst.h"
#import "TVUStaticView.h"
#import "TVUPLState.h"
#import "Masonry.h"

#define UIColorFromHex(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ViewController ()
@property (nonatomic, strong) TVUStaticView *staticView;
@property (nonatomic, strong) TVUPLState <NSString *>*pidString;
@property (nonatomic, assign) BOOL unlogin;
@end

@implementation ViewController {
    NSInteger _count;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromHex(0x141414);
    
    self.pidString = [TVUPLState value:@"If you transfer data from your previous iOS device with TVU Anywhere installed to your new iPhone, iPad, please reset PID"];
    
    self.staticView = [[TVUStaticView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.staticView];
    
    [self.staticView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
    }];
    
    self.staticView
        .prefetch(^(TVUStaticView *list) { list
            .sections(@[
                [self loginSection],
                [self videoSection],
                [self audioSection],
                [self multistreamSection],
                [self backupClipsSection],
            ]);
        });
    [self.staticView reload];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"Change" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(changeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        make.width.equalTo(@100);
    }];
}

- (void)changeAction {
    switch (_count) {
        case 1:
            self.pidString.value = @"这是业内较普遍的判断，认为本轮是持续2-3年的“超级周期”，价格上涨势头可能在2026年底趋缓，但价格真正回落要等到2027年。";
            break;
        case 2:
            self.pidString.value = @"理解预测分歧的关键在于区分不同产品。";
            break;
        case 3:
            self.pidString.value = @"根据最新的市场分析，这次内存涨价主要由人工智能（AI）需求爆发导致，因此难以像显卡降价那样因“挖矿”需求消失而快速回调。价格回归正常的时间窗口存在不确定性，市场主流观点是高价将持续2-3年，但也有较悲观或短期看跌的观点。在 ReactiveCocoa (RAC) 里，信号本质上是异步的。但有时候我们需要在方法里“同步”拿到结果，这就涉及到如何设计一个 同步方法。这里的“同步”并不是让 RAC 真正阻塞线程，而是通过一些技巧在调用点上拿到结果。";
            break;
        default:
            self.pidString.value = @"If you transfer data from your previous iOS device with TVU Anywhere installed to your new iPhone, iPad, please reset PID";
            break;
    }
    _count++;
    if (_count >= 5) {
        _count = 1;
    }
}
#pragma mark - Components
- (TVUPLRow *)headerRow:(NSString *)title icon:(NSString *)icon {
    return RowDefault
        .type(TVUPLRowTypeHeader)
        .height(30)
        .viewData(LabelData(kTVUPLDataTitle)
                .text(title)
                .font([UIFont systemFontOfSize:13])
                .textColor([UIColor grayColor]))
        .viewData(ImageData(kTVUPLDataImage)
                .icon(icon)
                .size(CGSizeMake(16, 16)));
}
#pragma mark - Sections
- (TVUPLSection *)loginSection {
    return SectionUse.rows(@[
        RowCustom(kTVUPLLoginRow)
            .height(50)
            .viewData(LabelData(kTVUPLDataTitle)
                    .text(@"Sharexia")
                    .font([UIFont systemFontOfSize:21])
                    .numberOfLines(1))
            .viewData(LabelData(kTVUPLDataSubtitle)
                    .text(@"sharexia@tvunetworks.com")
                    .textColor([UIColor lightGrayColor]))
            .viewData(LabelData(kTVUPLDataKey0)
                    .text(@"S")
                    .font([UIFont systemFontOfSize:25])
                    .textAlignment(NSTextAlignmentCenter)
                    .textColor([UIColor whiteColor])
                    .cornerRadius(20)
                    .frame(CGRectMake(0, 0, 40, 40))
                    .backgroundColor([UIColor colorWithRed:82.0f/255.0f
                                                     green:80.0f/255.0f
                                                      blue:236.0f/255.0f
                                                     alpha:1]))
            .onTap(^{
                NSLog(@"Login click");
            })
            .prefetch(^(TVUPLRow *row) { row
                .hidden(!self.unlogin);
            }),
        RowDefault
            .height(50)
            .showIndicator(YES)
            .viewData(LabelData(kTVUPLDataTitle)
                    .text(@"UnLogin")
                    .font([UIFont systemFontOfSize:16]))
            .viewData(ImageData(kTVUPLDataImage)
                    .systemIcon(@"person.crop.circle")
                    .tintColor([UIColor grayColor])
                    .size(CGSizeMake(40, 40)))
            .prefetch(^(TVUPLRow *row) { row
                .hidden(self.unlogin);
            }),
        RowUse(@"Subscription")
            .height(40)
            .showIndicator(YES)
            .viewData(LabelData(kTVUPLDataValue)
                    .text(@"Base")
                    .textColor([UIColor lightGrayColor])),
        RowUse(@"Reset PID")
            .showIndicator(YES)
            .bindValue(self.pidString)
            .viewData(LabelData(kTVUPLDataValue)
                    .custom(kTVUPLDataScale, @(0.6))),
    ]);
}
#pragma mark - Video
- (TVUPLSection *)videoSection {
    return SectionUse.rows(@[
        [self headerRow:@"Video" icon:@"tvu_setting_camera"],
        RowUse(@"Resolution")
            .value(@"1920x1080")
            .onTap(^{
                NSLog(@"1 click");
            }),
        RowUse(@"Frame Rate")
            .value(@"60p")
            .onTap(^{
                NSLog(@"1 click");
            }),
    ]);
}
#pragma mark - Audio
- (TVUPLSection *)audioSection {
    return SectionUse.rows(@[
        [self headerRow:@"Audio" icon:@"tvu_cover_mic"],
        RowUse(@"Share Screen")
            .value(@"Mix Mic and Audio from Share screen")
            .onTap(^{
                NSLog(@"1 click");
            }),
    ]);
}
#pragma mark - Multistream
- (TVUPLSection *)multistreamSection {
    return SectionUse.rows(@[
        [self headerRow:@"Multistream" icon:@"tvu_share_platforms"],
        RowUse(@"Stream Info")
            .onTap(^{
                NSLog(@"1 click");
            }),
        RowUse(@"Social Platforms")
            .onTap(^{
                NSLog(@"1 click");
            }),
    ]);
}
#pragma mark - Backup Clips
- (TVUPLSection *)backupClipsSection {
    return SectionUse.rows(@[
        [self headerRow:@"Backup Clips" icon:@"tvu_setting_backupclips"],
        RowUse(@"Disaster Recovery")
            .viewData(LabelData(kTVUPLDataSubtitle)
                    .text(@"Switch backup source when detect black frame")
                    .font([UIFont systemFontOfSize:12])
                    .textColor(UIColor.lightTextColor))
            .onTap(^{
                NSLog(@"1 click");
            }),
        RowUse(@"Manage backup clips")
            .onTap(^{
                NSLog(@"1 click");
            }),
    ]);
}
@end
