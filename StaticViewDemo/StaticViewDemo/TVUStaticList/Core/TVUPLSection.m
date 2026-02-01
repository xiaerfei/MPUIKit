//
//  TVUPLSection.m
//  TVUCollectionView
//
//  Created by erfeixia on 2025/9/13.
//

#import "TVUPLSection.h"
#import "NSObject+BaseDataType.h"
#import "TVUPLRow.h"

@interface TVUPLSection ()
@property (nonatomic, copy) void(^attributesBlock)(TVUPLSection *section);
@property (nonatomic, copy) NSArray <TVUPLRow *>*(^rowsBlock)(void);
@property (nonatomic, copy, readwrite)void(^rprefetch)(TVUPLSection *section);
@end

@implementation TVUPLSection

- (instancetype)init {
    self = [super init];
    if (self) {
        self.rrows = [NSMutableArray array];
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
- (TVUPLSection *(^)(UIEdgeInsets insets))insets {
    return ^(UIEdgeInsets insets) {
        self.rinsets = insets;
        return self;
    };
}

- (TVUPLSection *(^)(CGFloat cornerRadius))cornerRadius {
    return ^(CGFloat cornerRadius) {
        self.rcornerRadius = cornerRadius;
        return self;
    };
}
- (TVUPLSection *(^)(UIColor *backgroundColor))backgroundColor {
    return ^(UIColor *backgroundColor) {
        self.rbackgroundColor = backgroundColor;
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
@end
