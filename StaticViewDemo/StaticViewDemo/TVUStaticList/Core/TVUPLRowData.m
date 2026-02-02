//
//  TVUPLRowData.m
//  TVUCollectionView
//
//  Created by erfeixia on 2025/11/16.
//

#import "TVUPLRowData.h"
#import "TVUPLListConst.h"

@interface TVUPLRowData ()
@property (nonatomic, strong) NSMutableDictionary *rowDataDict;
@end

@implementation TVUPLRowData

- (instancetype)init {
    self = [super init];
    if (self) {
        self.rowDataDict = @{}.mutableCopy;
    }
    return self;
}

#pragma mark - Public Methods
- (TVUPLRowData *(^)(NSString *key, id value))custom {
    return ^(NSString *key, id value) {
        if ([key isKindOfClass:NSString.class] == NO ||
            key.length == 0) {
            return self;
        } else {
            self.rowDataDict[key] = value;
            return self;
        }
    };
}
@end
