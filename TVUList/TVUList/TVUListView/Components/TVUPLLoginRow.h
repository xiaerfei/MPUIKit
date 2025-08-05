//
//  TVUPLLoginRow.h
//  TVURequestAPIDemo
//
//  Created by TVUM4Pro on 2025/7/21.
//

#import <UIKit/UIKit.h>
#import "TVUPLBaseRow.h"

NS_ASSUME_NONNULL_BEGIN

@interface TVUPLLoginRow : TVUPLBaseRow <TVUPLRowProtocol>
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *emailLabel;
@property (nonatomic, strong) UILabel *firstWordLabel;

@end

NS_ASSUME_NONNULL_END
