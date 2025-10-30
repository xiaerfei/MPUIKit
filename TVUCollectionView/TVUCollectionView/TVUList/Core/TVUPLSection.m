//
//  TVUPLSection.m
//  TVUCollectionView
//
//  Created by erfeixia on 2025/9/13.
//

#import "TVUPLSection.h"
#import "NSObject+BaseDataType.h"

@interface TVUPLSection ()
@property (nonatomic, copy) void(^attributesBlock)(TVUPLSection *section);
@property (nonatomic, copy) NSArray <TVUPLRow *>*(^rowsBlock)(void);
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
        self.rhidden = rhidden;
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
        self.rrows = rows;
        return self;
    };
}
@end
