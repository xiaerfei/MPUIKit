//
//  TVUStaticViewController.m
//  TVUCollectionView
//
//  Created by erfeixia on 2025/12/14.
//

#import "TVUStaticViewController.h"
#import "TVUPLListConst.h"
#import "TVUStaticView.h"
#import "Masonry.h"

#define UIColorFromHex(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface TVUStaticViewController ()
@property (nonatomic, strong) TVUStaticView *staticView;
@end

@implementation TVUStaticViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromHex(0x141414);
    
    self.staticView = [[TVUStaticView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.staticView];
    
    [self.staticView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
    }];
}

#pragma mark - sections
- (TVUPLSection *)loginSection {
    return SectionUse
        .key(@"LoginSection")
        .cornerRadius(8)
        .insets(UIEdgeInsetsMake(0, 20, 0, 20))
        .backgroundColor(UIColorFromHex(0x1F1F1F))
        .prefetch(^(TVUPLSection *section) { section
            .rows(@[
                RowUse(kTVUPLDefaultRow)
                    .key(@"UnloginRow")
                    .showIndicator(YES)
                    .height(60)
                    .prefetch(^(TVUPLRow *row) { row
                        .rowData(^ { RowData
                            .title(@"Login")
                            .titleFont(@16)
                            .systemIcon(@"person.crop.circle")
                            .iconTintColor([UIColor grayColor])
                            .iconSize(CGSizeMake(40, 40));
                        });
                    }),
                RowUse(kTVUPLLoginRow)
                    .key(@"LoginRow")
                    .showIndicator(YES)
                    .height(60)
                    .prefetch(^(TVUPLRow *row) { row
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
    return SectionUse
        .key(@"VideoSection")
        .cornerRadius(8)
        .insets(UIEdgeInsetsMake(10, 20, 0, 20))
        .backgroundColor(UIColorFromHex(0x1F1F1F))
        .prefetch(^(TVUPLSection *section) { section
            .rows(@[
                RowUse(kTVUPLDefaultRow)
                    .type(TVUPLRowTypeHeader)
                    .height(30)
                    .rowData(^ { RowData
                        .title(@"Video")
                        .titleColor([UIColor grayColor])
                        .icon(@"tvu_setting_camera")
                        .iconSize(CGSizeMake(16, 16));
                    }),
                RowUse(kTVUPLRightValueRow)
                    .key(@"Resolution")
                    .showIndicator(YES)
                    .prefetch(^(TVUPLRow *row) { row
                        .rowData(^{ RowData
                            .title(@"Resolution")
                            .layoutPriority(TVUPLRowTitleRequired)
                            .rightValue(@"1280x720");
                        });
                    })
                    .tap(^(TVUPLRow *row, id value) {
                        NSLog(@"1 click");
                    }),
                RowUse(kTVUPLRightValueRow)
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
@end
