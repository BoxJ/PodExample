//
//  JMBoomSDKRequest+JMBoomAccountBusiness.h
//  JMBoomAccountBusiness
//
//  Created by ZhengXianda on 11/02/2022.
//  Copyright (c) 2022 ZhengXianda. All rights reserved.
//

#import <JMBoomSDKBase/JMBoomSDKBase.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomSDKRequest (JMBoomAccountBusiness)

#pragma mark - login

- (void)quickLoginWithToken:(NSString *)token
                   callback:(JMRequestCallback)callback;

- (void)guestLoginWithCallback:(JMRequestCallback)callback;

- (void)loginWithCallback:(JMRequestCallback)callback;

- (void)phoneLoginWithPhoneNumber:(NSString *)phoneNumber
                 verificationCode:(NSString *)verificationCode
                         callback:(JMRequestCallback)callback;

- (void)loginContinueWithTraceId:(NSString *)traceId
                       traceType:(NSInteger)traceType
                        callback:(JMRequestCallback)callback;

#pragma mark - bound

- (void)guestBoundWithPhoneNumber:(NSString *)phoneNumber
                 verificationCode:(NSString *)verificationCode
                         callback:(JMRequestCallback)callback;

- (void)guestBoundWithToken:(NSString *)token
                   callback:(JMRequestCallback)callback;


#pragma mark - userInfo

- (void)userInfoWithCallback:(JMRequestCallback)callback;

- (void)guestIdCheckWithCallback:(JMRequestCallback)callback;

- (void)phoneChangeVerifyWithCallback:(JMRequestCallback)callback;

- (void)accountChangeVerifyWithCallback:(JMRequestCallback)callback;

#pragma mark - account closing

- (void)accountClosingWithCallback:(JMRequestCallback)callback;

- (void)accountClosingCheckWaitingDays:(NSUInteger)waitingDays
                              callback:(JMRequestCallback)callback;

- (void)accountClosingCheckIdCardNumber:(NSString *)idCardNumber
                               callback:(JMRequestCallback)callback;

- (void)accountClosingCheckPhoneNumber:(NSString *)phoneNumber
                              callback:(JMRequestCallback)callback;

- (void)accountClosingCheckPhoneNumber:(NSString *)phoneNumber
                      verificationCode:(NSString *)verificationCode
                              callback:(JMRequestCallback)callback;

- (void)accountClosingComplete:(BOOL)accept
                      callback:(JMRequestCallback)callback;

#pragma mark - util

- (void)verificationCodeWithPhoneNumber:(NSString *)phoneNumber
                   codeVerificationType:(NSInteger)codeVerificationType
                               callback:(JMRequestCallback)callback;

@end

NS_ASSUME_NONNULL_END
