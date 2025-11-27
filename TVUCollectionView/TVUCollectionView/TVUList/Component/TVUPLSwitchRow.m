//
//  TVUPLSwitchRow.m
//  TVUCollectionView
//
//  Created by erfeixia on 2025/11/15.
//

#import "TVUPLSwitchRow.h"
#import "TVUPLListConst.h"
#import "TVUPLDefaultCellView.h"
#import "Masonry.h"

// Switch相关常量实现
NSString *const kTVUPLRowSwitchOn       = @"RowSwitchOn";
NSString *const kTVUPLRowSwitchEnabled  = @"RowSwitchEnabled";

NSString *const kTVUPLSwitchRow         = @"TVUPLSwitchRow";

// 布局常量（复用原有间距，新增Switch相关间距）
static const CGFloat kTitleSwitchSpacing = 12;  // 标题与Switch间距
static const CGFloat kSwitchRightMargin = 16;   // Switch右边距

@interface TVUPLSwitchRow ()
@property (nonatomic, strong) UISwitch *switchView;      // 右侧开关
@property (nonatomic, strong) TVUPLDefaultCellView *defaultView;
@end


@implementation TVUPLSwitchRow
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    // 右侧Switch
    self.switchView = [[UISwitch alloc] init];
    self.switchView.onTintColor = [UIColor systemBlueColor]; // 默认蓝色
    [self.switchView addTarget:self
                        action:@selector(switchValueChanged:)
              forControlEvents:UIControlEventValueChanged];
    [self.plContentView addSubview:self.switchView];
    
    // Switch约束（右侧固定间距，垂直居中）
    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.plContentView).offset(-kSwitchRightMargin);
        make.centerY.equalTo(self.plContentView);
    }];
    
    self.defaultView = [[TVUPLDefaultCellView alloc] initWithFrame:CGRectZero];
    [self.plContentView addSubview:self.defaultView];
    
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(self.plContentView);
        make.right.equalTo(self.switchView.mas_left);
    }];
}

- (void)updateWithData:(NSDictionary *)data {
    [self.defaultView updateWithData:data];
    
    [self.defaultView sizeToFit];
    
    NSLog(@"sharexia:%@", NSStringFromCGRect(self.defaultView.frame));
    // 更新Switch状态
    if (data[kTVUPLRowSwitchOn] &&
        [data[kTVUPLRowSwitchOn] isKindOfClass:[NSNumber class]]) {
        self.switchView.on = [data[kTVUPLRowSwitchOn] boolValue];
    } else {
        self.switchView.on = NO; // 默认关闭
    }
    
    // 更新Switch可用性
    if (data[kTVUPLRowSwitchEnabled] &&
        [data[kTVUPLRowSwitchEnabled] isKindOfClass:[NSNumber class]]) {
        self.switchView.enabled = [data[kTVUPLRowSwitchEnabled] boolValue];
    } else {
        self.switchView.enabled = YES; // 默认可用
    }
}

#pragma mark - Switch事件
- (void)switchValueChanged:(UISwitch *)sender {
    [self sendEventInfo:@(sender.isOn)];
}
@end
