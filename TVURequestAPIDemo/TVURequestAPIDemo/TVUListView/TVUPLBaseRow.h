//
//  TVUPLBaseRow.h
//  TVURequestAPIDemo
//
//  Created by erfeixia on 2025/7/19.
//

#import <UIKit/UIKit.h>
#import "TVUPLRowProtocol.h"
NS_ASSUME_NONNULL_BEGIN
@class TVUPLRow;
@interface TVUPLBaseRow : UIView
@property (nonatomic,   weak) TVUPLRow *row;
@property (nonatomic, assign) TVUPLRowType type;
@end

NS_ASSUME_NONNULL_END
