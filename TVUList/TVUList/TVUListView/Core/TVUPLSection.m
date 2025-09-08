//
//  TVUPLSection.m
//  TVUList
//
//  Created by erfeixia on 2025/8/8.
//

#import "TVUPLSection.h"
#import "TVUPLRow.h"
#import "NSObject+BaseDataType.h"
@interface TVUPLSection ()
@end

@implementation TVUPLSection
- (instancetype)initWithKey:(NSString *)key {
    self = [super init];
    if (self) {
#if DEBUG
        NSAssert([key toStringValue].length != 0, @"key is null");
#endif
        self.key = key;
        self.rows = [NSMutableArray array];
    }
    return self;
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

- (void)addHeader:(TVUPLRow *)row {
    if (row == nil) return;
    row.headerOrFooter = YES;
    row.section = self;
    row.index = 0;
    self.header = row;
}

- (void)addFooter:(TVUPLRow *)row {
    if (row == nil) return;
    row.headerOrFooter = YES;
    row.section = self;
    row.index = 1;
    self.footer = row;
}

@end
