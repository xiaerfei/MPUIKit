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
        make.edges.equalTo(self.view);
    }];
    
    [self.listView registerForCell:@"CustomCell" bundle:nil useNib:NO];
    [self.listView registerForHeader:@"SectionHeaderView" bundle:nil useNib:NO];
    @weakify(self);
    [self.listView setFetchSectionsBlock:^NSArray<TVUPLSection *> * _Nonnull{
        @strongify(self);
        return @[
            [self loginSection],
        ];
    }];
    [self.listView reload];    
}

- (TVUPLSection *)loginSection {
    return SectionReuse
        .key(@"LoginSection")
        .insets(UIEdgeInsetsZero)
        .cornerRadius(8)
        .backgroundColor(UIColor.lightGrayColor)
        .rows(@[
            RowReuse(@"SectionHeaderView").rowType(TVUPLRowTypeHeader),
            RowReuse(@"CustomCell")
                .key(@"login")
                .tap(^(TVUPLRow *row, id value) {
                    
                }),
            RowReuse(@"CustomCell")
                .key(@"unlogin")
                .hidden(YES)
                .tap(^(TVUPLRow *row, id value) {
                    
                }),
            RowReuse(@"SectionHeaderView").rowType(TVUPLRowTypeFooter),
        ]);
}

@end
