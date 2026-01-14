//
//  JMToastView.m
//  JMUIKit
//
//  Created by Thief Toki on 2020/8/4.
//

#import "JMToastView.h"

#import "JMGeneralVariable.h"

#import "UIView+JMLayout.h"
#import "UIWindow+JMExtension.h"

@implementation JMToastView

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
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    [self addSubview:self.contentView];
    self.contentView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    [self.contentView addSubview:self.boardView];
}

- (void)setupBoardView {
    [self.boardView addSubview:self.messageLabel];
    
    [self.messageLabel jm_layout:^(UIView * _Nonnull make) {
        [make sizeToFit];
    }];
    
    [self.boardView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(self.messageLabel.widthJM + 20 * 2,
                                           self.messageLabel.heightJM + 13 * 2);
        make.centerXJM = self.contentView.centerXJM;
        make.centerYJM = self.contentView.centerYJM;
    }];
    
    [self.messageLabel jm_layout:^(UIView * _Nonnull make) {
        make.bottomJM = self.boardView.heightJM - 13;
        make.centerXJM = self.boardView.widthJM / 2;
    }];
}

#pragma mark - setup UI response

- (void)setupUIResponse {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangeStatusBarOrientation:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
}

- (void)didChangeStatusBarOrientation:(NSNotification *)notification{
    [self setupUI];
}

#pragma mark - action

- (void)showToast:(NSString *)message {
    if (!self.isShow) {
        self.isShow = YES;
        
        self.messageLabel.text = message;
        [self setupBoardView];
        
        [kMainWindow addSubview:self];
    }
}

- (void)dismissDelay:(NSTimeInterval)delay {
    if (self.isShow) {
        [self performSelector:@selector(dismiss)
                   withObject:nil
                   afterDelay:delay];
    }
}

- (void)dismiss {
    [self removeFromSuperview];
    self.isShow = NO;
}

#pragma mark - protocol

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - setter

#pragma mark - getter

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}

- (UIView *)boardView {
    if (!_boardView) {
        _boardView = [[UIView alloc] init];
        _boardView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        _boardView.layer.cornerRadius = 12;
        _boardView.layer.masksToBounds = YES;
    }
    return _boardView;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.textColor = [UIColor colorWithWhite:1 alpha:1];
        _messageLabel.font = [UIFont systemFontOfSize:16];
    }
    return _messageLabel;
}

@end
