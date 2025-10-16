//
//  TVUPLReuseManager.m
//  TVUCollectionView
//
//  Created by TVUM4Pro on 2025/10/10.
//

#import "TVUPLReuseManager.h"

@interface TVUPLReuseManager ()
@property (nonatomic, assign) NSInteger identifierTag;
@property (nonatomic, strong) NSMutableArray *reuseRows;
@property (nonatomic, strong) NSMutableArray *reuseSections;
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
    TVUPLRow *row = [self reuseRowFromCache];
    row.identifier(identifier);
    return row;
}

- (TVUPLSection *)sectionReuse {
    return TVUPLSection.new;
}
/// 缓存不在使用的 Row 或者 Section
- (void)cacheReuse:(id)reuse {
    if ([reuse isKindOfClass:TVUPLRow.class]) {
        TVUPLRow *row = reuse;
        [self.reuseRows addObject:row];
    } else if ([reuse isKindOfClass:TVUPLSection.class]) {
        [self.reuseSections addObject:reuse];
    }
}
/// 移除 Row 和 Section
- (void)removeForTag:(NSInteger)tag {
    NSArray *rows = self.reuseRows.copy;
    for (TVUPLRow *row in rows) {
        if (row.tag == tag) {
            [self.reuseRows removeObject:row];
        }
    }
    
    NSArray *sections = self.reuseSections.copy;
    for (TVUPLSection *section in sections) {
        if (section.tag == tag) {
            [self.reuseSections removeObject:section];
        }
    }
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
#pragma mark - Private Methods
- (TVUPLRow *)reuseRowFromCache {
    TVUPLRow *row = nil;
    
    if (self.reuseRows.count == 0) {
        row = TVUPLRow.new;
    } else {
        row = self.reuseRows.lastObject;
        [self.reuseRows removeLastObject];
    }
    
    return row;
}

- (TVUPLSection *)reuseSectionFromCache {
    TVUPLSection *section = nil;
    
    if (self.reuseSections.count == 0) {
        section = TVUPLSection.new;
    } else {
        section = self.reuseSections.lastObject;
        [self.reuseSections removeLastObject];
    }
    
    return section;
}
@end
