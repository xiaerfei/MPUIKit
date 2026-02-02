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
@end

@implementation ViewController

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
    
    self.staticView
        .prefetch(^(TVUStaticView *list) { list
            .sections(@[
                [self loginSection],
                [self videoSection],
                [self loginSection],
                [self videoSection],
                [self loginSection],
                [self videoSection],
            ]);
        });
    [self.staticView reload];
    
}

#pragma mark - sections
- (TVUPLSection *)loginSection {
    return SectionUse
        .key(@"LoginSection")
        .prefetch(^(TVUPLSection *section) { section
            .viewData(^id { return ViewData(kTVUPLDataSection)
                .backgroundColor([UIColor lightGrayColor])
                .cornerRadius(8);
            })
            .rows(@[
                RowUse(kTVUPLDefaultRow)
                    .key(@"UnloginRow")
                    .showIndicator(YES)
                    .height(50)
                    .prefetch(^(TVUPLRow *row) { row
                        .viewData(^id { return LabelData(kTVUPLDataTitle)
                                .text(@"Sharexia")
                                .font([UIFont systemFontOfSize:16])
                                .textColor([UIColor whiteColor]);
                        })
                        .viewData(^id { return LabelData(kTVUPLDataSubtitle)
                                .text(@"sharexia@tvunetworks.com")
                                .font([UIFont systemFontOfSize:13])
                                .textColor([UIColor lightGrayColor]);
                        })
                        .viewData(^id { return ImageData(kTVUPLDataImage)
                                .systemIcon(@"person.crop.circle")
                                .tintColor([UIColor grayColor])
                                .size(CGSizeMake(40, 40));
                        });
                    }),
                RowUse(kTVUPLDefaultRow)
                    .key(@"UnloginRow")
                    .showIndicator(YES)
                    .height(60)
                    .prefetch(^(TVUPLRow *row) { row
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

            ]);
        });
}

- (TVUPLSection *)videoSection {
    return SectionUse
        .key(@"VideoSection")
        .prefetch(^(TVUPLSection *section) { section
            .rows(@[
                RowUse(kTVUPLDefaultRow)
                    .type(TVUPLRowTypeHeader)
                    .height(40)
                    .viewData(^id { return LabelData(kTVUPLDataTitle)
                            .text(@"Video")
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
                        .height(0)
                        .viewData(^id { return LabelData(kTVUPLDataTitle)
                                .text(@"这是第二条非常长的文本，它将占据多行以证明 Cell 的动态高度功能是生效的。")
                                .font([UIFont systemFontOfSize:15])
                                .textColor(UIColor.whiteColor);
                        });
                    })
                    .tap(^(TVUPLRow *row, id value) {
                        NSLog(@"1 click");
                    }),
                RowUse(kTVUPLDefaultRow)
                    .key(@"Test0")
                    .showIndicator(YES)
                    .prefetch(^(TVUPLRow *row) { row
                        .height(0)
                        .viewData(^id { return LabelData(kTVUPLDataTitle)
                                .text(@"这是第二条非常长的文本，它将占据多行以证明 Cell 的动态高度功能是生效的。这是第二条非常长的文本，它将占据多行以证明 Cell 的动态高度功能是生效的。")
                                .font([UIFont systemFontOfSize:15])
                                .textColor(UIColor.whiteColor);
                        });
                    })
                    .tap(^(TVUPLRow *row, id value) {
                        NSLog(@"1 click");
                    }),
                RowUse(kTVUPLDefaultRow)
                    .key(@"Test")
                    .showIndicator(NO)
                    .height(0)
                    .prefetch(^(TVUPLRow *row) { row
                        .viewData(^id { return LabelData(kTVUPLDataTitle)
                                .text(@"这是 title")
                                .font([UIFont systemFontOfSize:15])
                                .textColor(UIColor.whiteColor)
                                .textAlignment(NSTextAlignmentLeft);
                        })
                        .viewData(^id { return LabelData(kTVUPLDataSubtitle)
                                .text(@"这是第二条非常长的文本，它将占据多行以证明 Cell 的动态高度功能是生效的。这是第二条非常长的文本，它将占据多行以证明 Cell 的动态高度功能是生效的。这是第二条非常长的文本，它将占据多行以证明 Cell 的动态高度功能是生效的。这是第二条非常长的文本，它将占据多行以证明 Cell 的动态高度功能是生效的。")
                                .font([UIFont systemFontOfSize:13])
                                .textColor(UIColor.greenColor)
                                .textAlignment(NSTextAlignmentLeft);
                        })
                        .viewData(^id { return ImageData(kTVUPLDataImage)
                                .tintColor([UIColor lightGrayColor])
                                .systemIcon(@"person.crop.circle")
                                .size(CGSizeMake(20, 20));
                        });
                    })
                    .tap(^(TVUPLRow *row, id value) {
                        NSLog(@"1 click");
                    })
            ]);
        });
}

@end
