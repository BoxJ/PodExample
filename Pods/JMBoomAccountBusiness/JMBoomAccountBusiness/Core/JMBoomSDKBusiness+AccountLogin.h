//
//  JMBoomSDKBusiness+AccountLogin.h
//  JMBoomSDK
//
//  Created by Thief Toki on 2021/2/5.
//

#import <JMBoomSDKBase/JMBoomSDKBase.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomSDKBusiness (AccountLogin)

- (void)guestLoginWithAntiAddictionCallback:(JMBusinessCallback)callback;

- (void)quickLoginWithAntiAddictionCallback:(JMBusinessCallback)callback;

- (void)loginWithAntiAddictionCallback:(JMBusinessCallback)callback;

- (void)phoneLoginWithPhoneNumber:(NSString *)phoneNumber
                 verificationCode:(NSString *)verificationCode
            antiAddictionCallback:(JMBusinessCallback)callback;

@end

NS_ASSUME_NONNULL_END
