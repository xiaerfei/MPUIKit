//
//  TVUPLRowProtocol.h
//  TVURequestAPIDemo
//
//  Created by TVUM4Pro on 2025/7/16.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN
extern NSString *const kTVUPLRowHeight;
extern NSString *const kTVUPLRowData;
extern NSString *const kTVUPLRowType;
extern NSString *const kTVUPLRowKey;

typedef NS_ENUM(NSInteger, TVUPLRowType) {
    TVUPLRowTypeDefault,
    TVUPLRowTypeSwitch,
    TVUPLRowTypeLogin,
    TVUPLRowTypeUnLogin,
    TVUPLRowTypeCenterText,
};

@protocol TVUPLRowProtocol <NSObject>
@property (nonatomic,   copy) void (^didSelectedBlock)(id _Nullable value);
- (void)reloadWithData:(id)data;

@end

NS_ASSUME_NONNULL_END
