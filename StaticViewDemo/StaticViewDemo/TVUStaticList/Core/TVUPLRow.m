//
//  TVUPLRow.m
//  TVUCollectionView
//
//  Created by erfeixia on 2025/9/13.
//

#import "TVUPLRow.h"

NSString *const kTVUPLDataTitle     = @"DataTitle";
NSString *const kTVUPLDataSubtitle  = @"DataSubtitle";
NSString *const kTVUPLDataValue     = @"DataValue";
NSString *const kTVUPLDataScale     = @"DataScale";
NSString *const kTVUPLDataImage     = @"DataImage";
NSString *const kTVUPLDataKey0      = @"DataKey0";
NSString *const kTVUPLDataKey1      = @"DataKey1";
NSString *const kTVUPLDataKey2      = @"DataKey2";
NSString *const kTVUPLDataKey3      = @"DataKey3";
NSString *const kTVUPLDataKey4      = @"DataKey4";
NSString *const kTVUPLDataKey5      = @"DataKey5";
NSString *const kTVUPLDataKey6      = @"DataKey6";
NSString *const kTVUPLDataKey7      = @"DataKey7";
NSString *const kTVUPLDataKey8      = @"DataKey8";
NSString *const kTVUPLDataKey9      = @"DataKey9";

NSString *const kTVUPLDataLine      = @"DataLine";


#define DotMethod(TYPE, NAME, PRONAME) \
- (TVUPLRow *(^)(TYPE NAME))NAME { \
    return ^(TYPE NAME) { \
        self.PRONAME = NAME; \
        return self; \
    }; \
}


@interface TVUPLRow ()
@property (nonatomic,   copy, readwrite) NSString *mkey;
@property (nonatomic,   copy, readwrite) NSString *midentifier;
@property (nonatomic, assign, readwrite) BOOL mhidden;
@property (nonatomic, assign, readwrite) BOOL mshowIndicator;
@property (nonatomic,   copy, readwrite) NSString *rIndicatorImageName;
@property (nonatomic, strong, readwrite) UIColor *rIndicatorColor;
@property (nonatomic, assign, readwrite) BOOL rUnselected;
@property (nonatomic, assign, readwrite) BOOL rUnselectedStyle;
@property (nonatomic, assign, readwrite) BOOL rShowLeftImage;
@property (nonatomic, assign, readwrite) CGFloat rHeight;

@property (nonatomic, strong, readwrite) NSMutableDictionary *mrowDataDict;

@property (nonatomic,   copy, readwrite) void (^rDidSelectedBlock)(TVUPLRow *row, id value);
@property (nonatomic,   copy, readwrite) void (^rFetchRowParameterBlock)(TVUPLRow *row);

@property (nonatomic, assign, readwrite) TVUPLRowType rrowType;
@property (nonatomic,   copy, readwrite) void(^rprefetch)(TVUPLRow *row);
@end

@implementation TVUPLRow
#pragma mark - Chainable Setters
DotMethod(NSString *, key, mkey)
DotMethod(NSString *, identifier, midentifier)

- (TVUPLRow *(^)(BOOL hidden))hidden {
    return ^(BOOL hidden) {
        self.mhidden = hidden;
        return self;
    };
}

- (TVUPLRow *(^)(BOOL showIndicator))showIndicator {
    return ^(BOOL showIndicator) {
        self.mshowIndicator = showIndicator;
        return self;
    };
}

- (TVUPLRow *(^)(BOOL unselected))unselected {
    return ^(BOOL unselected) {
        self.rUnselected = unselected;
        return self;
    };
}

- (TVUPLRow *(^)(BOOL unselectedStyle))unselectedStyle {
    return ^(BOOL unselectedStyle) {
        self.rUnselectedStyle = unselectedStyle;
        return self;
    };
}

- (TVUPLRow *(^)(CGFloat height))height {
    return ^(CGFloat height) {
        self.rHeight = height;
        return self;
    };
}

- (TVUPLRow *(^)(void (^)(TVUPLRow *, id)))tap {
    return ^(void (^block)(TVUPLRow *row, id value)) {
        self.rDidSelectedBlock = block;
        return self;
    };
}

- (TVUPLRow *(^)(void (^)(TVUPLRow *)))fetchRowParameterBlock {
    return ^(void (^block)(TVUPLRow *row)) {
        self.rFetchRowParameterBlock = block;
        return self;
    };
}

- (TVUPLRow *(^)(TVUPLRowType rowType))type {
    return ^(TVUPLRowType rowType) {
        self.rrowType = rowType;
        return self;
    };
}

- (TVUPLRow *(^)(void(^)(TVUPLRow *row)))prefetch {
    return ^(void(^prefetch)(TVUPLRow *row)) {
        self.rprefetch = prefetch;
        return self;
    };
}

- (TVUPLRow *(^)(id (^)(void)))viewData {
    return ^(id (^block)(void)) {
        TVUPLViewData *viewData = block ? block() : nil;
        if ([viewData isKindOfClass:TVUPLViewData.class]) {
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
#pragma mark - Class Methods
- (instancetype)initWithIdentifier:(NSString *)identifier {
    self = [super init];
    if (self) {
        self.midentifier = identifier;
        [self configure];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)configure {
    self.rHeight = 50;
    self.mrowDataDict = @{}.mutableCopy;
    self.mrowDataDict[kTVUPLDataRow] =
    ViewData(kTVUPLDataRow)
    .frame(CGRectMake(0, 0, 0, 50))
    .insets(UIEdgeInsetsMake(0, 20, 0, 20));
}


@end
