//
//  TVUPLDeviceRow.m
//  StaticViewDemo
//
//  Created by erfeixia on 2026/8/31.
//

#import "TVUPLDeviceRow.h"
#import "Masonry.h"

NSString *const kTVUPLDeviceRow = @"TVUPLDeviceRow";

@interface TVUPLDeviceRow ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *dotView;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UISwitch *switchView;
@end

@implementation TVUPLDeviceRow
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.plContentView addSubview:self.titleLabel];

    self.switchView = [[UISwitch alloc] init];
    [self.switchView addTarget:self
                        action:@selector(switchChanged:)
              forControlEvents:UIControlEventValueChanged];
    [self.plContentView addSubview:self.switchView];

    self.stateLabel = [[UILabel alloc] init];
    self.stateLabel.font = [UIFont systemFontOfSize:12];
    self.stateLabel.textColor = [UIColor lightTextColor];
    [self.plContentView addSubview:self.stateLabel];

    self.dotView = [[UIView alloc] init];
    self.dotView.layer.cornerRadius = 4;
    self.dotView.backgroundColor = [UIColor grayColor];
    [self.plContentView addSubview:self.dotView];

    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.centerY.equalTo(self.plContentView);
    }];
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.switchView.mas_left).offset(-8);
        make.centerY.equalTo(self.plContentView);
    }];
    [self.dotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.stateLabel.mas_left).offset(-6);
        make.centerY.equalTo(self.plContentView);
        make.width.height.equalTo(@8);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(self.plContentView);
        make.right.lessThanOrEqualTo(self.dotView.mas_left).offset(-8);
    }];
}

- (void)switchChanged:(UISwitch *)sender {
    [self sendEventInfo:@(sender.on)];
}

- (void)updateWithData:(id)data {
    TVUPLLabelData *titleData = [self.plrow customForKey:kTVUPLDataTitle];
    [titleData configure:self.titleLabel];

    TVUPLLabelData *stateData = [self.plrow customForKey:kTVUPLDataValue];
    [stateData configure:self.stateLabel];

    TVUPLImageData *dotData = [self.plrow customForKey:kTVUPLDataImage];
    self.dotView.backgroundColor =
    dotData.mtintColor ? dotData.mtintColor : [UIColor grayColor];

    if (self.switchView.on != self.plrow.rswitchOn) {
        [self.switchView setOn:self.plrow.rswitchOn animated:NO];
    }
    self.indicatorImageView.hidden = YES;
}
@end
