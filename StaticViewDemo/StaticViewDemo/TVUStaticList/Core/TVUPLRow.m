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
NSString *const kTVUPLDataRow       = @"DataRow";

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
@property (nonatomic, assign, readwrite) BOOL rhidden;
@property (nonatomic, assign, readwrite) BOOL mshowIndicator;
@property (nonatomic,   copy, readwrite) NSString *rIndicatorImageName;
@property (nonatomic, strong, readwrite) UIColor *rIndicatorColor;
@property (nonatomic, assign, readwrite) BOOL rUnselected;
@property (nonatomic, assign, readwrite) BOOL rUnselectedStyle;
@property (nonatomic, assign, readwrite) BOOL rShowLeftImage;
@property (nonatomic, assign, readwrite) CGFloat rHeight;

@property (nonatomic, strong, readwrite) NSMutableDictionary *mrowDataDict;
@property (nonatomic, strong) NSMutableDictionary <NSString *, TVUPLState *>*rbindings;

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
        self.rhidden = hidden;
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

- (TVUPLRow *(^)(TVUPLViewData *data))viewData {
    return ^(TVUPLViewData *viewData) {
        if (viewData.mkey.length) {
            self.mrowDataDict[viewData.mkey] = viewData;
        }
        return self;
    };
}
#pragma mark - Slots
///< 取槽位对应的 LabelData，没有或类型不符则新建 —— 让槽位方法与 viewData 可以任意顺序组合
- (TVUPLLabelData *)labelDataForKey:(NSString *)key {
    TVUPLLabelData *data = self.mrowDataDict[key];
    if ([data isKindOfClass:TVUPLLabelData.class] == NO) {
        data = LabelData(key);
        self.mrowDataDict[key] = data;
    }
    return data;
}

- (TVUPLRow *(^)(NSString *title))title {
    return ^(NSString *title) {
        [self labelDataForKey:kTVUPLDataTitle].text(title);
        return self;
    };
}

- (TVUPLRow *(^)(NSString *subtitle))subtitle {
    return ^(NSString *subtitle) {
        [self labelDataForKey:kTVUPLDataSubtitle].text(subtitle);
        return self;
    };
}

- (TVUPLRow *(^)(NSString *value))value {
    return ^(NSString *value) {
        [self labelDataForKey:kTVUPLDataValue].text(value);
        return self;
    };
}

- (TVUPLRow *(^)(NSString *icon))icon {
    return ^(NSString *icon) {
        TVUPLImageData *data = self.mrowDataDict[kTVUPLDataImage];
        if ([data isKindOfClass:TVUPLImageData.class] == NO) {
            data = ImageData(kTVUPLDataImage);
            self.mrowDataDict[kTVUPLDataImage] = data;
        }
        data.icon(icon);
        return self;
    };
}
#pragma mark - Bindings
- (TVUPLRow *(^)(TVUPLState<NSString *> *state))bindTitle {
    return ^(TVUPLState<NSString *> *state) {
        self.rbindings[kTVUPLDataTitle] = state;
        return self;
    };
}

- (TVUPLRow *(^)(TVUPLState<NSString *> *state))bindSubtitle {
    return ^(TVUPLState<NSString *> *state) {
        self.rbindings[kTVUPLDataSubtitle] = state;
        return self;
    };
}

- (TVUPLRow *(^)(TVUPLState<NSString *> *state))bindValue {
    return ^(TVUPLState<NSString *> *state) {
        self.rbindings[kTVUPLDataValue] = state;
        return self;
    };
}

///< 只在求值作用域内被调用；这里的 state.value 读取就是订阅登记
- (void)resolveBindings {
    [self.rbindings enumerateKeysAndObjectsUsingBlock:
     ^(NSString *key, TVUPLState *state, BOOL *stop) {
        [self labelDataForKey:key].text(state.value);
    }];
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
    _rstates = [NSHashTable weakObjectsHashTable];
    _rbindings = @{}.mutableCopy;
    self.mrowDataDict = @{}.mutableCopy;
    self.mrowDataDict[kTVUPLDataRow] =
    ViewData(kTVUPLDataRow)
    .frame(CGRectMake(0, 0, 0, 50))
    .insets(UIEdgeInsetsMake(0, 15, 0, 15));
}


@end
