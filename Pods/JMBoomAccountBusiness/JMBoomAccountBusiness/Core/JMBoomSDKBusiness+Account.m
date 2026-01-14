//
//  JMBoomSDKBusiness+Account.m
//  JMBoomSDK
//
//  Created by Thief Toki on 2021/2/4.
//

#import "JMBoomSDKBusiness+Account.h"

#import "JMBoomCLManager.h"

#import "JMBoomAccountBusinessMock.h"

#import "JMBoomSDKRequest+JMBoomAccountBusiness.h"

typedef NS_ENUM(NSUInteger, JMBoomAccountLoginMode) {
    JMBoomAccountLoginMode_Phone = 0,
    JMBoomAccountLoginMode_CL = 1,
    JMBoomAccountLoginMode_Guest = 2,
    JMBoomAccountLoginMode_Auto = 3,
    JMBoomAccountLoginMode_AbortAccountClosing = 4,
};

@implementation JMBoomSDKBusiness (Account)

#pragma mark - 登录

/// 自动登录
/// @param callback 回调
- (void)loginWithCallback:(JMBusinessCallback)callback {
    __weak typeof(self) weakSelf = self;
    [JMBoomSDKBusiness.request loginWithCallback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            [weakSelf loginFailed:error mode:JMBoomAccountLoginMode_Auto callback:callback];
        } else {
            [weakSelf loginSuccess:responseObject mode:JMBoomAccountLoginMode_Auto callback:callback];
        }
    }];
}

/// 一键登录
/// @param callback 回调
- (void)quickLoginWithCallback:(JMBusinessCallback)callback {
    __weak typeof(self) weakSelf = self;
    [[JMBoomCLManager shared] loginAuthWithEventCallback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            callback(responseObject, error);
        } else {
            [JMBoomSDKBusiness.request quickLoginWithToken:[JMBoomCLManager shared].token
                                                      callback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
                if (error) {
                    [weakSelf loginFailed:error mode:JMBoomAccountLoginMode_CL callback:callback];
                } else {
                    [weakSelf loginSuccess:responseObject mode:JMBoomAccountLoginMode_CL callback:callback];
                }
                
            }];
        }
    }];
}

/// 手机号登录
/// @param phoneNumber 手机号
/// @param verificationCode 验证码
/// @param callback 回调
- (void)phoneLoginWithPhoneNumber:(NSString *)phoneNumber
                 verificationCode:(NSString *)verificationCode
                         callback:(JMBusinessCallback)callback {
    __weak typeof(self) weakSelf = self;
    [JMBoomSDKBusiness.request phoneLoginWithPhoneNumber:phoneNumber
                                            verificationCode:verificationCode
                                                    callback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            [weakSelf loginFailed:error mode:JMBoomAccountLoginMode_Phone callback:callback];
        } else {
            [weakSelf loginSuccess:responseObject mode:JMBoomAccountLoginMode_Phone callback:callback];
        }
    }];
}

/// 游客登录
/// @param callback 回调
- (void)guestLoginWithCallback:(JMBusinessCallback)callback {
    __weak typeof(self) weakSelf = self;
    [JMBoomSDKBusiness.request guestIdCheckWithCallback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            [weakSelf loginFailed:error mode:JMBoomAccountLoginMode_Guest callback:callback];
        } else {
            [JMBoomSDKBusiness.info extractUniqueIdCheckResponseObject:responseObject];
            [weakSelf guestLoginAfterCheckWithCallback:callback];
        }
    }];
}

- (void)loginContinueWithTraceId:(NSString *)traceId
                       traceType:(NSInteger)traceType
                        callback:(JMBusinessCallback)callback {
    __weak typeof(self) weakSelf = self;
    [JMBoomSDKBusiness.request loginContinueWithTraceId:traceId
                                           traceType:traceType
                                            callback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            [weakSelf loginFailed:error mode:JMBoomAccountLoginMode_AbortAccountClosing callback:callback];
        } else {
            [weakSelf loginSuccess:responseObject mode:JMBoomAccountLoginMode_AbortAccountClosing callback:callback];
        }
    }];
}

#pragma mark - 绑定手机号

/// 游客一键转正
- (void)quickGuestBoundWithCallback:(JMBusinessCallback)callback {
    __weak typeof(self) weakSelf = self;
    [[JMBoomCLManager shared] loginAuthWithEventCallback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            [JMBoomSDKBusiness.event uploadEvent:[JMBoomSDKEventItem event:JMBoomSDKEventId_Binding_Code_Wrong
                                                                         exStrs:@[@"1"]
                                                       error:error]];
            JMLog(@"JMBoom Event = JMBoomSDKEventId_Binding_Code_Wrong:1");
            
            callback(responseObject, error);
        } else {
            [JMBoomSDKBusiness.request guestBoundWithToken:[JMBoomCLManager shared].token
                                                      callback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
                if (error) {
                    [JMBoomSDKBusiness.event uploadEvent:[JMBoomSDKEventItem event:JMBoomSDKEventId_Binding_Code_Wrong
                                                                                 exStrs:@[@"1"]
                                                               error:error]];
                    JMLog(@"JMBoom Event = JMBoomSDKEventId_Binding_Code_Wrong:1");
                    callback(responseObject, error);
                } else {
                    [JMBoomSDKBusiness.event uploadEvent:[JMBoomSDKEventItem event:JMBoomSDKEventId_Bound_Successed exStrs:@[@"1"]]];
                    JMLog(@"JMBoom Event = JMBoomSDKEventId_Bound_Successed:1");
                    
                    [weakSelf boundSuccess:responseObject callback:callback];
                }
            }];
        }
    }];
}

/// 游客转正
/// @param phoneNumber 手机号
/// @param verificationCode 验证码
/// @param callback 回调
- (void)guestBoundWithPhoneNumber:(NSString *)phoneNumber
                 verificationCode:(NSString *)verificationCode
                         callback:(JMBusinessCallback)callback {
    __weak typeof(self) weakSelf = self;
    [JMBoomSDKBusiness.request guestBoundWithPhoneNumber:phoneNumber
                                            verificationCode:verificationCode
                                                    callback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            [JMBoomSDKBusiness.event uploadEvent:[JMBoomSDKEventItem event:JMBoomSDKEventId_Binding_Code_Wrong exStrs:@[@"0"]
                                                       error:error]];
            JMLog(@"JMBoom Event = JMBoomSDKEventId_Binding_Code_Wrong:0");
            callback(responseObject, error);
        } else {
            [JMBoomSDKBusiness.event uploadEvent:[JMBoomSDKEventItem event:JMBoomSDKEventId_Bound_Successed exStrs:@[@"0"]]];
            JMLog(@"JMBoom Event = JMBoomSDKEventId_Bound_Successed:0");
            
            [weakSelf boundSuccess:responseObject callback:callback];
        }
    }];
}

#pragma mark - 换绑

///换绑手机号验证
/// @param callback 回调
- (void)phoneChangeVerifyWithCallback:(JMBusinessCallback)callback {
    [JMBoomSDKBusiness.request phoneChangeVerifyWithCallback:callback];
}

///账号迁移验证
/// @param callback 回调
- (void)accountChangeVerifyWithCallback:(JMBusinessCallback)callback {
    [JMBoomSDKBusiness.request accountChangeVerifyWithCallback:callback];
}

#pragma mark - 登出

///登出
- (void)logout {
    [JMBoomSDKBusiness.info clearExtendInfo];
    [JMBoomSDKBusiness.info resetLoginInfo];
    [[JMBoomSDKBusiness shared] antiAddictionCountingPause];
    [[JMBoomSDKBusiness qiYuCustomer] logOut];
}

#pragma mark - 注销

/// 账号注销前的账号信息验证
/// @param waitingDays 冷静期，账号实际注销需要等待的时间
/// @param callback 回调
- (void)accountClosingCheckWaitingDays:(NSUInteger)waitingDays
                              callback:(JMBusinessCallback)callback {
    [JMBoomSDKBusiness.request accountClosingCheckWaitingDays:waitingDays
                                                  callback:callback];
}
/// 账号注销前的用户身份信息验证
/// @param idCardNumber 身份证号
/// @param callback 回调
- (void)accountClosingCheckIdCardNumber:(NSString *)idCardNumber
                               callback:(JMBusinessCallback)callback {
    [JMBoomSDKBusiness.request accountClosingCheckIdCardNumber:idCardNumber
                                                   callback:callback];
}

/// 账号注销前的请求验证码
/// @param phoneNumber 手机号
/// @param callback 回调
- (void)accountClosingSendVerificationCode:(NSString *)phoneNumber
                                  callback:(JMBusinessCallback)callback {
    __weak typeof(self) weakSelf = self;
    [JMBoomSDKBusiness.request accountClosingCheckPhoneNumber:phoneNumber
                                                  callback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            callback([error responseValue], error);
        } else {
            [weakSelf verificationCodeWithPhoneNumber:phoneNumber
                                     verificationType:JMBoomVerificationType_Destroy
                                             callback:callback];
        }
    }];
}

/// 账号注销前的手机号身份验证
/// @param phoneNumber 手机号
/// @param verificationCode 验证码
/// @param callback 回调
- (void)accountClosingCheckPhoneNumber:(NSString *)phoneNumber
                      verificationCode:(NSString *)verificationCode
                              callback:(JMBusinessCallback)callback {
    [JMBoomSDKBusiness.request accountClosingCheckPhoneNumber:phoneNumber
                                          verificationCode:verificationCode
                                                  callback:callback];
}

/// 账号注销启动
/// @param accept 用户确认，若用户未确认则取消注销行为
/// @param callback 回调
- (void)accountClosingComplete:(BOOL)accept
                      callback:(JMBusinessCallback)callback {
    [JMBoomSDKBusiness.request accountClosingComplete:accept
                                          callback:callback];
}

#pragma mark - 通用

///获取用户信息
- (void)userInfoWithCallback:(JMBusinessCallback)callback {
    [JMBoomSDKBusiness.request userInfoWithCallback:callback];
}

///获取手机号信息
- (void)phoneInfoWithCallback:(JMBusinessCallback)callback {
    [[JMBoomCLManager shared] getPhoneNumberWithEventCallback:callback];
}

/// 获取验证码
/// @param phoneNumber 手机号
/// @param codeVerificationType 验证码类型 默认0, 换绑1, 注销账号2
/// @param callback 回调
- (void)verificationCodeWithPhoneNumber:(NSString *)phoneNumber
                   codeVerificationType:(NSInteger)codeVerificationType
                               callback:(JMBusinessCallback)callback {
    [JMBoomSDKBusiness.request verificationCodeWithPhoneNumber:phoneNumber
                                       codeVerificationType:codeVerificationType
                                                   callback:callback];
}

/// 获取验证码
/// @param phoneNumber 手机号
/// @param verificationType 验证码使用场景
/// @param callback 回调
- (void)verificationCodeWithPhoneNumber:(NSString *)phoneNumber
                       verificationType:(JMBoomVerificationType)verificationType
                               callback:(JMBusinessCallback)callback {
    NSInteger codeVerificationType;
    switch (verificationType) {
        case JMBoomVerificationType_Login:
        case JMBoomVerificationType_Bound:
            codeVerificationType = 0;
            break;
        case JMBoomVerificationType_Change:
            codeVerificationType = 1;
            break;
        case JMBoomVerificationType_Destroy:
            codeVerificationType = 2;
            break;
    }
    
    [self verificationCodeWithPhoneNumber:phoneNumber
                     codeVerificationType:codeVerificationType
                                 callback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        switch (verificationType) {
            case JMBoomVerificationType_Login: {
                if (error) {
                    [JMBoomSDKBusiness.event uploadEvent:[JMBoomSDKEventItem event:JMBoomSDKEventId_Login_Code_Failed exStrs:@[@"0"]]];
                    JMLog(@"JMBoom Event = JMBoomSDKEventId_Login_Code_Failed:0");
                } else {
                    [JMBoomSDKBusiness.event uploadEvent:[JMBoomSDKEventItem event:JMBoomSDKEventId_Login_Code_Successed exStrs:@[@"0"]]];
                    JMLog(@"JMBoom Event = JMBoomSDKEventId_Login_Code_Successed:0");
                }
            }
                break;
            case JMBoomVerificationType_Bound: {
                if (error) {
                    [JMBoomSDKBusiness.event uploadEvent:[JMBoomSDKEventItem event:JMBoomSDKEventId_Login_Code_Failed exStrs:@[@"1"]]];
                    JMLog(@"JMBoom Event = JMBoomSDKEventId_Login_Code_Failed:1");
                } else {
                    [JMBoomSDKBusiness.event uploadEvent:[JMBoomSDKEventItem event:JMBoomSDKEventId_Login_Code_Successed exStrs:@[@"1"]]];
                    JMLog(@"JMBoom Event = JMBoomSDKEventId_Login_Code_Successed:1");
                }
            }
                break;
            case JMBoomVerificationType_Change: {
                
            }
            case JMBoomVerificationType_Destroy: {
                
            }
                break;
        }
        callback(responseObject, error);
    }];
}

- (void)loginFailed:(NSError *)error mode:(JMBoomAccountLoginMode)mode callback:(JMBusinessCallback)callback {
    NSString *exStr1 = [@(mode) stringValue];
    JMLog(@"JMBoom Event = JMBoomSDKEventId_Login_Failed:%@", exStr1);
    [JMBoomSDKBusiness.event uploadEvent:[JMBoomSDKEventItem event:JMBoomSDKEventId_Login_Failed exStrs:@[exStr1]
                                               error:error]];
    callback([error responseValue], error);
}

- (void)loginSuccess:(NSDictionary *)loginResponse mode:(JMBoomAccountLoginMode)mode callback:(JMBusinessCallback)callback {
    //解析登录成功的数据
    [JMBoomSDKBusiness.info extractLoginResponseObject:loginResponse];
    __weak typeof(self) weakSelf = self;
    [JMBoomSDKBusiness.request userInfoWithCallback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            [weakSelf loginFailed:error mode:mode callback:callback];
        } else {
            //解析响应数据
            [JMBoomSDKBusiness.info extractUserInfoResponseObject:responseObject];
            
            NSInteger eventId = JMBoomSDKBusiness.info.isRegister ? JMBoomSDKEventId_Register_Successed : JMBoomSDKEventId_Login_Successed;
            NSString *exStr1 = [@(mode) stringValue];
            JMLog(@"JMBoom Event = %@:%@",
                  (JMBoomSDKBusiness.info.isRegister ?
                   @"JMBoomSDKEventId_Register_Successed" :
                   @"JMBoomSDKEventId_Login_Successed"),
                  exStr1);
            [JMBoomSDKBusiness.event uploadEvent:[JMBoomSDKEventItem event:eventId exStrs:@[exStr1]]];
            
            callback(loginResponse, nil);
        }
    }];
    if (JMBoomSDKBusiness.config.qiyuCustomerSwitch && JMBoomSDKBusiness.info.openId.length) {
        [[JMBoomSDKBusiness qiYuCustomer] setUserId:JMBoomSDKBusiness.info.openId];
    }
}

- (void)guestLoginAfterCheckWithCallback:(JMBusinessCallback)callback {
    __weak typeof(self) weakSelf = self;
    [JMBoomSDKBusiness.request guestLoginWithCallback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            [weakSelf loginFailed:error mode:JMBoomAccountLoginMode_Guest callback:callback];
        } else {
            [weakSelf loginSuccess:responseObject mode:JMBoomAccountLoginMode_Guest callback:callback];
        }
    }];
}

- (void)boundSuccess:(NSDictionary *)boundResponse callback:(JMBusinessCallback)callback {
    //解析登录成功的数据
    [JMBoomSDKBusiness.request userInfoWithCallback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            [JMBoomSDKBusiness.event uploadEvent:[JMBoomSDKEventItem event:JMBoomSDKEventId_Login_Failed
                                                       error:error]];
            callback(responseObject, error);
        } else {
            //解析响应数据
            [JMBoomSDKBusiness.info extractUserInfoResponseObject:responseObject];
            
            [JMBoomSDKBusiness.event uploadEvent:[JMBoomSDKEventItem event:JMBoomSDKEventId_Login_Successed]];
            
            callback(boundResponse, nil);
        }
    }];
}

@end
