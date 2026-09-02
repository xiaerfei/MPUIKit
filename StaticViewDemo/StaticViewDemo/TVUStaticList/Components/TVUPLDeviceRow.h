//
//  TVUPLDeviceRow.h
//  StaticViewDemo
//
//  Created by erfeixia on 2026/8/31.
//

#import "TVUPLBaseRow.h"

NS_ASSUME_NONNULL_BEGIN

/// 外部设备行（DJI 等）：标题 + 状态圆点 + 状态文字 + 开关。
/// 槽位约定：title = 设备名，value = 状态文字，image 的 tintColor = 圆点颜色。
/// 行体点击（进详情）与开关拨动都经 sendEventInfo 派发：前者 info 为 nil，后者为 @(on)。
@interface TVUPLDeviceRow : TVUPLBaseRow

@end

NS_ASSUME_NONNULL_END
