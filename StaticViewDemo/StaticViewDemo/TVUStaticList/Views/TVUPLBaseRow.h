//
//  TVUPLBaseRow.h
//  StaticViewDemo
//
//  Created by erfeixia on 2025/12/14.
//

#import <UIKit/UIKit.h>
#import "TVUPLRow.h"

NS_ASSUME_NONNULL_BEGIN

@interface TVUPLBaseRow : UIView
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic,   weak) TVUPLRow *plrow;
@property (nonatomic, strong, readonly) UIImageView *indicatorImageView;
@property (nonatomic, strong, readonly) UIView *plContentView;

- (void)sendEventInfo:(nullable id)info;

- (void)updateWithData:(id)data;
@end

NS_ASSUME_NONNULL_END
