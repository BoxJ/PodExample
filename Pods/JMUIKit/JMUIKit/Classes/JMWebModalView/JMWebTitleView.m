//
//  JMWebTitleView.m
//  JMUIKit
//
//  Created by Thief Toki on 2020/9/16.
//

#import "JMWebTitleView.h"

#import "JMGeneralVariable.h"

#import "UIView+JMLayout.h"

@implementation JMWebTitleView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupUI];
        [self setupUIResponse];
    }
    return self;
}

#pragma mark - setup UI

- (void)setupUI {
    CGFloat statusHeight = kIsLandscape ? 10 : (kIsSpecialScreen ? 44 : 20);
    CGFloat navigationHeight = 44;
    
    self.frame = CGRectMake(0, 0, kScreenWidth, statusHeight + navigationHeight);
    
    [self addSubview:self.statusView];
    [self addSubview:self.titleView];
    [self.titleView addSubview:self.goBackButton];
    [self.titleView addSubview:self.titleLabel];
    
    [self.statusView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(self.widthJM, statusHeight);
    }];
    
    [self.titleView jm_layout:^(UIView * _Nonnull make) {
        make.topJM = self.statusView.bottomJM;
        make.sizeJM = CGSizeMake(self.widthJM, navigationHeight);
    }];
    
    CGFloat leftOffset = kIsLandscape ? 15 : 0;
    [self.goBackButton jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(9 + 5*2, 16 + 8*2);
        make.leftJM = leftOffset + 15 - 5;
        make.centerYJM = self.titleView.heightJM / 2;
    }];
    
    [self.titleLabel jm_layout:^(UIView * _Nonnull make) {
        [make sizeToFit];
        make.centerXJM = self.titleView.widthJM / 2;
        make.centerYJM = self.titleView.heightJM / 2;
    }];
}

#pragma mark - setup UI response

- (void)setupUIResponse {
    
}

#pragma mark - protocol

#pragma mark - setter

#pragma mark - getter

- (UIView *)statusView {
    if (!_statusView) {
        _statusView = [[UIView alloc] init];
        _statusView.backgroundColor = [UIColor whiteColor];
    }
    return _statusView;
}

- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
        _titleView.backgroundColor = [UIColor whiteColor];
    }
    return _titleView;
}

- (UIButton *)goBackButton {
    if (!_goBackButton) {
        _goBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_goBackButton setImage:JMThemeFetchT(JMWebTitleView, backButtonImage) forState:UIControlStateNormal];
        
    }
    return _goBackButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithWhite:51/255.0 alpha:1];
        _titleLabel.font = [UIFont systemFontOfSize:18];
    }
    return _titleLabel;
}


@end
