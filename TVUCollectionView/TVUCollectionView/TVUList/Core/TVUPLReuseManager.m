//
//  TVUPLReuseManager.m
//  TVUCollectionView
//
//  Created by TVUM4Pro on 2025/10/10.
//

#import "TVUPLReuseManager.h"

@interface TVUPLReuseManager ()
@property (nonatomic, assign) NSInteger identifierTag;
@end

@implementation TVUPLReuseManager
- (instancetype)init {
    self = [super init];
    if (self) {
        self.identifierTag = 0;
    }
    return self;
}

#pragma mark - Public Mehtods
+ (instancetype)manager {
    static TVUPLReuseManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[TVUPLReuseManager alloc] init];
    });
    return manager;
}

- (TVUPLRow *)rowReuseWithIdentifier:(NSString *)identifier {
    TVUPLRow *row = TVUPLRow.new;
    row.identifier(identifier);
    return row;
}

- (TVUPLSection *)sectionReuse {
    return TVUPLSection.new;
}

/// 移除 Row 和 Section
- (void)removeForTag:(NSInteger)tag {
    
}
/// 每个 ListView 会绑定一个 tag，用来移除 Row 和 Section 缓存
- (NSInteger)generateTag {
    @synchronized (self) {
        self.identifierTag ++;
        if (self.identifierTag >= 100000) {
            self.identifierTag = 1;
        }
        return self.identifierTag;
    }
}

@end
