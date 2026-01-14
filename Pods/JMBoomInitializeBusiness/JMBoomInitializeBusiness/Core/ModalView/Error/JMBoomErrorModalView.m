//
//  JMBoomErrorModalView.m
//  JMBoomInitializeBusiness
//
//  Created by Thief Toki on 2020/8/10.
//

#import "JMBoomErrorModalView.h"

#import <JMRktCommon/JMRktCommon.h>

#import <JMBoomSDKBase/JMBoomSDKBase.h>

@implementation JMBoomErrorModalView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUI];
        [self setupUIResponse];
    }
    return self;
}

#pragma mark - setup UI

- (void)setupUI {
    [super setupUI];
    
    [self.contentView addSubview:self.boardImageView];
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.messageLabel];
    [self.contentView addSubview:self.retryButton];
    
    [self.boardImageView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(320, 259);
        make.centerXJM = self.contentView.centerXJM;
        make.centerYJM = self.contentView.centerYJM;
    }];
    
    [self.imageView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(80, 80);
        make.topJM = self.boardImageView.topJM + 40;
        make.centerXJM = self.boardImageView.centerXJM;
    }];
    
    [self.messageLabel jm_layout:^(UIView * _Nonnull make) {
        [make sizeToFit];
        make.topJM = self.imageView.bottomJM + 7;
        make.centerXJM = self.boardImageView.centerXJM;
    }];
    
    [self.retryButton jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(260, 48);
        make.topJM = self.messageLabel.bottomJM + 36;
        make.centerXJM = self.boardImageView.centerXJM;
    }];
}

#pragma mark - setup UI response

- (void)setupUIResponse {
    [super setupUIResponse];
    
    [self.retryButton addTarget:self
                         action:@selector(retryButtonTapped)
               forControlEvents:UIControlEventTouchUpInside];
}

- (void)retryButtonTapped {
    [self dismissSuccess:@{}];
}

#pragma mark - protocol

#pragma mark - setter

#pragma mark - getter

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [JMBoomSDKResource imageNamed:@"boom_ic_nonetwork"];
    }
    return _imageView;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.text = @"当前网络连接异常，请重试";
        _messageLabel.textColor = [UIColor colorWithWhite:51/255.0 alpha:1];
        _messageLabel.font = [UIFont systemFontOfSize:16];
    }
    return _messageLabel;
}

- (JMCommonButton *)retryButton {
    if (!_retryButton) {
        _retryButton = [JMCommonButton buttonWithType:UIButtonTypeCustom];
        [_retryButton setTitle:@"重试" forState:UIControlStateNormal];
    }
    return _retryButton;
}

@end
