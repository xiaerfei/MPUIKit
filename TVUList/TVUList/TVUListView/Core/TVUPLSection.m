//
//  TVUPLSection.m
//  TVUList
//
//  Created by erfeixia on 2025/8/8.
//

#import "TVUPLSection.h"
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
@end
