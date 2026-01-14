//
//  JMBoomRealNameAuthenticationModalView.m
//  JMBoomSDK
//
//  Created by Thief Toki on 2020/8/3.
//

#import "JMBoomRealNameAuthenticationModalView.h"

#import <JMBoomSDKBase/JMBoomSDKBase.h>

#import "JMBoomRealNameBusiness.h"

@implementation JMBoomRealNameAuthenticationModalView

- (instancetype)initWithLock:(BOOL)isLock {
    self = [self init];
    if (self) {
        self.isLock = isLock;
        
        [self setupUI];
        [self setupUIResponse];
    }
    return self;
}

#pragma mark - setup UI

- (void)setupUI {
    [super setupUI];
    
    [self.contentView addSubview:self.closeButton];
    [self.contentView addSubview:self.titleView];
    [self.contentView addSubview:self.introLabel];
    [self.contentView addSubview:self.nameInputView];
    [self.contentView addSubview:self.idNumberInputView];
    [self.contentView addSubview:self.confirmButton];
    
    [self.boardImageView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(320, kIsLandscape ? 320 : 320);
        make.centerXJM = self.contentView.centerXJM;
        make.centerYJM = self.contentView.centerYJM;    
    }];
    
    [self.closeButton jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(21, 21);
        make.rightJM = self.boardImageView.rightJM - 10;
        make.topJM = self.boardImageView.topJM + 9;    
    }];
    
    [self.titleView jm_layout:^(UIView * _Nonnull make) {
        [make sizeToFit];
        make.centerXJM = self.boardImageView.centerXJM;
        make.topJM = self.boardImageView.topJM + (kIsLandscape ? 22 : 22);
    }];
    
    [self.introLabel jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(276, 51);
        [make sizeToFit];
        make.centerXJM = self.boardImageView.centerXJM;
        make.topJM = self.titleView.bottomJM + 11;
    }];
    
    [self.nameInputView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(260, 44);
        make.centerXJM = self.boardImageView.centerXJM;
        make.topJM = self.introLabel.bottomJM + (kIsLandscape ? 16 : 16);
    }];
    
    [self.idNumberInputView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(260, 44);
        make.centerXJM = self.boardImageView.centerXJM;
        make.topJM = self.nameInputView.bottomJM + 16;
    }];
    
    [self.confirmButton jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(260, 48);
        make.centerXJM = self.boardImageView.centerXJM;
        make.topJM = self.idNumberInputView.bottomJM + 20;
    }];
    
    self.closeButton.hidden = self.isLock;
}    

#pragma mark - setup UI response

- (void)setupUIResponse {
    [super setupUIResponse];
    
    [self.closeButton addTarget:self action:@selector(closeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.confirmButton addTarget:self action:@selector(confirmButtonTapped) forControlEvents:UIControlEventTouchUpInside];
}

- (void)closeButtonTapped {
    [self dismissCancel];
}

- (void)confirmButtonTapped {
    [self endEditing:YES];
    
    [JMToast showToastLoading];
    
    NSString *name = self.nameInputView.inputTextField.text;
    NSString *idNumber = self.idNumberInputView.inputTextField.text;
    
    if (name.length == 0 || idNumber.length == 0) {
        [JMToast showToast:@"身份信息不能为空"];
        return;
    }
    if (![self isValidPersonalIdNumber:idNumber]) {
        [JMToast showToast:@"证件号码填写错误"];
        return;
    }
    [[JMBoomSDKBusiness shared] identityVerifyWithIdCardNumber:[idNumber uppercaseString]
                                             realName:name
                                             callback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            [JMRktDialog showError:error];
        } else {
            [JMToast showToastSuccess:@"已完成实名认证"];
            [self dismissSuccess:responseObject];
        }
    }];
}

#pragma mark - util

- (BOOL)isValidPersonalIdNumber:(NSString *)idNumber {
    //身份证号格式正则表达式
    NSString *regEx = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *card = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regEx];
    return [card evaluateWithObject:idNumber];
}

#pragma mark - protocol

- (void)keyboardPreviewView:(JMKeyboardPreviewView *)keyboardPreviewView confirmButtonTapped:(UIButton *)confirmButton {
    if ([keyboardPreviewView.previewTextField.delegate isEqual:self.nameInputView.inputTextField]) {
        [self.idNumberInputView.inputTextField becomeFirstResponder];
    }else if ([keyboardPreviewView.previewTextField.delegate isEqual:self.idNumberInputView.inputTextField]) {
        [self.confirmButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - setter

#pragma mark - getter

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[JMBoomSDKResource imageNamed:@"boom_ic_close"] forState:UIControlStateNormal];
    }
    return _closeButton;
}

- (JMCompositeTitleView *)titleView {
    if (!_titleView) {
        _titleView = [[JMCompositeTitleView alloc] init];
        _titleView.titleLabel.text = @"实名认证";
    }
    return _titleView;
}

- (JMInputView *)nameInputView {
    if (!_nameInputView) {
        _nameInputView = [[JMInputView alloc] init];
        _nameInputView.titleLabel.text = @"真实姓名";
        _nameInputView.inputTextField.attributedPlaceholder =
        [[NSAttributedString alloc] initWithString:@"请输入真实姓名"
                                        attributes:@{
            NSFontAttributeName: [UIFont systemFontOfSize:14 weight:UIFontWeightRegular],
            NSForegroundColorAttributeName: [UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:1],
        }];
    }
    return _nameInputView;
}

- (JMInputView *)idNumberInputView {
    if (!_idNumberInputView) {
        _idNumberInputView = [[JMInputView alloc] init];
        _idNumberInputView.titleLabel.text = @"身份证号";
        _idNumberInputView.inputTextField.attributedPlaceholder =
        [[NSAttributedString alloc] initWithString:@"请输入身份证号"
                                        attributes:@{
            NSFontAttributeName: [UIFont systemFontOfSize:14 weight:UIFontWeightRegular],
            NSForegroundColorAttributeName: [UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:1],
        }];
    }
    return _idNumberInputView;
}

- (UILabel *)introLabel {
    if (!_introLabel) {
        _introLabel = [[UILabel alloc] init];
        _introLabel.text = @"根据《关于进一步严格管理 切实防止未成年人沉迷网络游戏的通知》规定，您需要进行实名认证。";
        _introLabel.textColor = [UIColor colorWithRed:62/255.0 green:64/255.0 blue:70/255.0 alpha:1];
        _introLabel.font = [UIFont systemFontOfSize:12];
        _introLabel.numberOfLines = 0;
    }
    return _introLabel;
}

- (JMCommonButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [JMCommonButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitle:@"认证" forState:UIControlStateNormal];
    }
    return _confirmButton;
}

@end
