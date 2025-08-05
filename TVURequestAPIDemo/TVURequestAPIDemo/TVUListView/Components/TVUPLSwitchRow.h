//
//  TVUPLSwitchRow.h
//  TVURequestAPIDemo
//
//  Created by TVUM4Pro on 2025/7/21.
//

#import <UIKit/UIKit.h>
#import "TVUPLBaseRow.h"

NS_ASSUME_NONNULL_BEGIN

@interface TVUPLSwitchRow : TVUPLBaseRow <TVUPLRowProtocol>
@property (nonatomic, strong) UILabel  *titleLabel;
@property (nonatomic, strong) UISwitch *switchView;
@end

NS_ASSUME_NONNULL_END
