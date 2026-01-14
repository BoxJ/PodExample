//
//  JMBoomQuickLoginModalView.m
//  JMBoomSDK
//
//  Created by Thief Toki on 2020/8/4.
//

#import "JMBoomQuickLoginModalView.h"

#import <JMBoomSDKBase/JMBoomSDKBase.h>

#import "JMBoomPhoneLoginModalView.h"

#import "JMBoomAccountBusiness.h"

@implementation JMBoomQuickLoginModalView

- (instancetype)initWithLoginStyle:(NSArray<NSString *> *)loginStyle
                            number:(NSString *)number
                      operatorName:(NSString *)operatorName
                      protocolName:(NSString *)protocolName
                       protocolUrl:(NSString *)protocolUrl
                  verifyCodeLength:(NSInteger)verifyCodeLength
                       loginForced:(BOOL)loginForced {
    self = [self init];
    if (self) {
        self.loginStyle = loginStyle;
        self.number = number;
        self.operatorName = operatorName;
        self.protocolName = protocolName;
        self.protocolUrl = protocolUrl;
        self.verifyCodeLength = verifyCodeLength;
        self.loginForced = loginForced;
        
        [self setupUI];
        [self setupUIResponse];
    }
    return self;
}

- (void)didMoveToWindow {
    //展示登录页面成功
    [JMBoomSDKBusiness.event uploadEvent:[JMBoomSDKEventItem event:JMBoomSDKEventId_LoginView_Enter_Successed exStrs:@[@"1"]]];
    
    JMLog(@"JMBoom Event = JMBoomSDKEventId_LoginView_Enter_Successed:1");
}

#pragma mark - setup UI

- (void)setupUI {
    [super setupUI];
    
    [self.contentView addSubview:self.phoneNumberLabel];
    [self.contentView addSubview:self.operatorLabel];
    [self.contentView addSubview:self.loginButton];
    [self.contentView addSubview:self.otherSchemeButton];
    [self.contentView insertSubview:self.arrowImageView belowSubview:self.otherSchemeButton];
    [self.contentView addSubview:self.agreementView];
    
    [self.boardImageView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(320, 320);
        make.centerXJM = self.contentView.centerXJM;
        make.centerYJM = self.contentView.centerYJM;
    }];
    
    self.topView.hidden = false;
    [self.topView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(self.boardImageView.widthJM, 44);
        make.topJM = self.boardImageView.topJM;
        make.centerXJM = self.boardImageView.centerXJM;
    }];
    
    [self.phoneNumberLabel jm_layout:^(UIView * _Nonnull make) {
        [make sizeToFit];
        make.topJM = self.boardImageView.topJM + 56;
        make.centerXJM = self.boardImageView.centerXJM;
    }];
    
    [self.operatorLabel jm_layout:^(UIView * _Nonnull make) {
        [make sizeToFit];
        make.topJM = self.phoneNumberLabel.bottomJM + 4;
        make.centerXJM = self.boardImageView.centerXJM;
    }];
    
    [self.loginButton jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(260, 44);
        make.topJM = self.boardImageView.topJM + 142;
        make.centerXJM = self.boardImageView.centerXJM;
    }];
    
    [self.otherSchemeButton jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(100, 20);
        make.topJM = self.loginButton.bottomJM + 20;
        make.centerXJM = self.boardImageView.centerXJM;
    }];
    
    [self.arrowImageView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(6, 12);
        make.leftJM = self.otherSchemeButton.rightJM - 5;
        make.centerYJM = self.otherSchemeButton.centerYJM;
    }];
    
    [self.agreementView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(self.boardImageView.widthJM, 55);
        make.topJM = self.loginButton.bottomJM + 78;
        make.centerXJM = self.boardImageView.centerXJM;
    }];
    
    [self.agreementView updateProtocolName:self.protocolName
                            protocolUrl:self.protocolUrl];
    [self.agreementView updateScene:JMAgreementScene_Login];
}

#pragma mark - setup UI response

- (void)setupUIResponse {
    [super setupUIResponse];
    
    [self.topView.closeButton addTarget:self
                                 action:@selector(closeButtonTapped)
                       forControlEvents:UIControlEventTouchUpInside];
    [self.loginButton addTarget:self
                         action:@selector(quickSchemeLoginButtonTapped)
               forControlEvents:UIControlEventTouchUpInside];
    [self.otherSchemeButton addTarget:self
                               action:@selector(otherSchemeButtonTapped)
                     forControlEvents:UIControlEventTouchUpInside];
}

- (void)closeButtonTapped {
    [self dismissCancel];
}

- (void)quickSchemeLoginButtonTapped {
    [self endEditing:YES];
    
    if (!self.agreementView.isSelected) {
        [JMToast showToast:@"请勾选同意后再进行操作"];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    JMBusinessCallback callback = ^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            if (error.code == JMBoomSDKReportCode_LoginCrashAccountClosing) {
                [JMRktDialog showError:error responder:[JMResponder success:^(NSDictionary *info) {
                    [[JMBoomSDKBusiness shared] loginContinueWithTraceId:error.traceId
                                                          traceType:0
                                                           callback:^(NSDictionary * _Nullable responseObject,
                                                                      NSError * _Nullable error) {
                        [JMToast dismissToast];
                        [weakSelf dismissSuccess:responseObject];
                    }];
                }]];
            } else {
                [JMRktDialog showError:error];
            }
        } else {
            [JMToast dismissToast];
            [weakSelf dismissSuccess:responseObject];
        }
    };
    
    [JMToast showToastLoading];
    [[JMBoomSDKBusiness shared] quickLoginWithCallback:callback];
}

- (void)otherSchemeButtonTapped {
    __weak typeof(self) weakSelf = self;
    [self.stack push:[[JMBoomPhoneLoginModalView alloc] initWithLoginStyle:self.loginStyle
                                                      verifyCodeLength:self.verifyCodeLength
                                                           loginForced:self.loginForced]
           responder:[JMResponder success:^(NSDictionary *info) {
        [weakSelf dismissSuccess:info];
    }]];
}

#pragma mark - protocol

#pragma mark - setter

- (void)setIsShow:(BOOL)isShow {
    [super setIsShow:isShow];
    
    if ([self.stack.rootModaView isEqual:self]) {
        if (self.loginForced) {
            [self.topView upadteType:JMModalTopType_Logo];
        } else {
            [self.topView upadteType:JMModalTopType_Logo | JMModalTopType_Close];
        }
    } else {
        [self.topView upadteType:JMModalTopType_GoBack];
    }
}

#pragma mark - getter

- (UILabel *)phoneNumberLabel {
    if (!_phoneNumberLabel) {
        _phoneNumberLabel = [[UILabel alloc] init];
        _phoneNumberLabel.textColor = [UIColor colorWithRed:62/255.0 green:64/255.0 blue:70/255.0 alpha:1];;
        _phoneNumberLabel.font = [UIFont systemFontOfSize:28 weight:UIFontWeightBold];
        _phoneNumberLabel.text = self.number;
    }
    return _phoneNumberLabel;
}

- (UILabel *)operatorLabel {
    if (!_operatorLabel) {
        _operatorLabel = [[UILabel alloc] init];
        _operatorLabel.textColor = [UIColor colorWithRed:163/255.0 green:163/255.0 blue:163/255.0 alpha:1];;
        _operatorLabel.font = [UIFont systemFontOfSize:12];
        _operatorLabel.text = [NSString stringWithFormat:@"%@提供认证服务", self.operatorName];
    }
    return _operatorLabel;
}

- (JMCommonButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [JMCommonButton buttonWithType:UIButtonTypeCustom];
        [_loginButton setTitle:@"一键登录" forState:UIControlStateNormal];
    }
    return _loginButton;
}

- (JMCrispButton *)otherSchemeButton {
    if (!_otherSchemeButton) {
        _otherSchemeButton = [JMCrispButton buttonWithType:UIButtonTypeCustom];
        _otherSchemeButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_otherSchemeButton setTitle:@"其他登录方式" forState:UIControlStateNormal];
        [_otherSchemeButton setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    return _otherSchemeButton;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithImage:[JMBoomSDKResource imageNamed:@"boom_ic_next"]];
    }
    return _arrowImageView;
}

- (JMBoomAgreementView *)agreementView {
    if (!_agreementView) {
        _agreementView = [[JMBoomAgreementView alloc] init];
    }
    return _agreementView;
}

@end
