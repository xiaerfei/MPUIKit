//
//  TVUPLLoginRow.m
//  TVUCollectionView
//
//  Created by erfeixia on 2025/11/16.
//

#import "TVUPLLoginRow.h"
#import "TVUPLDefaultCellView.h"
#import "NSObject+BaseDataType.h"
#import "Masonry.h"

NSString *const kTVUPLRowLoginBigWord = @"RowLoginBigWord";
NSString *const kTVUPLLoginRow        = @"TVUPLLoginRow";

@interface TVUPLLoginRow ()
@property (nonatomic, strong) UILabel *bigWordLabel;
@property (nonatomic, strong) TVUPLDefaultCellView *defaultView;
@end

@implementation TVUPLLoginRow
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
    // 标题
    self.bigWordLabel = [[UILabel alloc] init];
    self.bigWordLabel.numberOfLines = 1;
    // 默认样式
    self.bigWordLabel.font = [UIFont boldSystemFontOfSize:20];
    self.bigWordLabel.textAlignment = NSTextAlignmentCenter;
    self.bigWordLabel.textColor = [UIColor whiteColor];
    self.bigWordLabel.numberOfLines = 0;
    self.bigWordLabel.layer.cornerRadius = 20;
    self.bigWordLabel.layer.masksToBounds = YES;
    self.bigWordLabel.backgroundColor = [UIColor colorWithRed:64.0f/255.0f green:50.0f/255.0f blue:231.0f/255.0f alpha:1];
    [self.plContentView addSubview:self.bigWordLabel];
    
    [self.bigWordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(self.plContentView);
        make.width.equalTo(self.bigWordLabel.mas_height);
        make.height.equalTo(@40);
    }];
    
    self.defaultView = [[TVUPLDefaultCellView alloc] initWithFrame:CGRectZero];
    [self.plContentView addSubview:self.defaultView];
    
    [self.defaultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.plContentView);
        make.left.equalTo(self.bigWordLabel.mas_right).offset(10);
    }];
}

- (void)updateWithData:(NSDictionary *)data {
    [self.defaultView updateWithData:data];
    self.bigWordLabel.text = [data[kTVUPLRowLoginBigWord] toStringValue];
    [self updateLayoutConstraints];
}

- (void)updateLayoutConstraints {
    BOOL showIndicator = self.plrow.rshowIndicator;
    [self.defaultView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.plContentView);
        make.left.equalTo(self.bigWordLabel.mas_right).offset(10);
        if (showIndicator) {
            make.right.equalTo(self.indicatorImageView.mas_left);
        } else {
            make.right.equalTo(self.plContentView);
        }
    }];
}

@end
