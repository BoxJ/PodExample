//
//  JMBoomQuickLoginModalView.h
//  JMBoomSDK
//
//  Created by Thief Toki on 2020/8/4.
//

#import <JMUIKit/JMUIKit.h>

#import "JMBoomAgreementView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomQuickLoginModalView : JMModalView

@property (nonatomic, strong) NSArray<NSString *> *loginStyle;
@property (nonatomic, strong, nullable) NSString *number;
@property (nonatomic, strong, nullable) NSString *operatorName;
@property (nonatomic, strong, nullable) NSString *protocolName;
@property (nonatomic, strong, nullable) NSString *protocolUrl;
@property (nonatomic, assign) NSInteger verifyCodeLength;
@property (nonatomic, assign) BOOL loginForced;

@property (nonatomic, strong) UILabel *phoneNumberLabel;
@property (nonatomic, strong) UILabel *operatorLabel;
@property (nonatomic, strong) JMCommonButton *loginButton;
@property (nonatomic, strong) JMCrispButton *otherSchemeButton;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) JMBoomAgreementView *agreementView;

- (instancetype)initWithLoginStyle:(NSArray<NSString *> *)loginStyle
                            number:(NSString *)number
                      operatorName:(NSString *)operatorName
                      protocolName:(NSString *)protocolName
                       protocolUrl:(NSString *)protocolUrl
                  verifyCodeLength:(NSInteger)verifyCodeLength
                       loginForced:(BOOL)loginForced;

@end

NS_ASSUME_NONNULL_END
