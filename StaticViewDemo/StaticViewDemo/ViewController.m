//
//  ViewController.m
//  StaticViewDemo
//
//  Created by erfeixia on 2025/12/14.
//

#import "ViewController.h"
#import "TVUPLListConst.h"
#import "TVUStaticView.h"
#import "Masonry.h"

#define UIColorFromHex(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ViewController ()
@property (nonatomic, strong) TVUStaticView *staticView;
@property (nonatomic, assign) BOOL unlogin;
@end

@implementation ViewController {
    NSInteger _count;
    NSString *_pidString;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromHex(0x141414);
    
    _pidString = @"If you transfer data from your previous iOS device with TVU Anywhere installed to your new iPhone, iPad, please reset PID";
    
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
            _pidString = @"这是业内较普遍的判断，认为本轮是持续2-3年的“超级周期”，价格上涨势头可能在2026年底趋缓，但价格真正回落要等到2027年。";
            break;
        case 2:
            _pidString = @"理解预测分歧的关键在于区分不同产品。";
            break;
        case 3:
            _pidString = @"根据最新的市场分析，这次内存涨价主要由人工智能（AI）需求爆发导致，因此难以像显卡降价那样因“挖矿”需求消失而快速回调。价格回归正常的时间窗口存在不确定性，市场主流观点是高价将持续2-3年，但也有较悲观或短期看跌的观点。";
            break;
        default:
            _pidString = @"If you transfer data from your previous iOS device with TVU Anywhere installed to your new iPhone, iPad, please reset PID";
            break;
    }
    _count++;
    if (_count >= 5) {
        _count = 1;
    }
    [self.staticView reloadRowForKey:@"ResetPID"];
}
#pragma mark - sections
- (TVUPLSection *)loginSection {
    return SectionUse
        .key(@"LoginSection")
        .prefetch(^(TVUPLSection *section) { section
            .rows(@[
                RowUse(kTVUPLLoginRow)
                    .key(@"LoginRow")
                    .showIndicator(YES)
                    .height(50)
                    .prefetch(^(TVUPLRow *row) { row
                        .hidden(!self.unlogin)
                        .viewData(^id { return LabelData(kTVUPLDataTitle)
                                .text(@"Sharexia")
                                .font([UIFont systemFontOfSize:21])
                                .numberOfLines(1)
                                .textColor([UIColor whiteColor]);
                        })
                        .viewData(^id { return LabelData(kTVUPLDataSubtitle)
                                .text(@"sharexia@tvunetworks.com")
                                .font([UIFont systemFontOfSize:13])
                                .textColor([UIColor lightGrayColor]);
                        })
                        .viewData(^id { return LabelData(kTVUPLDataKey0)
                                .text(@"S")
                                .font([UIFont systemFontOfSize:25])
                                .textAlignment(NSTextAlignmentCenter)
                                .textColor([UIColor whiteColor])
                                .cornerRadius(20)
                                .frame(CGRectMake(0, 0, 40, 40))
                                .backgroundColor([UIColor colorWithRed:82.0f/255.0f
                                                                 green:80.0f/255.0f
                                                                  blue:236.0f/255.0f
                                                                 alpha:1]);
                        })
                        .tap(^(TVUPLRow *row, id value) {
                            NSLog(@"Login click");
                        });
                    }),
                RowUse(kTVUPLDefaultRow)
                    .key(@"UnloginRow")
                    .showIndicator(YES)
                    .height(50)
                    .prefetch(^(TVUPLRow *row) { row
                        .hidden(self.unlogin)
                        .viewData(^id { return LabelData(kTVUPLDataTitle)
                                .text(@"UnLogin")
                                .font([UIFont systemFontOfSize:16])
                                .textColor([UIColor whiteColor]);
                        })
                        .viewData(^id { return ImageData(kTVUPLDataImage)
                                .systemIcon(@"person.crop.circle")
                                .tintColor([UIColor grayColor])
                                .size(CGSizeMake(40, 40));
                        });
                    }),
                RowUse(kTVUPLDefaultRow)
                    .key(@"Subscription")
                    .showIndicator(YES)
                    .height(40)
                    .prefetch(^(TVUPLRow *row) { row
                        .viewData(^id { return LabelData(kTVUPLDataTitle)
                                .text(@"Subscription")
                                .font([UIFont systemFontOfSize:14])
                                .textColor([UIColor whiteColor]);
                        })
                        .viewData(^id { return LabelData(kTVUPLDataValue)
                                .text(@"Base")
                                .font([UIFont systemFontOfSize:12])
                                .textAlignment(NSTextAlignmentRight)
                                .textColor([UIColor lightGrayColor]);
                        });
                    }),
                RowUse(kTVUPLDefaultRow)
                    .key(@"ResetPID")
                    .showIndicator(YES)
                    .height(0)
                    .prefetch(^(TVUPLRow *row) { row
                        .viewData(^id { return LabelData(kTVUPLDataTitle)
                                .text(@"Reset PID")
                                .font([UIFont systemFontOfSize:14])
                                .textColor([UIColor whiteColor]);
                        })
                        .viewData(^id { return LabelData(kTVUPLDataValue)
                                .text(self->_pidString)
                                .font([UIFont systemFontOfSize:12])
                                .textAlignment(NSTextAlignmentRight)
                                .textColor([UIColor lightTextColor])
                                .custom(kTVUPLDataScale, @(0.6));
                        });
                    }),
            ]);
        });
}
#pragma mark - Video
- (TVUPLSection *)videoSection {
    return SectionUse
        .key(@"VideoSection")
        .prefetch(^(TVUPLSection *section) { section
            .rows(@[
                RowUse(kTVUPLDefaultRow)
                    .type(TVUPLRowTypeHeader)
                    .height(30)
                    .viewData(^id { return LabelData(kTVUPLDataTitle)
                            .text(@"Video")
                            .font([UIFont systemFontOfSize:13])
                            .textColor([UIColor grayColor]);
                    })
                    .viewData(^id { return ImageData(kTVUPLDataImage)
                            .icon(@"tvu_setting_camera")
                            .size(CGSizeMake(16, 16));
                    }),
                RowUse(kTVUPLDefaultRow)
                    .key(@"Resolution")
                    .showIndicator(YES)
                    .prefetch(^(TVUPLRow *row) { row
                        .height(44)
                        .viewData(^id { return LabelData(kTVUPLDataTitle)
                                .text(@"Resolution")
                                .font([UIFont systemFontOfSize:14])
                                .textColor(UIColor.whiteColor);
                        })
                        .viewData(^id { return LabelData(kTVUPLDataValue)
                                .text(@"1920x1080")
                                .font([UIFont systemFontOfSize:12])
                                .textAlignment(NSTextAlignmentRight)
                                .textColor(UIColor.lightTextColor);
                        });
                    })
                    .tap(^(TVUPLRow *row, id value) {
                        NSLog(@"1 click");
                    }),
                RowUse(kTVUPLDefaultRow)
                    .key(@"Frame")
                    .showIndicator(YES)
                    .prefetch(^(TVUPLRow *row) { row
                        .height(44)
                        .viewData(^id { return LabelData(kTVUPLDataTitle)
                                .text(@"Frame Rate")
                                .font([UIFont systemFontOfSize:14])
                                .textColor(UIColor.whiteColor);
                        })
                        .viewData(^id { return LabelData(kTVUPLDataValue)
                                .text(@"60p")
                                .font([UIFont systemFontOfSize:12])
                                .textAlignment(NSTextAlignmentRight)
                                .textColor(UIColor.lightTextColor);
                        });
                    })
                    .tap(^(TVUPLRow *row, id value) {
                        NSLog(@"1 click");
                    })
            ]);
        });
}
#pragma mark - Audio
- (TVUPLSection *)audioSection {
    return SectionUse
        .key(@"VideoSection")
        .prefetch(^(TVUPLSection *section) { section
            .rows(@[
                RowUse(kTVUPLDefaultRow)
                    .type(TVUPLRowTypeHeader)
                    .height(30)
                    .viewData(^id { return LabelData(kTVUPLDataTitle)
                            .text(@"Audio")
                            .font([UIFont systemFontOfSize:13])
                            .textColor([UIColor grayColor]);
                    })
                    .viewData(^id { return ImageData(kTVUPLDataImage)
                            .icon(@"tvu_cover_mic")
                            .size(CGSizeMake(16, 16));
                    }),
                RowUse(kTVUPLDefaultRow)
                    .key(@"ShareScreen")
                    .showIndicator(YES)
                    .prefetch(^(TVUPLRow *row) { row
                        .height(44)
                        .viewData(^id { return LabelData(kTVUPLDataTitle)
                                .text(@"Share Screen")
                                .font([UIFont systemFontOfSize:14])
                                .textColor(UIColor.whiteColor);
                        })
                        .viewData(^id { return LabelData(kTVUPLDataValue)
                                .text(@"Mix Mic and Audio from Share screen")
                                .font([UIFont systemFontOfSize:12])
                                .textAlignment(NSTextAlignmentRight)
                                .textColor(UIColor.lightTextColor);
                        });
                    })
                    .tap(^(TVUPLRow *row, id value) {
                        NSLog(@"1 click");
                    })
            ]);
        });
}
#pragma mark - Multistream
- (TVUPLSection *)multistreamSection {
    return SectionUse
        .key(@"Multistream")
        .prefetch(^(TVUPLSection *section) { section
            .rows(@[
                RowUse(kTVUPLDefaultRow)
                    .type(TVUPLRowTypeHeader)
                    .height(30)
                    .viewData(^id { return LabelData(kTVUPLDataTitle)
                            .text(@"Multistream")
                            .font([UIFont systemFontOfSize:13])
                            .textColor([UIColor grayColor]);
                    })
                    .viewData(^id { return ImageData(kTVUPLDataImage)
                            .icon(@"tvu_share_platforms")
                            .size(CGSizeMake(16, 16));
                    }),
                RowUse(kTVUPLDefaultRow)
                    .key(@"StreamInfo")
                    .showIndicator(YES)
                    .prefetch(^(TVUPLRow *row) { row
                        .height(44)
                        .viewData(^id { return LabelData(kTVUPLDataTitle)
                                .text(@"Stream Info")
                                .font([UIFont systemFontOfSize:14])
                                .textColor(UIColor.whiteColor);
                        });
                    })
                    .tap(^(TVUPLRow *row, id value) {
                        NSLog(@"1 click");
                    }),
                RowUse(kTVUPLDefaultRow)
                    .key(@"SocialPlatforms")
                    .showIndicator(YES)
                    .prefetch(^(TVUPLRow *row) { row
                        .height(44)
                        .viewData(^id { return LabelData(kTVUPLDataTitle)
                                .text(@"Social Platforms")
                                .font([UIFont systemFontOfSize:14])
                                .textColor(UIColor.whiteColor);
                        });
                    })
                    .tap(^(TVUPLRow *row, id value) {
                        NSLog(@"1 click");
                    }),
            ]);
        });
}
#pragma mark - Multistream
- (TVUPLSection *)backupClipsSection {
    return SectionUse
        .key(@"BackupClips")
        .prefetch(^(TVUPLSection *section) { section
            .rows(@[
                RowUse(kTVUPLDefaultRow)
                    .type(TVUPLRowTypeHeader)
                    .height(30)
                    .viewData(^id { return LabelData(kTVUPLDataTitle)
                            .text(@"Backup Clips")
                            .font([UIFont systemFontOfSize:13])
                            .textColor([UIColor grayColor]);
                    })
                    .viewData(^id { return ImageData(kTVUPLDataImage)
                            .icon(@"tvu_setting_backupclips")
                            .size(CGSizeMake(16, 16));
                    }),
                RowUse(kTVUPLDefaultRow)
                    .key(@"DisasterRecovery")
                    .showIndicator(YES)
                    .prefetch(^(TVUPLRow *row) { row
                        .height(44)
                        .viewData(^id { return LabelData(kTVUPLDataTitle)
                                .text(@"Disaster Recovery")
                                .font([UIFont systemFontOfSize:14])
                                .textColor(UIColor.whiteColor);
                        })
                        .viewData(^id { return LabelData(kTVUPLDataSubtitle)
                                .text(@"Switch backup source when detect black frame")
                                .font([UIFont systemFontOfSize:12])
                                .textColor(UIColor.lightTextColor);
                        });
                    })
                    .tap(^(TVUPLRow *row, id value) {
                        NSLog(@"1 click");
                    }),
                RowUse(kTVUPLDefaultRow)
                    .key(@"ManageBackupClips")
                    .showIndicator(YES)
                    .prefetch(^(TVUPLRow *row) { row
                        .height(44)
                        .viewData(^id { return LabelData(kTVUPLDataTitle)
                                .text(@"Manage backup clips")
                                .font([UIFont systemFontOfSize:14])
                                .textColor(UIColor.whiteColor);
                        });
                    })
                    .tap(^(TVUPLRow *row, id value) {
                        NSLog(@"1 click");
                    }),
            ]);
        });
}
@end
