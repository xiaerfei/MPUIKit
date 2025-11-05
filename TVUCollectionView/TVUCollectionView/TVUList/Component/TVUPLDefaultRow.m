//
//  TVUPLDefaultRow.m
//  TVUCollectionView
//
//  Created by erfeixia on 2025/11/5.
//

#import "TVUPLDefaultRow.h"
#import "Masonry.h"

NSString *const kTVUPLRowTitle = @"RowTitle";
NSString *const kTVUPLRowSubtitle = @"RowSubtitle";
NSString *const kTVUPLRowImage = @"RowImage";
NSString *const kTVUPLDefaultRow = @"TVUPLDefaultRow";

@interface TVUPLDefaultRow ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@end

@implementation TVUPLDefaultRow

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self configureUI];
    }
    return self;
}
#pragma mark - Public Methods
- (void)updateWithData:(NSDictionary *)data {
    NSString *title = data[kTVUPLRowTitle];
    NSString *subtitle = data[kTVUPLRowSubtitle];
    NSString *imageName = data[kTVUPLRowImage];
    
    if (imageName == nil) {
        if (subtitle == nil) {
            [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.contentView);
            }];
            self.titleLabel.text = title;
        } else {
            [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.contentView);
                make.bottom.equalTo(self.contentView.mas_centerY);
            }];
            [self.subtitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(self.contentView);
                make.top.equalTo(self.contentView.mas_centerY);
            }];
        }
        self.titleLabel.text = title;
        self.subtitleLabel.text = subtitle;
    }
}
#pragma mark - Private Methods
- (void)configureUI {
    self.titleLabel =
    [self createLabelWithSize:15
                    textColor:UIColor.whiteColor];
    [self.contentView addSubview:self.titleLabel];
    
    self.subtitleLabel =
    [self createLabelWithSize:13
                    textColor:UIColor.lightTextColor];
    [self.contentView addSubview:self.subtitleLabel];
    
    self.iconImageView = [UIImageView new];
    [self.contentView addSubview:self.iconImageView];
}

- (UILabel *)createLabelWithSize:(CGFloat)size
                       textColor:(UIColor *)textColor {
    UILabel *label = UILabel.new;
    label.font = [UIFont systemFontOfSize:size];
    label.textColor = textColor;
    return label;
}


@end
