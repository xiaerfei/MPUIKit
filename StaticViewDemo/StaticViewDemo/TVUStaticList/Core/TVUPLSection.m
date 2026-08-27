//
//  TVUPLSection.m
//  TVUCollectionView
//
//  Created by erfeixia on 2025/9/13.
//

#import "TVUPLSection.h"
#import "NSObject+BaseDataType.h"
#import "TVUPLRow.h"

NSString *const kTVUPLDataSection = @"DataSection";

@interface TVUPLSection ()
@property (nonatomic, copy) void(^attributesBlock)(TVUPLSection *section);
@property (nonatomic, copy) NSArray <TVUPLRow *>*(^rowsBlock)(void);
@property (nonatomic, copy, readwrite)void(^rprefetch)(TVUPLSection *section);
@property (nonatomic, strong, readwrite) NSMutableDictionary *mrowDataDict;
@end

@implementation TVUPLSection

- (instancetype)init {
    self = [super init];
    if (self) {
        self.rrows = [NSMutableArray array];
        self.mrowDataDict = @{}.mutableCopy;
        
        self.mrowDataDict[kTVUPLDataSection] =
        ViewData(kTVUPLDataSection)
            .backgroundColor([[UIColor lightGrayColor] colorWithAlphaComponent:0.2])
            .cornerRadius(8)
            .insets(UIEdgeInsetsMake(0, 20, 0, 20));
    }
    return self;
}

#pragma mark - Public Methods
- (TVUPLSection *(^)(NSString *key))key {
    return ^(NSString *key) {
        self.rkey = key;
        return self;
    };
}
- (TVUPLSection *(^)(BOOL hidden))hidden {
    return ^(BOOL hidden) {
        self.rhidden = hidden;
        return self;
    };
}

- (TVUPLSection *(^)(NSArray *rows))rows {
    return ^(NSArray *rows) {
        NSMutableArray *onlyRows = @[].mutableCopy;
        for (TVUPLRow *row in rows) {
            if (row.rrowType == TVUPLRowTypeHeader) {
                self.header = row;
            } else if (row.rrowType == TVUPLRowTypeFooter) {
                self.footer = row;
            } else {
                [onlyRows addObject:row];
            }
        }
        self.rrows = onlyRows.copy;
        return self;
    };
}

- (TVUPLSection *(^)(void(^)(TVUPLSection *section)))prefetch {
    return ^(void(^prefetch)(TVUPLSection *section)) {
        self.rprefetch = prefetch;
        return self;
    };
}

- (TVUPLSection *(^)(TVUPLViewData *data))viewData {
    return ^(TVUPLViewData *viewData) {
        if (viewData.mkey.length) {
            self.mrowDataDict[viewData.mkey] = viewData;
        }
        return self;
    };
}

- (id)customForKey:(NSString *)key {
    if ([key isKindOfClass:NSString.class] == NO ||
        key.length == 0) {
        return nil;
    }

    return self.mrowDataDict[key];
}
@end
