//
//  JMBoomPhoneLoginModalView.m
//  JMBoomSDK
//
//  Created by Thief Toki on 2020/8/4.
//

#import "JMBoomPhoneLoginModalView.h"

#import <JMBoomSDKBase/JMBoomSDKBase.h>

#import "JMBoomVerificationModalView.h"

#import "JMBoomAccountBusiness.h"

@interface JMBoomPhoneLoginModalView ()

@property (nonatomic, assign) BOOL isRecorded;

@end

@implementation JMBoomPhoneLoginModalView

- (instancetype)initWithLoginStyle:(NSArray<NSString *> *)loginStyle
                  verifyCodeLength:(NSInteger)verifyCodeLength
                       loginForced:(BOOL)loginForced{
    self = [self init];
    if (self) {
        self.loginStyle = loginStyle;
        self.verifyCodeLength = verifyCodeLength;
        self.loginForced = loginForced;
        
        [self setupUI];
        [self setupUIResponse];
    }
    return self;
}

- (void)didMoveToWindow {
    //展示登录页面成功
    [JMBoomSDKBusiness.event uploadEvent:[JMBoomSDKEventItem event:JMBoomSDKEventId_LoginView_Enter_Successed exStrs:@[@"0"]]];
    
    JMLog(@"JMBoom Event = JMBoomSDKEventId_LoginView_Enter_Successed:0");
}

#pragma mark - setup UI

- (void)setupUI {
    [super setupUI];
    
    [self.contentView addSubview:self.titleView];
    [self.contentView addSubview:self.numberInputView];
    [self.contentView addSubview:self.sendButton];
    [self.contentView addSubview:self.guestLoginButton];
    [self.contentView insertSubview:self.guestImageView belowSubview:self.guestLoginButton];
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
    
    [self.titleView jm_layout:^(UIView * _Nonnull make) {
        [make sizeToFit];
        make.topJM = self.boardImageView.topJM + 40;
        make.centerXJM = self.boardImageView.centerXJM;
    }];
    
    [self.numberInputView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(260, 44);
        make.topJM = self.boardImageView.topJM + 90;
        make.centerXJM = self.boardImageView.centerXJM;
    }];
    
    [self.sendButton jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(260, 44);
        make.topJM = self.numberInputView.bottomJM + 24;
        make.centerXJM = self.boardImageView.centerXJM;
    }];
    
    [self.guestLoginButton jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(56+(20+8)*2, 20);
        make.topJM = self.sendButton.bottomJM + 20;
        make.centerXJM = self.boardImageView.centerXJM;
    }];
    
    [self.guestImageView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(20, 20);
        make.leftJM = self.guestLoginButton.leftJM;
        make.centerYJM = self.guestLoginButton.centerYJM;
    }];
    
    [self.agreementView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(self.boardImageView.widthJM, 55);
        make.topJM = self.sendButton.bottomJM + 62;
        make.centerXJM = self.boardImageView.centerXJM;
    }];
    
    [self.agreementView updateScene:JMAgreementScene_Login];
}

#pragma mark - setup UI response

- (void)setupUIResponse {
    [super setupUIResponse];
    
    [self.topView.goBackButton addTarget:self
                                  action:@selector(goBackButtonTapped)
                        forControlEvents:UIControlEventTouchUpInside];
    [self.topView.closeButton addTarget:self
                                 action:@selector(closeButtonTapped)
                       forControlEvents:UIControlEventTouchUpInside];
    [self.sendButton addTarget:self
                        action:@selector(phoneSchemeSendButtonTapped)
              forControlEvents:UIControlEventTouchUpInside];
    [self.guestLoginButton addTarget:self
                              action:@selector(schemeViewGuestLoginButtonTapped)
                    forControlEvents:UIControlEventTouchUpInside];
}

- (void)goBackButtonTapped {
    [self.stack pop];
}

- (void)closeButtonTapped {
    [self dismissCancel];
}

- (void)phoneSchemeSendButtonTapped {
    [self endEditing:YES];
    
    __block NSString *number = self.numberInputView.value;
    if (![number isPhoneNumber]) {
        [JMToast showToast:@"手机号格式错误"];
        return;
    }
    
    if (!self.agreementView.isSelected) {
        [JMToast showToast:@"请勾选同意后再进行操作"];
        return;
    }
    
    [JMToast showToastLoading];
    __weak typeof(self) weakSelf = self;
    [[JMBoomSDKBusiness shared] verificationCodeWithPhoneNumber:number
                                          verificationType:JMBoomVerificationType_Login
                                                  callback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            [JMRktDialog showError:error];
        } else {
            [JMToast dismissToast];
            [weakSelf.stack push:[[JMBoomVerificationModalView alloc] initWithNumber:number
                                                                verifyCodeLength:weakSelf.verifyCodeLength
                                                                            type:JMBoomVerificationType_Login]
                   responder:[JMResponder success:^(NSDictionary *info) {
                [weakSelf dismissSuccess:info];
            }]];
        }
    }];
}

- (void)schemeViewGuestLoginButtonTapped {
    [self endEditing:YES];
    
    if (!self.agreementView.isSelected) {
        [JMToast showToast:@"请勾选同意后再进行操作"];
        return;
    }
    
    [JMToast showToastLoading];
    __weak typeof(self) weakSelf = self;
    [[JMBoomSDKBusiness shared] guestLoginWithCallback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            [JMRktDialog showError:error];
        } else {
            [JMToast dismissToast];
            [weakSelf dismissSuccess:responseObject];
        }
    }];
}

#pragma mark - protocol

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger index = range.location;
    BOOL isInput = range.length == 0;
    if (index >= 11 && isInput) return NO;
    if (!self.isRecorded) {
        self.isRecorded = YES;
        [JMBoomSDKBusiness.event uploadEvent:[JMBoomSDKEventItem event:JMBoomSDKEventId_PhoneNumberInput exStrs:@[@"0"]]];
        JMLog(@"JMBoom Event = JMBoomSDKEventId_PhoneNumberInput:0");
    }
    return YES;
}

- (void)keyboardPreviewView:(JMKeyboardPreviewView *)keyboardPreviewView confirmButtonTapped:(UIButton *)confirmButton {
    if ([keyboardPreviewView.previewTextField.delegate isEqual:self.numberInputView.inputTextField]) {
        [self.sendButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

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
    
    if (isShow) {
        [JMKeyboardPreviewView shared].previewTextField.banPaste = YES;
    } else {
        [JMKeyboardPreviewView shared].previewTextField.banPaste = NO;
    }
}

#pragma mark - getter

- (JMCompositeTitleView *)titleView {
    if (!_titleView) {
        _titleView = [[JMCompositeTitleView alloc] init];
        _titleView.titleLabel.text = @"手机号登录";
    }
    return _titleView;
}

- (JMInputView *)numberInputView {
    if (!_numberInputView) {
        _numberInputView = [[JMInputView alloc] init];
        _numberInputView.iconImageView.image = [JMBoomSDKResource imageNamed:@"boom_ic_phonenum"];
        _numberInputView.inputTextField.attributedPlaceholder =
        [[NSAttributedString alloc] initWithString:@"请输入手机号码"
                                        attributes:@{
            NSFontAttributeName: [UIFont systemFontOfSize:14 weight:UIFontWeightRegular],
            NSForegroundColorAttributeName: [UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:1],
        }];
        _numberInputView.inputTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _numberInputView.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        _numberInputView.inputTextField.delegate = self;
    }
    return _numberInputView;
}

- (JMCommonButton *)sendButton {
    if (!_sendButton) {
        _sendButton = [JMCommonButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
    return _sendButton;
}

- (JMCrispButton *)guestLoginButton {
    if (!_guestLoginButton) {
        _guestLoginButton = [JMCrispButton buttonWithType:UIButtonTypeCustom];
        _guestLoginButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
        [_guestLoginButton setTitle:@"游客登录" forState:UIControlStateNormal];
        [_guestLoginButton setTitleColor:[UIColor colorWithRed:73/255.0 green:74/255.0 blue:85/255.0 alpha:1.0]
                                forState:UIControlStateNormal];
        _guestLoginButton.hidden = ![self.loginStyle containsObject:kJMBoomSDKConfigLoginStyle_Guest];
    }
    return _guestLoginButton;
}

- (UIImageView *)guestImageView {
    if (!_guestImageView) {
        _guestImageView = [[UIImageView alloc] init];
        _guestImageView.image = [[JMBoomSDKResource shared] resourceWithName:JMBRNWindowGuestIcon];
        _guestImageView.tintColor = [[JMBoomSDKResource shared] resourceWithName:JMBRNWindowGuestIconTintColor];
        _guestImageView.hidden = ![self.loginStyle containsObject:kJMBoomSDKConfigLoginStyle_Guest];
        _guestImageView.layer.cornerRadius = 10;
        _guestImageView.layer.masksToBounds = YES;
        _guestImageView.layer.borderWidth = 1;
        _guestImageView.layer.borderColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1.0].CGColor;
    }
    return _guestImageView;
}

- (JMBoomAgreementView *)agreementView {
    if (!_agreementView) {
        _agreementView = [[JMBoomAgreementView alloc] init];
    }
    return _agreementView;
}

@end
