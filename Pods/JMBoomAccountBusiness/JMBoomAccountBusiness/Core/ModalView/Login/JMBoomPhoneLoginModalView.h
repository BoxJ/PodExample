//
//  JMBoomPhoneLoginModalView.h
//  JMBoomSDK
//
//  Created by Thief Toki on 2020/8/4.
//

#import <JMUIKit/JMUIKit.h>

#import "JMBoomAgreementView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomPhoneLoginModalView : JMModalView <UITextFieldDelegate, JMKeyboardPreviewViewDelegate>

@property (nonatomic, strong) NSArray<NSString *> *loginStyle;
@property (nonatomic, assign) NSInteger verifyCodeLength;
@property (nonatomic, assign) BOOL loginForced;

@property (nonatomic, strong) JMCompositeTitleView *titleView;
@property (nonatomic, strong) JMInputView *numberInputView;
@property (nonatomic, strong) JMCommonButton *sendButton;
@property (nonatomic, strong) JMCrispButton *guestLoginButton;
@property (nonatomic, strong) UIImageView *guestImageView;
@property (nonatomic, strong) JMBoomAgreementView *agreementView;

- (instancetype)initWithLoginStyle:(NSArray<NSString *> *)loginStyle
                  verifyCodeLength:(NSInteger)verifyCodeLength
                       loginForced:(BOOL)loginForced;

@end

NS_ASSUME_NONNULL_END
