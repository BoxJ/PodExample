//
//  JMBoomBindPhoneModalView.m
//  JMBoomSDK
//
//  Created by Thief Toki on 2020/8/11.
//

#import "JMBoomBindPhoneModalView.h"

#import <JMBoomSDKBase/JMBoomSDKBase.h>

#import "JMBoomVerificationModalView.h"

#import "JMBoomAccountBusiness.h"

@interface JMBoomBindPhoneModalView ()

@property (nonatomic, assign) BOOL isRecorded;

@end

@implementation JMBoomBindPhoneModalView

- (instancetype)initWithLock:(BOOL)isLock
                        type:(JMBoomBindPhoneType)type
            verifyCodeLength:(NSInteger)verifyCodeLength {
    self = [self init];
    if (self) {
        self.isLock = isLock;
        self.type = type;
        self.verifyCodeLength = verifyCodeLength;
        
        [self setupUI];
        [self setupUIResponse];
    }
    return self;
}

#pragma mark - setup UI

- (void)setupUI {
    [super setupUI];
    
    [self.contentView addSubview:self.titleView];
    [self.contentView addSubview:self.inputView];
    [self.contentView addSubview:self.confirmButton];
    
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
        make.sizeJM = CGSizeMake(self.boardImageView.widthJM - 40*2, 0);
        [make sizeToFit];
        make.topJM = self.boardImageView.topJM + 40;
        make.centerXJM = self.boardImageView.centerXJM;
    }];
    
    [self.inputView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(self.boardImageView.widthJM -30*2, 44);
        make.topJM = self.boardImageView.topJM + 124;
        make.centerXJM = self.boardImageView.centerXJM;
    }];
    
    [self.confirmButton jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(260, 48);
        make.topJM = self.inputView.bottomJM + 54;
        make.centerXJM = self.boardImageView.centerXJM;
    }];
    
    self.topView.isLocked = self.isLock;
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
    
    [self.confirmButton addTarget:self
                           action:@selector(confirmButtonTapped)
                 forControlEvents:UIControlEventTouchUpInside];
}

- (void)goBackButtonTapped {
    [self.stack pop];
}

- (void)closeButtonTapped {
    [self dismissCancel];
}

- (void)confirmButtonTapped {
    [self endEditing:YES];
    
    __block NSString *number = self.inputView.inputTextField.text;
    if (![number isPhoneNumber]) {
        [JMToast showToast:@"手机号格式错误"];
        return;
    }
    
    [JMToast showToastLoading];
    __weak typeof(self) weakSelf = self;
    [[JMBoomSDKBusiness shared] verificationCodeWithPhoneNumber:number
                                             verificationType:JMBoomVerificationType_Bound
                                                     callback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            [JMRktDialog showError:error];
        } else {
            [JMToast dismissToast];
            [weakSelf.stack push:[[JMBoomVerificationModalView alloc] initWithNumber:number
                                                                verifyCodeLength:weakSelf.verifyCodeLength
                                                                            type:JMBoomVerificationType_Bound]
             responder:[JMResponder success:^(NSDictionary *info) {
                [weakSelf dismissSuccess:info];
            }]];
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
        [JMBoomSDKBusiness.event uploadEvent:[JMBoomSDKEventItem event:JMBoomSDKEventId_PhoneNumberInput exStrs:@[@"1"]]];
        JMLog(@"JMBoom Event = JMBoomSDKEventId_PhoneNumberInput:1");
    }
    return YES;
}

- (void)keyboardPreviewView:(JMKeyboardPreviewView *)keyboardPreviewView confirmButtonTapped:(UIButton *)confirmButton {
    if ([keyboardPreviewView.previewTextField.delegate isEqual:self.inputView.inputTextField]) {
        [self.confirmButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}
#pragma mark - setter

- (void)setIsShow:(BOOL)isShow {
    [super setIsShow:isShow];
    
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
        _titleView.titleLabel.text = @"绑定手机号";
        switch (self.type) {
            case JMBoomBindPhoneType_Login: {
                _titleView.subtitleLabel.text = @"为了您的账户安全，请绑定手机号";
            }
                break;
            case JMBoomBindPhoneType_Recharge: {
                _titleView.subtitleLabel.text = @"为了您的账户安全，请绑定手机号后充值";
            }
                break;
        }
        _titleView.space = 4;
    }
    return _titleView;
}

- (JMInputView *)inputView {
    if (!_inputView) {
        _inputView = [[JMInputView alloc] init];
        _inputView.iconImageView.image = [JMBoomSDKResource imageNamed:@"boom_ic_phonenum"];
        _inputView.inputTextField.attributedPlaceholder =
        [[NSAttributedString alloc] initWithString:@"请输入要绑定的手机号"
                                        attributes:@{
            NSFontAttributeName: [UIFont systemFontOfSize:14 weight:UIFontWeightRegular],
            NSForegroundColorAttributeName: [UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:1],
        }];
        _inputView.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        _inputView.inputTextField.delegate = self;
    }
    return _inputView;
}

- (JMCommonButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [JMCommonButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
    return _confirmButton;
}

@end
