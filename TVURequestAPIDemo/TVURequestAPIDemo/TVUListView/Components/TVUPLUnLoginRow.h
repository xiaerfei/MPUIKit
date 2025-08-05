//
//  TVUPLUnLoginRow.h
//  TVURequestAPIDemo
//
//  Created by TVUM4Pro on 2025/7/21.
//

#import <UIKit/UIKit.h>
#import "TVUPLBaseRow.h"

NS_ASSUME_NONNULL_BEGIN

@interface TVUPLUnLoginRow : TVUPLBaseRow <TVUPLRowProtocol>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong, nullable) UIImageView *unLoginImageView;
@end

NS_ASSUME_NONNULL_END
