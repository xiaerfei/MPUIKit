//
//  TVUPLSwitchRow.m
//  StaticViewDemo
//
//  Created by erfeixia on 2026/8/31.
//

#import "TVUPLSwitchRow.h"
#import "TVUPLDefaultView.h"
#import "Masonry.h"

NSString *const kTVUPLSwitchRow = @"TVUPLSwitchRow";

@interface TVUPLSwitchRow ()
@property (nonatomic, strong) TVUPLDefaultView *defaultView;
@property (nonatomic, strong) UISwitch *switchView;
@end

@implementation TVUPLSwitchRow
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.switchView = [[UISwitch alloc] init];
    [self.switchView addTarget:self
                        action:@selector(switchChanged:)
              forControlEvents:UIControlEventValueChanged];
    [self.plContentView addSubview:self.switchView];

    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.plContentView);
        make.centerY.equalTo(self.plContentView);
    }];

    self.defaultView = [[TVUPLDefaultView alloc] initWithFrame:CGRectZero];
    [self.plContentView addSubview:self.defaultView];

    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.plContentView);
        make.right.equalTo(self.switchView.mas_left).offset(-10);
    }];
}

- (void)switchChanged:(UISwitch *)sender {
    [self sendEventInfo:@(sender.on)];
}

- (void)updateWithData:(id)data {
    [self.defaultView updateWithRowData:self.plrow];
    ///< 只在不一致时赋值，避免 State 写回的回声打断拨动动画
    if (self.switchView.on != self.plrow.rswitchOn) {
        [self.switchView setOn:self.plrow.rswitchOn animated:NO];
    }
    ///< 开关行右侧是控件，永远不显示指示器
    self.indicatorImageView.hidden = YES;
}
@end
