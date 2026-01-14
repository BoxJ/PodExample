//
//  JMQuickBindPhoneModalView.m
//  JMBoomSDK
//
//  Created by Thief Toki on 2020/8/4.
//

#import "JMQuickBindPhoneModalView.h"

#import <JMBoomSDKBase/JMBoomSDKBase.h>

#import "JMBoomVerificationModalView.h"
#import "JMBoomBindPhoneModalView.h"

#import "JMBoomAccountBusiness.h"

@implementation JMQuickBindPhoneModalView

- (instancetype)initWithNumber:(NSString *)number
                  operatorName:(NSString *)operatorName
                  protocolName:(NSString *)protocolName
                   protocolUrl:(NSString *)protocolUrl
              verifyCodeLength:(NSInteger)verifyCodeLength
                          lock:(BOOL)isLock
                          type:(JMBoomBindPhoneType)type {
    self = [self init];
    if (self) {
        self.number = number;
        self.operatorName = operatorName;
        self.protocolName = protocolName;
        self.protocolUrl = protocolUrl;
        self.verifyCodeLength = verifyCodeLength;
        self.isLock = isLock;
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
    [self.contentView addSubview:self.phoneNumberLabel];
    [self.contentView addSubview:self.boundButton];
    [self.contentView addSubview:self.phoneSchemeButton];
    [self.contentView insertSubview:self.phoneImageView belowSubview:self.phoneSchemeButton];
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
        make.sizeJM = CGSizeMake(self.boardImageView.widthJM - 40*2, 0);
        [make sizeToFit];
        make.topJM = self.boardImageView.topJM + 40;
        make.centerXJM = self.boardImageView.centerXJM;
    }];
    
    [self.phoneNumberLabel jm_layout:^(UIView * _Nonnull make) {
        [make sizeToFit];
        make.topJM = self.boardImageView.topJM + 117;
        make.centerXJM = self.boardImageView.centerXJM;
    }];
    
    [self.boundButton jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(260, 44);
        make.topJM = self.phoneNumberLabel.bottomJM + 21;
        make.centerXJM = self.boardImageView.centerXJM;
    }];
    
    [self.phoneSchemeButton jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(84+(20+8)*2, 20);
        make.topJM = self.boundButton.bottomJM + 20;
        make.centerXJM = self.boardImageView.centerXJM;
    }];
    
    [self.phoneImageView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(20, 20);
        make.leftJM = self.phoneSchemeButton.leftJM;
        make.centerYJM = self.phoneSchemeButton.centerYJM;
    }];
    
    [self.agreementView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(self.boardImageView.widthJM, 55);
        make.topJM = self.phoneSchemeButton.bottomJM + 19;
        make.centerXJM = self.boardImageView.centerXJM;
    }];
    
    self.topView.isLocked = self.isLock;
    
    [self.agreementView updateProtocolName:self.protocolName
                            protocolUrl:self.protocolUrl];
    [self.agreementView updateScene:JMAgreementScene_BindPhone];
}

#pragma mark - setup UI response

- (void)setupUIResponse {
    [super setupUIResponse];
    
    [self.topView.closeButton addTarget:self
                                 action:@selector(closeButtonTapped)
                       forControlEvents:UIControlEventTouchUpInside];
    [self.boundButton addTarget:self
                         action:@selector(quickSchemeboundButtonTapped)
               forControlEvents:UIControlEventTouchUpInside];
    [self.phoneSchemeButton addTarget:self
                               action:@selector(phoneSchemeButtonTapped)
                     forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)closeButtonTapped {
    [self dismissCancel];
}

- (void)quickSchemeboundButtonTapped {
    [self endEditing:YES];
    
    [JMToast showToastLoading];
    __weak typeof(self) weakSelf = self;
    [[JMBoomSDKBusiness shared] quickGuestBoundWithCallback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            [JMRktDialog showError:error];
        } else {
            [JMToast dismissToast];
            [weakSelf dismissSuccess:responseObject];
        }
    }];
}

- (void)phoneSchemeButtonTapped {
    [self.stack push:[[JMBoomBindPhoneModalView alloc] initWithLock:self.isLock
                                                          type:self.type
                                              verifyCodeLength:self.verifyCodeLength]
           responder:[JMResponder success:^(NSDictionary *info) {
        [self dismissSuccess:info];
    }]];
}

#pragma mark - protocol

#pragma mark - setter

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

- (UILabel *)phoneNumberLabel {
    if (!_phoneNumberLabel) {
        _phoneNumberLabel = [[UILabel alloc] init];
        _phoneNumberLabel.textColor = [UIColor colorWithRed:62/255.0 green:64/255.0 blue:70/255.0 alpha:1];;
        _phoneNumberLabel.font = [UIFont systemFontOfSize:22 weight:UIFontWeightBold];
        _phoneNumberLabel.text = self.number;
    }
    return _phoneNumberLabel;
}

- (JMCommonButton *)boundButton {
    if (!_boundButton) {
        _boundButton = [JMCommonButton buttonWithType:UIButtonTypeCustom];
        [_boundButton setTitle:@"一键绑定" forState:UIControlStateNormal];
    }
    return _boundButton;
}

- (JMCrispButton *)phoneSchemeButton {
    if (!_phoneSchemeButton) {
        _phoneSchemeButton = [JMCrispButton buttonWithType:UIButtonTypeCustom];
        _phoneSchemeButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
        [_phoneSchemeButton setTitle:@"其他手机绑定" forState:UIControlStateNormal];
        [_phoneSchemeButton setTitleColor:[UIColor colorWithRed:73/255.0 green:74/255.0 blue:85/255.0 alpha:1.0]
                                 forState:UIControlStateNormal];
    }
    return _phoneSchemeButton;
}

- (UIImageView *)phoneImageView {
    if (!_phoneImageView) {
        _phoneImageView = [[UIImageView alloc] init];
        _phoneImageView.image = [[JMBoomSDKResource shared] resourceWithName:JMBRNWindowPhoneIcon];
        _phoneImageView.tintColor = [[JMBoomSDKResource shared] resourceWithName:JMBRNWindowPhoneIconTintColor];
        _phoneImageView.layer.cornerRadius = 10;
        _phoneImageView.layer.masksToBounds = YES;
        _phoneImageView.layer.borderWidth = 1;
        _phoneImageView.layer.borderColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1.0].CGColor;
    }
    return _phoneImageView;
}

- (JMBoomAgreementView *)agreementView {
    if (!_agreementView) {
        _agreementView = [[JMBoomAgreementView alloc] init];
    }
    return _agreementView;
}

@end
