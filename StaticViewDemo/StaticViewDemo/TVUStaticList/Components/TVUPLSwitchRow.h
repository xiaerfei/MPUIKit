//
//  TVUPLSwitchRow.h
//  StaticViewDemo
//
//  Created by erfeixia on 2026/8/31.
//

#import "TVUPLBaseRow.h"

NS_ASSUME_NONNULL_BEGIN

/// 开关行：左侧沿用 TVUPLDefaultView（title / subtitle），右侧 UISwitch。
/// 初始开合取 row.rswitchOn；用户拨动经 sendEventInfo(@(on)) 派发到 tap block。
/// 行体点击由 RowSwitch 宏的 unselected(YES) 关闭，指示器恒不显示。
@interface TVUPLSwitchRow : TVUPLBaseRow

@end

NS_ASSUME_NONNULL_END
