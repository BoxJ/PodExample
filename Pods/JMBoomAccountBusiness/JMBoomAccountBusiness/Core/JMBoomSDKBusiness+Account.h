//
//  JMBoomSDKBusiness+Account.h
//  JMBoomSDK
//
//  Created by Thief Toki on 2021/2/4.
//

#import <JMBoomSDKBase/JMBoomSDKBase.h>

#import "JMBoomVerificationType.h"

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomSDKBusiness (Account)

#pragma mark - 登录

/// 自动登录
/// @param callback 回调
- (void)loginWithCallback:(JMBusinessCallback)callback;

/// 一键登录
/// @param callback 回调
- (void)quickLoginWithCallback:(JMBusinessCallback)callback;

/// 手机号登录
/// @param phoneNumber 手机号
/// @param verificationCode 验证码
/// @param callback 回调
- (void)phoneLoginWithPhoneNumber:(NSString *)phoneNumber
                 verificationCode:(NSString *)verificationCode
                         callback:(JMBusinessCallback)callback;

/// 游客登录
/// @param callback 回调
- (void)guestLoginWithCallback:(JMBusinessCallback)callback;

/// 登录中断后，继续登录
/// @param traceId 中断的登录的操作Id，在回调内容查看
/// @param traceType 中断的登录操作类型，暂时没用
- (void)loginContinueWithTraceId:(NSString *)traceId
                       traceType:(NSInteger)traceType
                        callback:(JMBusinessCallback)callback;

#pragma mark - 绑定手机号

/// 游客一键转正
- (void)quickGuestBoundWithCallback:(JMBusinessCallback)callback;

/// 游客转正
/// @param phoneNumber 手机号
/// @param verificationCode 验证码
/// @param callback 回调
- (void)guestBoundWithPhoneNumber:(NSString *)phoneNumber
                 verificationCode:(NSString *)verificationCode
                         callback:(JMBusinessCallback)callback;

#pragma mark - 换绑

///换绑手机号验证
/// @param callback 回调
- (void)phoneChangeVerifyWithCallback:(JMBusinessCallback)callback;

///账号迁移验证
/// @param callback 回调
- (void)accountChangeVerifyWithCallback:(JMBusinessCallback)callback;

#pragma mark - 登出

///登出
- (void)logout;

#pragma mark - 注销

/// 账号注销前的账号信息验证
/// @param waitingDays 冷静期，账号实际注销需要等待的时间
/// @param callback 回调
- (void)accountClosingCheckWaitingDays:(NSUInteger)waitingDays
                              callback:(JMBusinessCallback)callback;

/// 账号注销前的用户身份信息验证
/// @param idCardNumber 身份证号
/// @param callback 回调
- (void)accountClosingCheckIdCardNumber:(NSString *)idCardNumber
                               callback:(JMBusinessCallback)callback;

/// 账号注销前的请求验证码
/// @param phoneNumber 手机号
/// @param callback 回调
- (void)accountClosingSendVerificationCode:(NSString *)phoneNumber
                                  callback:(JMBusinessCallback)callback;

/// 账号注销前的手机号身份验证
/// @param phoneNumber 手机号
/// @param verificationCode 验证码
/// @param callback 回调
- (void)accountClosingCheckPhoneNumber:(NSString *)phoneNumber
                      verificationCode:(NSString *)verificationCode
                              callback:(JMBusinessCallback)callback;

/// 账号注销启动
/// @param accept 用户确认，若用户未确认则取消注销行为
/// @param callback 回调
- (void)accountClosingComplete:(BOOL)accept
                      callback:(JMBusinessCallback)callback;

#pragma mark - 通用

///获取用户信息
- (void)userInfoWithCallback:(JMBusinessCallback)callback;

///获取手机号信息
- (void)phoneInfoWithCallback:(JMBusinessCallback)callback;

/// 获取验证码
/// @param phoneNumber 手机号
/// @param codeVerificationType 验证码类型 默认0, 换绑1, 注销账号2
/// @param callback 回调
- (void)verificationCodeWithPhoneNumber:(NSString *)phoneNumber
                   codeVerificationType:(NSInteger)codeVerificationType
                               callback:(JMBusinessCallback)callback;

/// 获取验证码
/// @param phoneNumber 手机号
/// @param verificationType 验证码使用场景
/// @param callback 回调
- (void)verificationCodeWithPhoneNumber:(NSString *)phoneNumber
                       verificationType:(JMBoomVerificationType)verificationType
                               callback:(JMBusinessCallback)callback;

@end

NS_ASSUME_NONNULL_END
