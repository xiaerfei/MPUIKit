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
        self.rows = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Public Methods
+ (instancetype)attributes:(void(^)(TVUPLSection *section))attributes
                      rows:(NSArray <TVUPLRow *>*(^)(void))rows {
    TVUPLSection *section = [TVUPLSection new];
    section.attributesBlock = attributes;
    section.rowsBlock = rows;
    return section;
}

- (void)addRow:(TVUPLRow *)row {
    if (row != nil && [self.rows containsObject:row] == NO) {
        [self.rows addObject:row];
    }
}

- (void)addRows:(NSArray <TVUPLRow *>*)rows {
    if (rows.isArray == NO || rows.count == 0) {
        return;
    }
    
    for (id row in rows) {
        [self addRow:row];
    }
}



@end
