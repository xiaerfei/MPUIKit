//
//  TVUPLRow.m
//  TVUList
//
//  Created by TVUM4Pro on 2025/8/13.
//

#import "TVUPLRow.h"
#import "NSObject+BaseDataType.h"

@interface TVUPLRow ()
@property (nonatomic, assign, readwrite) TVUPLRowType type;
@property (nonatomic,   copy, readwrite) NSString *key;
@end

@implementation TVUPLRow
- (instancetype)initWithType:(TVUPLRowType)type
                         key:(NSString *)key {
    self = [super init];
    if (self) {
#if DEBUG
        NSAssert([key toStringValue].length != 0, @"key is null");
#endif
        self.type = type;
        self.key  = key;
        self.lineInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        self.lineColor = TVUColorWithRHedix(0x3D3C40);
        self.height = 44;
    }
    return self;
}

- (instancetype)initWithData:(NSDictionary *)data {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)parseData:(NSDictionary *)data {
    TVUPLRowType type = [data[kTVUPLRowType] toIntegerValue];
    NSString *key     = [data[kTVUPLRowKey] toStringValue];
#if DEBUG
        NSAssert([key toStringValue].length != 0, @"key is null");
#endif
    self.key = key;
    self.type = type;
    
    
    
    
}


@end
