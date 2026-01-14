//
//  JMBoomAgreementItemView.m
//  JMBoomInitializeBusiness
//
//  Created by ZhengXianda on 2021/11/29.
//

#import "JMBoomAgreementItemView.h"

#import <JMUIKit/JMUIKit.h>

#import <JMBoomSDKBase/JMBoomSDKBase.h>

@interface JMBoomAgreementItemView ()

@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *intro;

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *introLabel;

@end

@implementation JMBoomAgreementItemView

- (instancetype)initWithIcon:(NSString *)icon
                       title:(NSString *)title
                       intro:(NSString *)intro {
    self = [super init];
    if (self) {
        self.icon = icon;
        self.title = title;
        self.intro = intro;
    }
    return self;
}

#pragma mark - setup UI

- (void)setupUI {
    [self addSubview:self.iconImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.introLabel];
    
    [self.titleLabel jm_layout:^(UIView * _Nonnull make) {
        [make sizeToFit];
    }];
    [self.introLabel jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(self.widthJM - 36 - 8, 0);
        [make sizeToFit];
    }];
    
    [self.iconImageView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(36, 36);
        make.topJM = 2;
    }];
    
    [self.titleLabel jm_layout:^(UIView * _Nonnull make) {
        make.leftJM = self.iconImageView.rightJM + 8;
        make.topJM = 0;
    }];
    [self.introLabel jm_layout:^(UIView * _Nonnull make) {
        make.leftJM = self.iconImageView.rightJM + 8;
        make.topJM = self.titleLabel.bottomJM + 3;
    }];
}

#pragma mark - setup UI response

- (void)setupUIResponse {
    
}

#pragma mark - protocol

#pragma mark - setter

#pragma mark - getter

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        if (self.icon) {
            _iconImageView.image = [JMBoomSDKResource imageNamed:self.icon];
        }
        _iconImageView.layer.cornerRadius = 2;
        _iconImageView.layer.masksToBounds = YES;
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = self.title;
        _titleLabel.textColor = [UIColor colorWithWhite:17/255.0 alpha:1];
        _titleLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightSemibold];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)introLabel {
    if (!_introLabel) {
        _introLabel = [[UILabel alloc] init];
        _introLabel.text = self.intro;
        _introLabel.textColor = [UIColor colorWithWhite:153/255.0 alpha:1];
        _introLabel.font = [UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
        _introLabel.numberOfLines = 0;
    }
    return _introLabel;
}

@end
