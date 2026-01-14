//
//  JMNavigatorView.m
//  JMUIKit
//
//  Created by ZhengXianda on 2022/9/19.
//

#import "JMNavigatorView.h"

#import "JMGeneralVariable.h"

#import "UIWindow+JMExtension.h"
#import "UIView+JMLayout.h"

@implementation JMNavigatorView

#pragma mark - init

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupUI];
        [self setupUIResponse];
        [self bindModel];
    }
    return self;
}

#pragma mark - live cycle

#pragma mark - action

#pragma mark - setup UI

- (void)setupUI {
    self.widthJM = kScreenWidth;
    self.heightJM = kSafeAreaTopHeight + kFunctionBarHeight;
    
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.backButton];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.rightButton];
    
    [self.contentView jm_layout:^(UIView * _Nonnull make) {
        make.widthJM = self.widthJM;
        make.heightJM = kFunctionBarHeight;
        make.bottomJM = self.bottomJM;
        make.centerXJM = self.centerXJM;
    }];
    [self.backButton jm_layout:^(UIView * _Nonnull make) {
        make.widthJM = self.contentView.widthJM * 0.25;
        make.heightJM = self.contentView.heightJM;
        make.topJM = 0;
        make.leftJM = 0;
    }];
    [self.titleLabel jm_layout:^(UIView * _Nonnull make) {
        make.widthJM = self.contentView.widthJM * 0.5;
        make.heightJM = self.contentView.heightJM;
        make.topJM = 0;
        make.centerXJM = self.centerXJM;
    }];
    [self.rightButton jm_layout:^(UIView * _Nonnull make) {
        make.widthJM = self.contentView.widthJM * 0.25;
        make.heightJM = self.contentView.heightJM;
        make.topJM = 0;
        make.rightJM = self.contentView.rightJM;
    }];
}

#pragma mark - setup UI response

- (void)setupUIResponse {
    
}

#pragma mark - bind model

- (void)bindModel {
    
}

#pragma mark - protocol

#pragma mark - setter

#pragma mark - getter

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _backButton;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    return _rightButton;
}

@end
