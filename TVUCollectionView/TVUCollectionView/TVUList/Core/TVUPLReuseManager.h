//
//  TVUPLReuseManager.h
//  TVUCollectionView
//
//  Created by TVUM4Pro on 2025/10/10.
//

#import <Foundation/Foundation.h>
#import "TVUPLSection.h"
#import "TVUPLRow.h"

NS_ASSUME_NONNULL_BEGIN

#define RowReuse(identifier) \
    [[TVUPLReuseManager manager] rowReuseWithIdentifier:identifier]


#define SectionReuse \
    [[TVUPLReuseManager manager] sectionReuse]

@interface TVUPLReuseManager : NSObject

+ (instancetype)manager;

- (TVUPLRow *)rowReuseWithIdentifier:(NSString *)identifier;
- (TVUPLSection *)sectionReuse;

/// 缓存不在使用的 Row 或者 Section
- (void)cacheReuse:(id)reuse;
/// 移除 Row 和 Section
- (void)removeForTag:(NSInteger)tag;
/// 每个 ListView 会绑定一个 tag，用来移除 Row 和 Section 缓存
- (NSInteger)generateTag;
@end

NS_ASSUME_NONNULL_END
