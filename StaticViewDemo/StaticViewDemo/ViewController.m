//
//  ViewController.m
//  StaticViewDemo
//
//  Created by erfeixia on 2025/12/14.
//  仿 TVUIRLSettingViewController 的 UI 结构（仅 UI，业务逻辑以 NSLog 占位）
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
///< Customize Delay & Bitrate 主开关：Delay / Bitrate 两行的显隐跟随它
@property (nonatomic, strong) TVUPLState <NSNumber *>*streamTuningOn;
///< Connection Boost 主开关：Connection Phones 行的显隐跟随它
@property (nonatomic, strong) TVUPLState <NSNumber *>*peerLinkOn;
@property (nonatomic, assign) BOOL unlogin;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = UIColorFromHex(0x141414);

    self.streamTuningOn = [TVUPLState value:@NO];
    self.peerLinkOn     = [TVUPLState value:@NO];

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
                [self platformsSection],
                [self backupSection],
                [self mirrorSection],
                [self externalDeviceSection],
                [self streamSettingSection],
                [self peerLinkSection],
            ]);
        });
    [self.staticView reload];
}
#pragma mark - Components
///< 深色卡片（对应线上 0x1F1F1F 圆角卡）
- (TVUPLSection *)cardSection {
    return SectionUse.sectionData(ViewUse
            .backgroundColor(UIColorFromHex(0x1F1F1F))
            .cornerRadius(8)
            .insets(UIEdgeInsetsMake(0, 15, 0, 15)));
}

///< 卡片上方的图标小标题
- (TVUPLRow *)headerRow:(NSString *)title icon:(NSString *)icon {
    return RowDefault
        .type(TVUPLRowTypeHeader)
        .height(40)
        .titleData(LabelUse
                .text(title)
                .font([UIFont systemFontOfSize:13])
                .textColor([UIColor grayColor]))
        .imageData(ImageUse
                .icon(icon)
                .size(CGSizeMake(16, 16)));
}

///< 卡片下方的小字说明
- (TVUPLRow *)footerRow:(NSString *)text {
    return RowDefault
        .type(TVUPLRowTypeFooter)
        .titleData(LabelUse
                .text(text)
                .font([UIFont systemFontOfSize:12])
                .textColor(UIColorFromHex(0x9E9E9E)));
}
#pragma mark - Sections
- (TVUPLSection *)loginSection {
    return [self cardSection].rows(@[
        RowCustom(kTVUPLLoginRow)
            .height(80)
            .showIndicator(YES)
            .titleData(LabelUse
                    .text(@"Sharexia")
                    .font([UIFont systemFontOfSize:21])
                    .numberOfLines(1))
            .subtitleData(LabelUse
                    .text(@"sharexia@tvunetworks.com")
                    .textColor([UIColor lightGrayColor]))
            .viewData(LabelData(kTVUPLDataKey0)
                    .text(@"S")
                    .font([UIFont systemFontOfSize:25])
                    .textAlignment(NSTextAlignmentCenter)
                    .textColor([UIColor whiteColor])
                    .cornerRadius(20)
                    .frame(CGRectMake(0, 0, 40, 40))
                    .backgroundColor(UIColorFromHex(0x5250EC)))
            .onTap(^{ NSLog(@"push About"); })
            .prefetch(^(TVUPLRow *row) { row
                .hidden(!self.unlogin);
            }),
        RowUse(@"Login")
            .height(60)
            .showIndicator(YES)
            .onTap(^{ NSLog(@"present Login"); })
            .prefetch(^(TVUPLRow *row) { row
                .hidden(self.unlogin);
            }),
        RowUse(@"Subscription")
            .height(48)
            .value(@"Unlimited")
            .onTap(^{ NSLog(@"push Subscription"); }),
    ]);
}

- (TVUPLSection *)videoSection {
    return [self cardSection].rows(@[
        [self headerRow:@"Video" icon:@"tvu_setting_camera"],
        RowUse(@"Resolution")
            .height(48)
            .value(@"1920x1080")
            .onTap(^{ NSLog(@"push Resolution"); }),
        RowUse(@"Frame Rate")
            .height(48)
            .value(@"60p")
            .onTap(^{ NSLog(@"push Frame Rate"); }),
    ]);
}

- (TVUPLSection *)audioSection {
    return [self cardSection].rows(@[
        [self headerRow:@"Audio" icon:@"tvu_cover_mic"],
        RowUse(@"Share Screen")
            .height(48)
            .value(@"Mix Mic and Audio from Share screen")
            .onTap(^{ NSLog(@"push Share Screen"); }),
    ]);
}

- (TVUPLSection *)platformsSection {
    return [self cardSection].rows(@[
        [self headerRow:@"Streaming Destinations" icon:@"tvu_share_platforms"],
        RowUse(@"Stream Info")
            .height(48)
            .onTap(^{ NSLog(@"push Stream Info"); }),
        RowUse(@"Social Platforms")
            .height(48)
            .onTap(^{ NSLog(@"push Social Platforms"); }),
    ]);
}

- (TVUPLSection *)backupSection {
    return [self cardSection].rows(@[
        [self headerRow:@"Backup Content" icon:@"tvu_setting_backupclips"],
        RowSwitch(@"Enable Disconnect Protection")
            .height(48)
            .tap(^(TVUPLRow *row, id value) {
                NSLog(@"disconnect protection -> %@", value);
            }),
        RowUse(@"Manage Backup Content")
            .height(48)
            .onTap(^{ NSLog(@"push Manage Backup Content"); }),
        [self footerRow:@"Automatically play backup content if your stream signal is lost or interrupted."],
    ]);
}

///< Mirror 是画面偏好不是外设设置，线上是独立单行卡片，Nerd Mode 标题挂在它上方
- (TVUPLSection *)mirrorSection {
    return [self cardSection].rows(@[
        [self headerRow:@"Nerd Mode" icon:@"tvu_setting_camera"],
        RowSwitch(@"Mirror Front Camera Output")
            .height(68)
            .subtitle(@"Makes your live stream match your front camera preview.")
            .tap(^(TVUPLRow *row, id value) {
                NSLog(@"mirror front output -> %@", value);
            }),
    ]);
}

- (TVUPLSection *)externalDeviceSection {
    return [self cardSection].rows(@[
        RowSwitch(@"UVC Camera")
            .height(64)
            .switchOn(YES)
            .subtitleData(LabelUse
                    .text(@"Connected")
                    .font([UIFont systemFontOfSize:12])
                    .textColor([UIColor systemGreenColor]))
            .tap(^(TVUPLRow *row, id value) {
                NSLog(@"uvc camera -> %@", value);
            }),
        RowSwitch(@"SeeMo Device")
            .height(48)
            .tap(^(TVUPLRow *row, id value) {
                NSLog(@"seemo device -> %@", value);
            }),
        RowCustom(kTVUPLDeviceRow)
            .height(48)
            .title(@"OSMO POCKET 3")
            .switchOn(YES)
            .valueData(LabelUse.text(@"Starting Stream"))
            .imageData(ImageUse.tintColor(UIColorFromHex(0xFFCC00)))
            .tap(^(TVUPLRow *row, id value) {
                if (value) {
                    NSLog(@"dji device -> %@", value);
                } else {
                    NSLog(@"push DJI device setting");
                }
            }),
        RowDefault
            .height(48)
            .showIndicator(NO)
            .titleData(LabelUse
                    .text(@"Add")
                    .textAlignment(NSTextAlignmentCenter)
                    .textColor([UIColor systemBlueColor]))
            .onTap(^{ NSLog(@"push Add DJI Device"); }),
        [self footerRow:@"The app automatically reconnects your DJI device if the connection is lost. Turn the switch off when not in use."],
    ]);
}

- (TVUPLSection *)streamSettingSection {
    return [self cardSection].rows(@[
        RowSwitch(@"Customize Delay & Bitrate")
            .height(75)
            .subtitle(@"Adjust stream delay and bitrate for your network.")
            .prefetch(^(TVUPLRow *row) { row
                .switchOn(self.streamTuningOn.value.boolValue);
            })
            .tap(^(TVUPLRow *row, id value) {
                self.streamTuningOn.value = value;
            }),
        RowUse(@"Stream Delay")
            .height(48)
            .value(@"8s")
            .onTap(^{ NSLog(@"pick Stream Delay"); })
            .prefetch(^(TVUPLRow *row) { row
                .hidden(!self.streamTuningOn.value.boolValue);
            }),
        RowUse(@"Stream Bitrate")
            .height(48)
            .value(@"5mbps")
            .onTap(^{ NSLog(@"pick Stream Bitrate"); })
            .prefetch(^(TVUPLRow *row) { row
                .hidden(!self.streamTuningOn.value.boolValue);
            }),
        [self footerRow:@"Lower delay: lower latency but less protection against poor networks.\nHigher delay: greater stability and recovery capability during network degradation."],
    ]);
}

- (TVUPLSection *)peerLinkSection {
    return [self cardSection].rows(@[
        RowSwitch(@"Connection Boost")
            .height(68)
            .subtitle(@"Use nearby phones to make your stream stronger and more reliable.")
            .prefetch(^(TVUPLRow *row) { row
                .switchOn(self.peerLinkOn.value.boolValue);
            })
            .tap(^(TVUPLRow *row, id value) {
                self.peerLinkOn.value = value;
            }),
        RowUse(@"Connection Phones")
            .height(48)
            .valueData(LabelUse
                    .text(@"2 phones connected")
                    .font([UIFont systemFontOfSize:12])
                    .textColor([UIColor systemGreenColor]))
            .onTap(^{ NSLog(@"push Paired Devices"); })
            .prefetch(^(TVUPLRow *row) { row
                .hidden(!self.peerLinkOn.value.boolValue);
            }),
    ]);
}
@end
