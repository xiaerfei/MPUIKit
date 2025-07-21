//
//  ListViewController.m
//  TVURequestAPIDemo
//
//  Created by erfeixia on 2025/7/19.
//

#import "ListViewController.h"
#import "TVUPLListView.h"
#import "Masonry.h"

#define TVUColorWithRHedix(rgbValue) \
    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0  \
                    green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                     blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ListViewController ()
@property (nonatomic, strong) TVUPLListView *listView;
@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TVUColorWithRHedix(0x141414);
    
    self.listView = [[TVUPLListView alloc] init];
    [self.view insertSubview:self.listView atIndex:0];
    
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view.mas_safeAreaLayoutGuide);
    }];
    
    __weak typeof(self) weakSelf = self;
    [self.listView setFetchSectionsBlock:^NSArray<TVUPLSection *> * _Nonnull {
        __strong typeof(weakSelf) self = weakSelf;
        return @[
            [self sectionWithStart:0 + 0],
            [self sectionWithStart:0 + 3],
            [self sectionWithStart:0 + 6],
            [self sectionWithStart:0 + 9],
            [self sectionWithStart:0 + 12],
            [self sectionWithStart:0 + 15],
            [self sectionWithStart:0 + 18],
            [self sectionWithStart:0 + 21],
        ];
    }];
    
    [self.listView reload];
}

- (TVUPLSection *)sectionWithStart:(NSInteger)start {
    TVUPLRow *row0 = [self createRowWithString:[NSString stringWithFormat:@"row%ld", start]];
    TVUPLRow *row1 = [self createRowWithString:[NSString stringWithFormat:@"row%ld", start + 1]];
    TVUPLRow *row2 = [self createRowWithString:[NSString stringWithFormat:@"row%ld", start + 2]];

    TVUPLSection *section0 = [[TVUPLSection alloc] init];
    [section0 addRow:row0];
    [section0 addRow:row1];
    [section0 addRow:row2];
    section0.cornerRadius = 6;
    section0.backgroundColor = TVUColorWithRHedix(0x1C1C1E);
    section0.insets = UIEdgeInsetsMake(5, 10, 5, 10);
    return section0;
}

static int cnt = 1;
static NSString *titleString = @"row7";
- (TVUPLRow *)createRowWithString:(NSString *)string {
    TVUPLRowType type = TVUPLRowTypeDefault;
    if ([string isEqualToString:@"row7"]) {
        type = TVUPLRowTypeIndicator;
    } else if ([string isEqualToString:@"row5"]) {
        type = TVUPLRowTypeSwitch;
    }
    
    TVUPLRow *row0 = [[TVUPLRow alloc] initWithType:type
                                                key:string];
    row0.lineInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    
    row0.lineColor = TVUColorWithRHedix(0x3D3C40);
    [row0 setFetchRowParameterBlock:^(TVUPLRow * _Nonnull row) {
        if ([row.key isEqualToString:@"row7"]) {
            row.rowData = @{ @"text" : @"PID", @"value" : @"256ms"};
            row.height = 44;
            row.hidden = cnt % 3 == 0;
        } else if ([row.key isEqualToString:@"row5"]) {
            row.rowData = @{ @"text" : @"Debug", @"value" : @"YES"};
            row.height = 44;
        } else {
            row.rowData = @{ @"text" : string};
            row.height = 44;
        }
    }];
    return row0;
}

- (IBAction)refreshAction:(id)sender {
    cnt ++;
    titleString = [NSString stringWithFormat:@"row --> %d", cnt];
    [self.listView reloadRowWithKey:@"row7"];
}

#pragma mark - Sections
#pragma mark 登录
- (TVUPLSection *)loginSection {
    TVUPLSection *section = [[TVUPLSection alloc] init];
    
    TVUPLRow *unloginRow = [[TVUPLRow alloc] initWithType:TVUPLRowTypeUnLogin key:@"unlogin"];
    unloginRow.hiddenLine = YES;
    unloginRow.hidden = YES;
    [unloginRow setFetchRowParameterBlock:^(TVUPLRow * _Nonnull row) {
        row.rowData = @{
            @"text" : @"登录",
        };
    }];
    
    
    TVUPLRow *loginRow = [[TVUPLRow alloc] initWithType:TVUPLRowTypeLogin key:@"login"];
    loginRow.hiddenLine = YES;
    loginRow.unselectedStyle = YES;
    [loginRow setFetchRowParameterBlock:^(TVUPLRow * _Nonnull row) {
        row.rowData = @{
            @"name"  : @"sharexia",
            @"email" : @"sharexia@tvunetworks.com",
            @"first" : @"s",
        };
    }];
    
    [section addRow:unloginRow];
    [section addRow:loginRow];
    
    return section;
}
#pragma mark PGM Preview
- (TVUPLSection *)pgmPreview {
    TVUPLSection *section = [[TVUPLSection alloc] init];
    
    
    
    return section;
}
@end
