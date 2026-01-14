//
//  JMBoomVerificationModalView.m
//  JMBoomSDK
//
//  Created by Thief Toki on 2020/8/7.
//

#import "JMBoomVerificationModalView.h"

#import "JMBoomAccountBusiness.h"

@interface JMBoomVerificationModalView ()

@property (nonatomic, assign) BOOL isRecorded;

@end

@implementation JMBoomVerificationModalView

- (instancetype)initWithNumber:(NSString *)number
              verifyCodeLength:(NSInteger)verifyCodeLength
                          type:(JMBoomVerificationType)type {
    self = [self init];
    if (self) {
        self.number = number;
        self.verifyCodeLength = verifyCodeLength;
        self.type = type;
        
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
    [self.contentView addSubview:self.countDownButton];
    
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
        make.sizeJM = CGSizeMake(self.boardImageView.widthJM - 60*2, 0);
        [make sizeToFit];
        make.topJM = self.boardImageView.topJM + 40;
        make.centerXJM = self.boardImageView.centerXJM;
    }];
    
    [self.inputView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(self.boardImageView.widthJM, 56);
        make.topJM = self.boardImageView.topJM + 111;
        make.centerXJM = self.boardImageView.centerXJM;
    }];
    
    [self.countDownButton jm_layout:^(UIView * _Nonnull make) {
        CGFloat height = 20;
        CGFloat board = 10;
        CGFloat topMargin = 20;
        make.sizeJM = CGSizeMake(self.boardImageView.widthJM - 100*2, height + board*2);
        make.topJM = self.inputView.bottomJM + topMargin - board;
        make.centerXJM = self.boardImageView.centerXJM;
    }];
    
    [self.countDownButton countDownBegin];
}

#pragma mark - setup UI response

- (void)setupUIResponse {
    [super setupUIResponse];
    
    [self.topView.goBackButton addTarget:self
                                  action:@selector(goBackButtonTapped)
                        forControlEvents:UIControlEventTouchUpInside];
    
    [self.countDownButton addTarget:self
                             action:@selector(countDownButtonTapped)
                   forControlEvents:UIControlEventTouchUpInside];
}

- (void)goBackButtonTapped {
    [self.inputView.shadowTextField resignFirstResponder];
    
    [self.countDownButton countDownEnd];
    [self.stack pop];
}

- (void)countDownButtonTapped {
    [self.countDownButton countDownBegin];
    
    [JMToast showToastLoading];
    [[JMBoomSDKBusiness shared] verificationCodeWithPhoneNumber:self.number
                                          verificationType:self.type
                                                       callback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            [JMRktDialog showError:error];
        } else {
            [JMToast dismissToast];
        }
    }];
}

- (void)submitVerifyCode:(NSString *)code {
    [self.inputView.shadowTextField resignFirstResponder];

    if (code.length != self.verifyCodeLength) {
        [JMToast showToast:@"请您输入正确的验证码"];
        return;
    }

    [JMToast showToastLoading];

    __weak typeof(self) weakSelf = self;
    JMBusinessCallback callback = ^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            [weakSelf.inputView clean];
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
            [weakSelf.countDownButton countDownEnd];
            [weakSelf dismissSuccess:responseObject];
        }
    };

    switch (self.type) {
        case JMBoomVerificationType_Login: {
            [[JMBoomSDKBusiness shared] phoneLoginWithPhoneNumber:self.number
                                                 verificationCode:self.inputView.shadowTextField.text
                                                         callback:callback];
        }
            break;
        case JMBoomVerificationType_Bound: {
            [[JMBoomSDKBusiness shared] guestBoundWithPhoneNumber:self.number
                                                 verificationCode:self.inputView.shadowTextField.text
                                                         callback:callback];
        }
            break;
        case JMBoomVerificationType_Change: {
            
        }
            break;
        case JMBoomVerificationType_Destroy: {
            
        }
            break;
    }
}

#pragma mark - protocol

- (UIView *)splitInputView:(JMSplitInputView *)splitInputView displayViewWith:(NSString *)string forIndex:(NSUInteger)index {
    UILabel *label = [[UILabel alloc] init];
    label.text = string;
    label.textColor = [UIColor colorWithWhite:51/255.0 alpha:1];
    label.font = [UIFont systemFontOfSize:30 weight:UIFontWeightBold];
    [label sizeToFit];
    
    return label;
}

- (UIView *)splitInputView:(JMSplitInputView *)splitInputView placeholderViewForIndex:(NSUInteger)index {
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.backgroundColor = [UIColor colorWithRed:166/255.0 green:168/255.0 blue:177/255.0 alpha:1.0];
    backImageView.sizeJM = CGSizeMake(16, 2);
    
    return backImageView;
}

- (UIButton *)confirmButtonForkeyboardPreviewView:(JMKeyboardPreviewView *)keyboardPreviewView {
    return nil;
}

- (void)keyboardPreviewView:(JMKeyboardPreviewView *)keyboardPreviewView editingChanged:(NSString *)string {
    if (!self.isRecorded) {
        self.isRecorded = YES;
        switch (self.type) {
            case JMBoomVerificationType_Login: {
                [JMBoomSDKBusiness.event uploadEvent:[JMBoomSDKEventItem event:JMBoomSDKEventId_VerificationCodeInput exStrs:@[@"0"]]];
                JMLog(@"JMBoom Event = JMBoomSDKEventId_VerificationCodeInput:0");
            }
                break;
            case JMBoomVerificationType_Bound: {
                [JMBoomSDKBusiness.event uploadEvent:[JMBoomSDKEventItem event:JMBoomSDKEventId_VerificationCodeInput exStrs:@[@"1"]]];
                JMLog(@"JMBoom Event = JMBoomSDKEventId_VerificationCodeInput:1");
            }
                break;
            case JMBoomVerificationType_Change: {
                
            }
                break;
            case JMBoomVerificationType_Destroy: {
                
            }
                break;
        }
    }
    
    if (string.length < self.verifyCodeLength) return;
    
    [JMToast showToastLoading];
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf submitVerifyCode:string];
    });
}

- (void)keyboardPreviewView:(JMKeyboardPreviewView *)keyboardPreviewView confirmButtonTapped:(UIButton *)confirmButton {
    
}

#pragma mark - setter

- (void)setIsShow:(BOOL)isShow {
    [super setIsShow:isShow];
    
    if (isShow) {
        [self.inputView.shadowTextField becomeFirstResponder];
    } else {
        [self.inputView.shadowTextField resignFirstResponder];
    }
}

#pragma mark - getter

- (JMCompositeTitleView *)titleView {
    if (!_titleView) {
        _titleView = [[JMCompositeTitleView alloc] init];
        _titleView.titleLabel.text = @"输入短信验证码";
        NSString *encryptedNumber;
        if (self.number.length == 11) {
            encryptedNumber = [self.number stringByReplacingCharactersInRange:NSMakeRange(4, 4) withString:@"****"];
        } else {
            encryptedNumber = @"您的手机";
        }
        _titleView.subtitleLabel.text = [@"验证码已发送至" stringByAppendingString:encryptedNumber];
        _titleView.space = 4;
    }
    return _titleView;
}

- (JMSplitInputView *)inputView {
    if (!_inputView) {
        _inputView = [[JMSplitInputView alloc] initWithMaximalLength:self.verifyCodeLength];
        _inputView.shadowTextField.keyboardType = UIKeyboardTypeNumberPad;
        if (@available(iOS 12.0, *)) {
            _inputView.shadowTextField.textContentType = UITextContentTypeOneTimeCode;
        }
        _inputView.delegate = self;
    }
    return _inputView;
}

- (JMCountDownButton *)countDownButton {
    if (!_countDownButton) {
        _countDownButton = [JMCountDownButton buttonWithType:UIButtonTypeCustom];
        _countDownButton.time = 40;
        _countDownButton.staticTitle = @"重新发送验证码";
        _countDownButton.countDownTitle = @"重发";
        _countDownButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _countDownButton;
}

@end
