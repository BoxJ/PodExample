//
//  JMModalTopView.m
//  JMUIKit
//
//  Created by Thief Toki on 2020/8/4.
//

#import "JMModalTopView.h"

#import "UIView+JMLayout.h"

@implementation JMModalTopView

- (instancetype)initWithType:(JMModalTopType)type {
    self = [super init];
    if (self) {
        self.type = type;
        
        [self setupUI];
        [self setupUIResponse];
    }
    return self;
}

#pragma mark - setup UI

- (void)setupUI {
    [self addSubview:self.logoImageView];
    [self addSubview:self.goBackButton];
    [self addSubview:self.closeButton];
    
    [self.logoImageView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(92, 30);
        make.leftJM = 12;
        make.topJM = 10;
    }]; 
    
    [self.goBackButton jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(16 + 8*2, 16 + 8*2);
        make.leftJM = 15 - 8;
        make.centerYJM = self.heightJM / 2;
    }]; 
    
    [self.closeButton jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(13 + 7*2, 13 + 7*2);
        make.rightJM = self.widthJM - (15 - 7);
        make.centerYJM = self.heightJM / 2;
    }]; 
    
    self.logoImageView.hidden = !(self.type & JMModalTopType_Logo);
    self.goBackButton.hidden = !(self.type & JMModalTopType_GoBack);
    self.closeButton.hidden = self.isLocked || !(self.type & JMModalTopType_Close);
}

#pragma mark - setup UI response

- (void)setupUIResponse {
    
}

#pragma mark - action

- (void)upadteType:(JMModalTopType)type {
    self.type = type;
    [self setupUI];
}

#pragma mark - protocol

#pragma mark - setter

#pragma mark - getter

- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.image = JMThemeFetchT(JMModalTopView, logoImage);
    }
    return _logoImageView;
}

- (UIButton *)goBackButton {
    if (!_goBackButton) {
        _goBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_goBackButton setImage:JMThemeFetchT(JMModalTopView, backButtonImage) forState:UIControlStateNormal];
    }
    return _goBackButton;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:JMThemeFetchT(JMModalTopView, closeButtonImage) forState:UIControlStateNormal];
    }
    return _closeButton;
}

@end
