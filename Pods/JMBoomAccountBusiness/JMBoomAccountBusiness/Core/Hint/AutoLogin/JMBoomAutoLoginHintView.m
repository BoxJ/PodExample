//
//  JMBoomAutoLoginHintView.m
//  JMBoomSDK
//
//  Created by Thief Toki on 2020/8/8.
//

#import "JMBoomAutoLoginHintView.h"

#import <JMBoomSDKBase/JMBoomSDKBase.h>

#import "JMBoomQuickLoginModalView.h"

#import "JMBoomAccountBusiness.h"

@interface JMBoomAutoLoginHintView ()

@property (nonatomic, assign) BOOL isLoginSuccessing;

@end

@implementation JMBoomAutoLoginHintView

- (instancetype)initWithNumber:(NSString *)number
                  protocolName:(NSString *)protocolName
                   protocolUrl:(NSString *)protocolUrl
              verifyCodeLength:(NSInteger)verifyCodeLength
                     delayTime:(NSTimeInterval)delayTime
                      nickname:(NSString *)nickname {
    self = [self init];
    if (self) {
        self.number = number;
        self.protocolName = protocolName;
        self.protocolUrl = protocolUrl;
        self.verifyCodeLength = verifyCodeLength;
        self.delayTime = delayTime;
        self.nickname = nickname;
        
        [self setupUI];
        [self setupUIResponse];
    }
    return self;
}

#pragma mark - setup UI

- (void)setupUI {
    [super setupUI];
    
    [self.contentView addSubview:self.statusImageView];
    [self.contentView addSubview:self.messageLabel];
    [self.contentView addSubview:self.breakButton];

    [self.statusImageView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(18, 18);
        make.topJM = 19;
        make.leftJM = 15;
    }];
    [self.messageLabel jm_layout:^(UIView * _Nonnull make) {
        [make sizeToFit];
        make.leftJM = self.statusImageView.rightJM + 8;
        make.centerYJM = self.statusImageView.centerYJM;
    }];
    [self.breakButton jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(68, 32);
        make.rightJM = self.contentView.widthJM - 15;
        make.centerYJM = self.statusImageView.centerYJM;
    }];
}

#pragma mark - setup UI response

- (void)setupUIResponse {
    [super setupUIResponse];
    
    [self.breakButton addTarget:self
                         action:@selector(breakButtonTapped)
               forControlEvents:UIControlEventTouchUpInside];
}

- (void)breakButtonTapped {
    JMLog(@"自动登录中，用户点击切换按钮");
    [self loginCancel];
}

#pragma mark - action

- (void)show {
    [super show];
    
    __weak typeof(self) weakSelf = self;
    [[JMBoomSDKBusiness shared] loginWithCallback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            [weakSelf loginFailed:error];
        } else {
            JMLog(@"自动登录中，登录成功");
            weakSelf.isLoginSuccessing = YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MAX(self.delayTime - 0.5, 0) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                JMLog(@"自动登录中，收起切换按钮");
                [weakSelf loginSuccessPreposition];
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                JMLog(@"自动登录中，收起自动登录界面");
                [weakSelf loginSuccess:responseObject];
            });
        }
    }];
}

- (void)loginSuccessPreposition {
    if (!self.isLoginSuccessing) return;
    
    self.breakButton.hidden = YES;
}

- (void)loginSuccess:(NSDictionary *)responesObject {
    if (!self.isShow) return;
    if (!self.isLoginSuccessing) return;
    
    [self dismissSuccess:responesObject];
}

- (void)loginFailed:(NSError *)error {
    self.isLoginSuccessing = NO;
    [self dismissFailed:error];
    [JMRktDialog showError:error];
}

- (void)loginCancel {
    self.isLoginSuccessing = NO;
    [JMBoomSDKBusiness.event uploadEvent:[JMBoomSDKEventItem event:JMBoomSDKEventId_Login_Cancel]];
    [self dismissCancel];
}

#pragma mark - protocol

#pragma mark - setter

#pragma mark - getter

- (UIImageView *)statusImageView {
    if (!_statusImageView) {
        _statusImageView = [[UIImageView alloc] init];
        _statusImageView.image = [JMBoomSDKResource imageNamed:@"boom_ic_refresh_s"];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        animation.fromValue = [NSNumber numberWithFloat:0.f];
        animation.toValue = [NSNumber numberWithFloat:M_PI *2];
        animation.duration = 2;
        animation.autoreverses = NO;
        animation.fillMode = kCAFillModeForwards;
        animation.repeatCount = MAXFLOAT;
        [_statusImageView.layer addAnimation:animation forKey:nil];
    }
    return _statusImageView;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.text = [NSString stringWithFormat:@"%@, 登录中...", self.nickname];
        _messageLabel.textColor = [UIColor colorWithWhite:51/255.0 alpha:1];
        _messageLabel.font = [UIFont systemFontOfSize:16];
    }
    return _messageLabel;
}

- (JMCommonButton *)breakButton {
    if (!_breakButton) {
        _breakButton = [JMCommonButton buttonWithType:UIButtonTypeCustom];
        
        [_breakButton setTitle:@"切换" forState:UIControlStateNormal];
    }
    return _breakButton;
}

@end
