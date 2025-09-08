//
//  PLListViewController.m
//  TVUList
//
//  Created by erfeixia on 2025/8/5.
//

#import "PLListViewController.h"
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

#define TVUColorWithRHedix(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface PLListViewController ()
@property (nonatomic, strong) TVUPLListView *listView;
@end

@implementation PLListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = TVUColorWithRHedix(0x141414);
    [self configureList];
}
- (IBAction)refreshAction:(id)sender {
    [self.listView reload];
}

- (void)configureList {
    self.listView = [[TVUPLListView alloc] init];
    [self.view addSubview:self.listView];
    
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.edges.equalTo(self.view.mas_safeAreaLayoutGuide);
        } else {
            make.edges.equalTo(self.view);
        }
    }];
    
    @weakify(self);
    [self.listView setFetchSectionsBlock:^NSArray<TVUPLSection *> * _Nonnull{
        @strongify(self);
        return @[
            [self loginSection],
            [self videoSection],
            [self audioHeaderSection],
            [self audioSection],
            [self encodingProfileHeaderSection],
            [self encodingProfileSection],
            [self connectedPlatformsHeaderSection],
            [self connectedPlatformsSection],
            [self backupClipsHeaderSection],
            [self backupClipsSection],
        ];
    }];
    [self.listView reload];
}

#pragma mark - Configure List Sections
#pragma mark Login Section
- (TVUPLSection *)loginSection {
    TVUPLSection *section =
    [[TVUPLSection alloc] initWithKey:@"Login"];
    section.insets = UIEdgeInsetsMake(20, 15, 5, 15);
    section.backgroundColor = TVUColorWithRHedix(0x1F1F1F);
    section.cornerRadius = 8;
    
    @weakify(self);
    [section setFetchSectionParameterBlock:^(TVUPLSection * _Nonnull section) {
        @strongify(self);
        [section addRow:[self loginRow]];
        [section addRow:[self unloginRow]];
    }];
    return section;
}

- (TVUPLRow *)loginRow {
    TVUPLRow *row =
    [[TVUPLRow alloc] initWithType:TVUPLRowTypeLogin
                               key:@"Login"];
    @weakify(self);
    [row setFetchRowParameterBlock:^(TVUPLRow * _Nonnull row) {
        row.showIndicator = NO;
        row.height = 60;
        row.rowData = @{
            @"name" : @"sharexia",
            @"email" : @"sharexia@tvunetworks.com",
            @"first" : @"s",
        };
    }];
    
    [row setDidSelectedBlock:^(TVUPLRow * _Nonnull row,
                               id  _Nullable value) {
        @strongify(self);

    }];
    return row;
}

- (TVUPLRow *)unloginRow {
    TVUPLRow *row =
    [[TVUPLRow alloc] initWithType:TVUPLRowTypeUnLogin
                               key:@"unLogin"];
    [row setFetchRowParameterBlock:^(TVUPLRow * _Nonnull row) {
        row.showIndicator = YES;
        row.height = 60;
        row.rowData = @{
            kTVUPLRowTitle : @"登录",
        };
    }];
    
    [row setDidSelectedBlock:^(TVUPLRow * _Nonnull row, id  _Nullable value) {
            
    }];
    return row;
}

#pragma mark Video Section
- (TVUPLSection *)videoHeaderSection {
    NSDictionary *info =  @{
        kTVUPLRowImage : @"tvu_setting_camera",
        kTVUPLRowTitle : @"Video",
    };
    return [self createHeaderSectionWithKey:@"AudioHeader" data:info];

}

- (TVUPLSection *)videoSection {
    TVUPLSection *section =
    [[TVUPLSection alloc] initWithKey:@"Video"];
    section.insets = UIEdgeInsetsMake(0, 15, 5, 15);
    section.backgroundColor = TVUColorWithRHedix(0x1F1F1F);
    section.cornerRadius = 8;
    
    @weakify(self);
    [section setFetchSectionParameterBlock:^(TVUPLSection * _Nonnull section) {
        @strongify(self);
        [section addHeader:[self videoHeaderRow]];
        [section addRow:[self resolutionRow]];
        [section addRow:[self frameRow]];
    }];
    return section;
}

- (TVUPLRow *)videoHeaderRow {
    TVUPLRow *row =
    [[TVUPLRow alloc] initWithType:TVUPLRowTypeDefault
                               key:@"VideoHeader"];
    [row setFetchRowParameterBlock:^(TVUPLRow * _Nonnull row) {
        row.height = 40;
        row.rowData = @{
            kTVUPLRowTitle : @"Video",
        };
    }];
    return row;
}

- (TVUPLRow *)resolutionRow {
    TVUPLRow *row =
    [[TVUPLRow alloc] initWithType:TVUPLRowTypeDefault
                               key:@"Resolution"];
    [row setFetchRowParameterBlock:^(TVUPLRow * _Nonnull row) {
        row.showIndicator = YES;
        row.height = 48;
        row.rowData = @{
            kTVUPLRowTitle : @"Resolution",
            kTVUPLRowValue : @"1280x720",
        };
    }];
    return row;
}

- (TVUPLRow *)frameRow {
    TVUPLRow *row =
    [[TVUPLRow alloc] initWithType:TVUPLRowTypeDefault
                               key:@"Frame"];
    [row setFetchRowParameterBlock:^(TVUPLRow * _Nonnull row) {
        row.showIndicator = YES;
        row.height = 48;
        row.rowData = @{
            kTVUPLRowTitle : @"Frame",
            kTVUPLRowValue : @"30p",
        };
    }];
    return row;
}

#pragma mark Audio Section
- (TVUPLSection *)audioHeaderSection {
    NSDictionary *info =  @{
        kTVUPLRowImage : @"tvu_cover_mic",
        kTVUPLRowTitle : @"Audio",
    };
    return [self createHeaderSectionWithKey:@"AudioHeader" data:info];
}

- (TVUPLSection *)audioSection {
    TVUPLSection *section =
    [[TVUPLSection alloc] initWithKey:@"Audio"];
    section.insets = UIEdgeInsetsMake(0, 15, 5, 15);
    section.backgroundColor = TVUColorWithRHedix(0x1F1F1F);
    section.cornerRadius = 8;
    
    @weakify(self);
    [section setFetchSectionParameterBlock:^(TVUPLSection * _Nonnull section) {
        @strongify(self);
        [section addRow:[self screenshareRow]];
    }];
    return section;
}

- (TVUPLRow *)screenshareRow {
    TVUPLRow *row =
    [[TVUPLRow alloc] initWithType:TVUPLRowTypeDefault
                               key:@"Screenshare"];
    [row setFetchRowParameterBlock:^(TVUPLRow * _Nonnull row) {
        row.showIndicator = YES;
        row.height = 48;
        row.rowData = @{
            kTVUPLRowTitle : @"Screenshare",
            kTVUPLRowValue : @"Mix",
        };
    }];
    return row;
}
#pragma mark EncodingProfile Section
- (TVUPLSection *)encodingProfileHeaderSection {
    NSDictionary *info =  @{
        kTVUPLRowTitle : @"Encoding Profile",
        kTVUPLRowValue : @"tvu_setting_add",
        kTVUPLRowImage : @"tvu_setting_encodingprofile",
        kTVUPLRowType  : @(TVUPLRowTypeButton)
    };
    return [self createHeaderSectionWithKey:@"EncodingProfileHeader"
                                       data:info];
}

- (TVUPLSection *)encodingProfileSection {
    TVUPLSection *section =
    [[TVUPLSection alloc] initWithKey:@"EncodingProfile"];
    section.insets = UIEdgeInsetsMake(0, 15, 5, 15);
    section.backgroundColor = TVUColorWithRHedix(0x1F1F1F);
    section.cornerRadius = 8;
    NSArray *titles = @[@"encoder file 01", @"encoder file 02", @"encoder file 03"];
    @weakify(self);
    [section setFetchSectionParameterBlock:^(TVUPLSection * _Nonnull section) {
        @strongify(self);
        for (NSString *title in titles) {
            [section addRow:[self encodingProfileRowWithTitle:title]];
        }
    }];
    return section;
}

- (TVUPLRow *)encodingProfileRowWithTitle:(NSString *)title {
    TVUPLRow *row =
    [[TVUPLRow alloc] initWithType:TVUPLRowTypeDefault
                               key:title];
    [row setFetchRowParameterBlock:^(TVUPLRow * _Nonnull row) {
        row.showIndicator = YES;
        row.height = 48;
        row.rowData = @{
            kTVUPLRowTitle : title,
        };
    }];
    return row;
}
#pragma mark Connected Platforms Section
- (TVUPLSection *)connectedPlatformsHeaderSection {
    NSDictionary *info =  @{
        kTVUPLRowTitle : @"Connected Platforms",
        kTVUPLRowValue : @"tvu_setting_add",
        kTVUPLRowImage : @"tvu_share_platforms",
        kTVUPLRowType  : @(TVUPLRowTypeButton)
    };
    return [self createHeaderSectionWithKey:@"ConnectedPlatformsHeader"
                                       data:info];
}

- (TVUPLSection *)connectedPlatformsSection {
    TVUPLSection *section =
    [[TVUPLSection alloc] initWithKey:@"ConnectedPlatforms"];
    section.insets = UIEdgeInsetsMake(0, 15, 5, 15);
    section.backgroundColor = TVUColorWithRHedix(0x1F1F1F);
    section.cornerRadius = 8;
    
    @weakify(self);
    [section setFetchSectionParameterBlock:^(TVUPLSection * _Nonnull section) {
        @strongify(self);
        [section addRows:[self connectedPlatformsRows]];
    }];
    return section;
}

- (NSArray <TVUPLRow *>*)connectedPlatformsRows {
    NSDictionary *YouTubeInfo =  @{
        kTVUPLRowKey   : @"YouTube",
        kTVUPLRowTitle : @"YouTube",
        kTVUPLRowSubtitle : @"ID: Sandra Wangxxx encoder file 01",
        kTVUPLRowImage : @"tvu_cover_youtube",
        kTVUPLRowType  : @(TVUPLRowTypeSwitch)
    };

    NSDictionary *TwitchInfo =  @{
        kTVUPLRowKey   : @"Twitch",
        kTVUPLRowTitle : @"Twitch",
        kTVUPLRowSubtitle : @"ID: Sandra W encoder file 01",
        kTVUPLRowImage : @"tvu_cover_twitch",
        kTVUPLRowType  : @(TVUPLRowTypeSwitch)
    };
    // Tiktok
    NSDictionary *TiktokInfo =  @{
        kTVUPLRowKey   : @"Tiktok",
        kTVUPLRowTitle : @"Tiktok",
        kTVUPLRowValue : @"go to connect",
        kTVUPLRowImage : @"tvu_cover_tiktok",
        kTVUPLRowType  : @(TVUPLRowTypeDefault),
        kTVUPLRowShowIndicator : @(YES),
        kTVUPLRowIndicatorImage : @"tvu_thin_arrow_right",
    };
    // Tiktok
    NSDictionary *RTMPInfo =  @{
        kTVUPLRowKey   : @"RTMP",
        kTVUPLRowTitle : @"RTMP",
        kTVUPLRowValue : @"go to connect",
        kTVUPLRowImage : @"tvu_cover_rtmp",
        kTVUPLRowType  : @(TVUPLRowTypeDefault),
        kTVUPLRowShowIndicator : @(YES),
        kTVUPLRowIndicatorImage : @"tvu_thin_arrow_right",
    };

    return @[[self createRowWithInfo:YouTubeInfo],
             [self createRowWithInfo:TwitchInfo],
             [self createRowWithInfo:TiktokInfo],
             [self createRowWithInfo:RTMPInfo],
    ];
}
#pragma mark Backup Clips Section
- (TVUPLSection *)backupClipsHeaderSection {
    NSDictionary *info =  @{
        kTVUPLRowTitle : @"Backup Clips",
        kTVUPLRowImage : @"tvu_setting_backupclips",
        kTVUPLRowType  : @(TVUPLRowTypeDefault)
    };
    return [self createHeaderSectionWithKey:@"BackupClipsHeader"
                                       data:info];
}

- (TVUPLSection *)backupClipsSection {
    TVUPLSection *section =
    [[TVUPLSection alloc] initWithKey:@"BackupClips"];
    section.insets = UIEdgeInsetsMake(0, 15, 20, 15);
    section.backgroundColor = TVUColorWithRHedix(0x1F1F1F);
    section.cornerRadius = 8;
    
    @weakify(self);
    [section setFetchSectionParameterBlock:^(TVUPLSection * _Nonnull section) {
        @strongify(self);
        [section addRows:[self backupClipsRows]];
    }];
    return section;
}

- (NSArray <TVUPLRow *> *)backupClipsRows {
    /// Disaster Recovery
    NSDictionary *DisasterRecoveryInfo = @{
        kTVUPLRowKey   : @"DisasterRecovery",
        kTVUPLRowTitle : @"Disaster Recovery",
        kTVUPLRowSubtitle : @"Switch backup source when detect black frame",
        kTVUPLRowType  : @(TVUPLRowTypeSwitch)
    };
    NSDictionary *ManageBackupClipsInfo = @{
        kTVUPLRowKey   : @"ManageBackupClips",
        kTVUPLRowTitle : @"Manage backup clips",
        kTVUPLRowType  : @(TVUPLRowTypeDefault),
        kTVUPLRowShowIndicator : @(YES),
    };

    return @[[self createRowWithInfo:DisasterRecoveryInfo],
             [self createRowWithInfo:ManageBackupClipsInfo],
    ];
}
#pragma mark - Private Section Methods
- (TVUPLSection *)createHeaderSectionWithKey:(NSString *)key
                                        data:(NSDictionary *)info {
    
    TVUPLRowType type = [info[kTVUPLRowType] toIntegerValue];
    
    TVUPLSection *section =
    [[TVUPLSection alloc] initWithKey:key];
    section.backgroundColor = [UIColor clearColor];
    section.insets = UIEdgeInsetsMake(5, 15, 0, 15);
    TVUPLRow *(^headerRowBlock)(void) = ^TVUPLRow *() {
        TVUPLRow *row =
        [[TVUPLRow alloc] initWithType:type
                                   key:[NSString stringWithFormat:@"%@Row", key]];
        row.unselected = YES;
        [row setFetchRowParameterBlock:^(TVUPLRow * _Nonnull row) {
            row.height = 40;
            row.rowData = info;
        }];
        return row;
    };

    [section setFetchSectionParameterBlock:^(TVUPLSection * _Nonnull section) {
        [section addRow:headerRowBlock()];
    }];
    return section;
}

- (TVUPLRow *)createRowWithInfo:(NSDictionary *)info {
    TVUPLRowType type = [info[kTVUPLRowType] toIntegerValue];
    NSString *key = [info[kTVUPLRowKey] toStringValue];
    TVUPLRow *row =
    [[TVUPLRow alloc] initWithType:type
                               key:key];
    BOOL showIndicator = [info[kTVUPLRowShowIndicator] toBoolValue];
    [row setFetchRowParameterBlock:^(TVUPLRow * _Nonnull row) {
        row.showIndicator = [info[kTVUPLRowShowIndicator] toBoolValue];
        row.indicatorImageName = [info[kTVUPLRowIndicatorImage] toStringValue];
        row.height = 48;
        row.rowData = info;
    }];
    return row;
}

@end
