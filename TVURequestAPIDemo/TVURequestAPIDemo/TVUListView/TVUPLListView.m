//
//  TVUPLListView.m
//  TVURequestAPIDemo
//
//  Created by TVUM4Pro on 2025/6/24.
//

#import "TVUPLListView.h"
#import "NSObject+BaseDataType.h"
#import "Masonry.h"


NSString *const kTVUPLRowHeight = @"RowH";
NSString *const kTVUPLRowData   = @"RowData";
NSString *const kTVUPLRowType   = @"RowType";
NSString *const kTVUPLRowKey    = @"RowKey";

@interface TVUPLRow ()
@property (nonatomic, strong, readwrite) UIView <TVUPLRowProtocol> *bindView;
@end
@implementation TVUPLRow
@end

@interface TVUPLSection ()

@end
@implementation TVUPLSection

@end

@interface TVUPLListView ()
@property (nonatomic, strong) NSMutableArray <TVUPLSection *> *sections;
@end

@implementation TVUPLListView

- (void)reload {
    [self prepareFetchDatas];
    [self layoutSubSections];
}

- (void)reloadRowWithKey:(NSString *)key {
    
}
#pragma mark - Private Methods
#pragma mark prepare data
- (void)prepareFetchDatas {
    if (self.fetchSectionsBlock == nil) return;
    
    NSArray <TVUPLSection *>*sections = self.fetchSectionsBlock();
    if (sections.isArray == NO || sections.count == 0) {
        return;
    }
    
    for (TVUPLSection *section in sections) {
        [self prepareForSection:section];
    }
    
    self.sections = sections.mutableCopy;
}

- (void)prepareForSection:(TVUPLSection *)section {
    if (section.rows.count == 0) return;
    for (TVUPLRow *row in section.rows) {
        [self prepareForRow:row];
    }
}

- (void)prepareForRow:(TVUPLRow *)row {
    if (row.fetchRowParameterBlock == nil) {
        return;
    }
    NSDictionary *info = row.fetchRowParameterBlock(row);
    if (info.isDictionary == NO || info.count == 0) {
        return;
    }
    
    id data = info[kTVUPLRowData];
    UIView <TVUPLRowProtocol> *view = [self viewForRowType:row.type];
    [view reloadWithData:data];
    row.bindView = view;
}

- (UIView <TVUPLRowProtocol> *)viewForRowType:(TVUPLRowType)type {
    Class cls = [self clsForRowType:type];
    if (cls == nil) return nil;

    return (UIView <TVUPLRowProtocol> *)[[cls alloc] init];
}

- (Class)clsForRowType:(TVUPLRowType)type {
    static NSDictionary <NSNumber *, Class>*clsRowMap = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        clsRowMap = @{
            
        };
    });
    return clsRowMap[@(type)];
}
#pragma mark layout sections
- (void)layoutSubSections {
    UIView *topView = self;
    for (TVUPLSection *section in self.sections) {
        [self layoutForSection:section topView:topView];
        topView = section.bindView;
    }
}

- (void)layoutForSection:(TVUPLSection *)section topView:(UIView *)topView {
    UIView *bindView = section.bindView;
    [self addSubview:bindView];
    [bindView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(section.insets.left);
        make.top.mas_equalTo(topView).offset(section.insets.top);
        make.right.mas_equalTo(self).offset(-section.insets.right);
    }];
}
@end
