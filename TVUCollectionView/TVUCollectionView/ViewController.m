//
//  ViewController.m
//  TVUCollectionView
//
//  Created by erfeixia on 2025/9/13.
//

#import "ViewController.h"
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
    
    [self.listView registerForCell:@"CustomCell" bundle:nil useNib:NO];
    [self.listView registerForCell:kTVUPLDefaultRow bundle:nil useNib:NO];
    
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
                        kTVUPLRowSubtitle : @"rtmp://127.0.0.1/app"
                    })
                    .insets(UIEdgeInsetsMake(0, 20, 0, 0))
                    .lineInsets(UIEdgeInsetsMake(0, 0, 0, 0))
                    .tap(^(TVUPLRow *row, id value) {
                        NSLog(@"1 click");
                    }),
                RowReuse(kTVUPLDefaultRow)
                    .key(@"unlogin")
                    .hidden(NO)
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
                    .height(20).tap(^(TVUPLRow *row, id value) {
                        NSLog(@"first footer click");
                    }),
            ]);
        });
}

- (TVUPLSection *)testSection {
    return SectionReuse
        .key(@"LoginSection")
        .prefetch(^(TVUPLSection *section) { section
            .insets(UIEdgeInsetsMake(0, 20, 0, 20))
            .cornerRadius(8)
            .backgroundColor(UIColorFromHex(0x1F1F1F))
            .rows(@[
                RowReuse(@"CustomCell")
                    .type(TVUPLRowTypeHeader)
                    .rowData(@"Header")
                    .height(20)
                    .insets(UIEdgeInsetsMake(0, 0, 0, 0))
                    .tap(^(TVUPLRow *row, id value) {
                        NSLog(@"2-Header click");
                    }),
                RowReuse(@"CustomCell")
                    .key(@"login")
                    .rowData(@"第 1 行")
                    .tap(^(TVUPLRow *row, id value) {
                        NSLog(@"2-1 click");
                    }),
                RowReuse(@"CustomCell")
                    .key(@"unlogin")
                    .hidden(NO)
                    .rowData(@"第 2 行")
                    .tap(^(TVUPLRow *row, id value) {
                        NSLog(@"2-2 click");
                    }),
                RowReuse(@"CustomCell")
                    .key(@"unlogin")
                    .hidden(NO)
                    .rowData(@"第 3 行")
                    .tap(^(TVUPLRow *row, id value) {
                        NSLog(@"2-3 click");
                    }),
                RowReuse(@"CustomCell")
                    .type(TVUPLRowTypeFooter)
                    .rowData(@"Footer")
                    .tap(^(TVUPLRow *row, id value) {
                        NSLog(@"2-Footer click");
                    }),
            ]);
        });
}

@end
