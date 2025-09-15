//
//  TVUPLRow.m
//  TVUCollectionView
//
//  Created by erfeixia on 2025/9/13.
//

#import "TVUPLRow.h"

@implementation TVUPLRow

+ (instancetype)fetch:(void(^)(TVUPLRow *row))fetch
             selected:(void(^)(TVUPLRow *row, id value))selected {
    TVUPLRow *row = [TVUPLRow new];
    row.fetchRowParameterBlock = fetch;
    row.didSelectedBlock = selected;
    return row;
}

- (void)parameter:(NSDictionary *)parameter {
    
}
@end
