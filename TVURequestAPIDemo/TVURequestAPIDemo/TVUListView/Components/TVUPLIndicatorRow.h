//
//  TVUPLIndicatorRow.h
//  TVURequestAPIDemo
//
//  Created by TVUM4Pro on 2025/7/21.
//

#import <UIKit/UIKit.h>
#import "TVUPLBaseRow.h"

NS_ASSUME_NONNULL_BEGIN

@interface TVUPLIndicatorRow : TVUPLBaseRow <TVUPLRowProtocol>
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UIImageView *indicatorImageView;
@end

NS_ASSUME_NONNULL_END
