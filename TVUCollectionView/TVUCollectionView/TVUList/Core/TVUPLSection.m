//
//  TVUPLSection.m
//  TVUCollectionView
//
//  Created by erfeixia on 2025/9/13.
//

#import "TVUPLSection.h"
#import "NSObject+BaseDataType.h"

@implementation TVUPLSection
+ (instancetype)fetch:(void(^)(TVUPLSection *section))fetch {
    TVUPLSection *section = [TVUPLSection new];
    section.fetchSectionsBlock = fetch;
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
