//
//  TVUPLListView.h
//  TVURequestAPIDemo
//
//  Created by TVUM4Pro on 2025/6/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, TVUPLListCellType) {
    TVUPLListCellTypeDefault,
};



@class TVUPLListView, TVUPLListSection, TVUPLListItem;
@protocol TVUPLListViewDelegate <NSObject>
- (NSArray <NSString *>*)fetchGroupKeysWithListView:(TVUPLListView *)listView;
- (NSDictionary *)listView:(TVUPLListView *)listView groupKey:(NSString *)key;


@end

@interface TVUPLListItem : NSObject

@end


@interface TVUPLListSection : UIView
@property (nonatomic, assign) CGFloat cornerRadius;
@property (nonatomic, assign) UIEdgeInsets insets;
@property (nonatomic, assign) BOOL separateLine;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic,   copy) NSString *key;
@end


@interface TVUPLListView : UIView
@property (nonatomic, weak) id <TVUPLListViewDelegate>delegate;

- (void)reload;
- (void)reloadWithID:(NSString *)ID;
@end

NS_ASSUME_NONNULL_END
