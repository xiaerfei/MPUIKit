//
//  TVUPLBaseRow.h
//  TVURequestAPIDemo
//
//  Created by erfeixia on 2025/7/19.
//

#import <UIKit/UIKit.h>
#import "TVUPLRowProtocol.h"
#import "NSObject+BaseDataType.h"
#import "Masonry.h"

NS_ASSUME_NONNULL_BEGIN
@class TVUPLRow;
@interface TVUPLBaseRow : UIView
@property (nonatomic,   weak) TVUPLRow *row;
@property (nonatomic, assign) TVUPLRowType type;
@property (nonatomic, assign) BOOL showIndicator;

@property (nonatomic, strong, nullable) UIImageView *indicatorImageView;
@end

NS_ASSUME_NONNULL_END
