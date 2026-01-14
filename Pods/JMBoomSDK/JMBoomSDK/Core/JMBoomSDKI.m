//
//  JMBoomSDK.m
//  JMBoomSDK
//
//  Created by ZhengXianda on 10/31/2022.
//  Copyright (c) 2022 ZhengXianda. All rights reserved.
//

#import "JMBoomSDK.h"

#import "JMBoomSDKBusiness.h"

#import <JMUtils/JMUtils.h>
#import <JMRktCommon/JMRktCommon.h>
#import <JMBoomInitializeBusiness/JMBoomInitializeBusiness.h>
#import <JMBoomAccountBusiness/JMBoomAccountBusiness.h>
#import <JMBoomAntiAddictionBusiness/JMBoomAntiAddictionBusiness.h>
#import <JMBoomRealNameBusiness/JMBoomRealNameBusiness.h>
#import <JMBoomRechargeBusiness/JMBoomRechargeBusiness.h>

@implementation JMBoomSDKI

+ (void)showSDKInfo {
    NSString *info = [NSString stringWithFormat:@"[JMBoomSDK %@ Version: %@]", JMBoomSDKConfig.environment, JMBoomSDKConfig.version];
    printf("\n");
    for (int i = 0; i < info.length; i++) printf("-");
    printf("\n%s\n", info.UTF8String);
    for (int i = 0; i < info.length; i++) printf("-");
    printf("\n");
}

#pragma mark - shared

+ (instancetype)shared {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+ (void)debug:(BOOL)isDebug {
    [JMLogger shared].isEnable = isDebug;
}

#pragma mark - 初始化

- (void)registerShadowApp:(NSString *)appId
                secretKey:(NSString *)secretKey
                 callback:(JMBoomSDKCallback)callback {
    [self registerShadowApp:appId
                  secretKey:secretKey
                hasTracking:NO
                   callback:callback];
}

- (void)registerShadowApp:(NSString *)appId
                secretKey:(NSString *)secretKey
              hasTracking:(BOOL)hasTracking
                 callback:(JMBoomSDKCallback)callback {
    JMBoomSDKBusiness.config.isShadowMode = YES;
    
    [[JMBoomSDKBusiness shared] initializeApp:appId
                               secretKey:secretKey
                             hasTracking:hasTracking
                                callback:callback];
}

- (void)registerApp:(NSString *)appId
          secretKey:(NSString *)secretKey
           callback:(JMBoomSDKCallback)callback {
    [self registerApp:appId
            secretKey:secretKey
          hasTracking:NO
             callback:callback];
}

- (void)registerApp:(NSString *)appId
          secretKey:(NSString *)secretKey
        hasTracking:(BOOL)hasTracking
           callback:(JMBoomSDKCallback)callback {
    JMBoomSDKBusiness.config.isShadowMode = NO;
    
    [[JMBoomSDKBusiness shared] initializeApp:appId
                               secretKey:secretKey
                             hasTracking:hasTracking
                                callback:callback];
}

- (void)subscribeNotification:(JMBoomSDKCallback)callback {
    [[JMRktBroadcaster shared] subscribeWithCallback:callback];
}

#pragma mark - 实名模块

- (void)identityStatusWithCallback:(JMBoomSDKCallback)callback {
    [[JMBoomSDKBusiness shared] identityStatusWithCallback:callback];
}

- (void)identityVerifyWithIdCardNumber:(NSString *)idCardNumber
                              realName:(NSString *)realName
                              callback:(JMBoomSDKCallback)callback {
    [[JMBoomSDKBusiness shared] identityVerifyWithIdCardNumber:idCardNumber
                                             realName:realName
                                             callback:callback];
}

#pragma mark - 充值模块

- (void)rechargeLimitCheckWithAmount:(int32_t)amount
                            callback:(JMBoomSDKCallback)callback {
    [[JMBoomSDKBusiness shared] rechargeLimitCheckWithAmount:amount
                                           callback:callback];
}

- (void)rechargeWithOrderNo:(NSString *)orderNo
                  productId:(NSString *)productId
                    subject:(NSString *)subject
                       body:(NSString *)body
                     amount:(int32_t)amount
                   callback:(JMBoomSDKCallback)callback {
    [[JMBoomSDKBusiness shared] rechargeWithOrderNo:orderNo
                                 productId:productId
                                   subject:subject
                                      body:body
                                    amount:amount
                                  callback:callback];
}

#pragma mark - 账号模块

#pragma mark 登录

/// 自动登录
/// @param callback 回调
- (void)loginWithCallback:(JMBoomSDKCallback)callback {
    [[JMBoomSDKBusiness shared] loginWithCallback:callback];
}

/// 一键登录
/// @param callback 回调
- (void)quickLoginWithCallback:(JMBoomSDKCallback)callback {
    [[JMBoomSDKBusiness shared] quickLoginWithCallback:callback];
}

/// 手机号登录
/// @param phoneNumber 手机号
/// @param verificationCode 验证码
/// @param callback 回调
- (void)phoneLoginWithPhoneNumber:(NSString *)phoneNumber
                 verificationCode:(NSString *)verificationCode
                         callback:(JMBoomSDKCallback)callback {
    [[JMBoomSDKBusiness shared] phoneLoginWithPhoneNumber:phoneNumber
                                verificationCode:verificationCode
                                        callback:callback];
}

/// 游客登录
/// @param callback 回调
- (void)guestLoginWithCallback:(JMBoomSDKCallback)callback {
    [[JMBoomSDKBusiness shared] guestLoginWithCallback:callback];
}

/// 登录中断后，继续登录
/// @param traceId 中断的登录的操作Id，在回调内容查看
/// @param traceType 中断的登录操作类型，暂时没用
/// @param callback 回调
- (void)loginContinueWithTraceId:(NSString *)traceId
                       traceType:(NSInteger)traceType
                        callback:(JMBoomSDKCallback)callback {
    [[JMBoomSDKBusiness shared] loginContinueWithTraceId:traceId
                                          traceType:traceType
                                           callback:callback];
}

#pragma mark 绑定手机号

/// 游客一键转正
- (void)quickGuestBoundWithCallback:(JMBoomSDKCallback)callback {
    [[JMBoomSDKBusiness shared] quickGuestBoundWithCallback:callback];
}

/// 游客转正
/// @param phoneNumber 手机号
/// @param verificationCode 验证码
/// @param callback 回调
- (void)guestBoundWithPhoneNumber:(NSString *)phoneNumber
                 verificationCode:(NSString *)verificationCode
                         callback:(JMBoomSDKCallback)callback {
    [[JMBoomSDKBusiness shared] guestBoundWithPhoneNumber:phoneNumber
                                verificationCode:verificationCode
                                        callback:callback];
}

#pragma mark 换绑

- (void)phoneChangeWithCallback:(JMBoomSDKCallback)callback {
    [[JMBoomSDKBusiness shared] phoneChangeWithCallback:callback];
}

/// 账号迁移
/// @param callback 回调
- (void)accountChangeWithCallback:(JMBoomSDKCallback)callback {
    [[JMBoomSDKBusiness shared] accountChangeWithCallback:callback];
}

#pragma mark 登出

///登出
- (void)logout {
    [[JMBoomSDKBusiness shared] logout];
}

#pragma mark 注销

/// 账号注销前的账号信息验证
/// @param waitingDays 冷静期，账号实际注销需要等待的时间
/// @param callback 回调
- (void)accountClosingCheckWaitingDays:(NSUInteger)waitingDays
                              callback:(JMBoomSDKCallback)callback {
    [[JMBoomSDKBusiness shared] accountClosingCheckWaitingDays:waitingDays
                                                 callback:callback];
}

/// 账号注销前的用户身份信息验证
/// @param idCardNumber 身份证号
/// @param callback 回调
- (void)accountClosingCheckIdCardNumber:(NSString *)idCardNumber
                               callback:(JMBoomSDKCallback)callback {
    [[JMBoomSDKBusiness shared] accountClosingCheckIdCardNumber:idCardNumber
                                                  callback:callback];
}

/// 账号注销前的请求验证码
/// @param phoneNumber 手机号
/// @param callback 回调
- (void)accountClosingSendVerificationCode:(NSString *)phoneNumber
                                  callback:(JMBoomSDKCallback)callback {
    [[JMBoomSDKBusiness shared] accountClosingSendVerificationCode:phoneNumber
                                                     callback:callback];
}

/// 账号注销前的手机号身份验证
/// @param phoneNumber 手机号
/// @param verificationCode 验证码
/// @param callback 回调
- (void)accountClosingCheckPhoneNumber:(NSString *)phoneNumber
                      verificationCode:(NSString *)verificationCode
                              callback:(JMBoomSDKCallback)callback {
    [[JMBoomSDKBusiness shared] accountClosingCheckPhoneNumber:phoneNumber
                                         verificationCode:verificationCode
                                                 callback:callback];
}

/// 账号注销启动
/// @param accept 用户确认，若用户未确认则取消注销行为
/// @param callback 回调
- (void)accountClosingComplete:(BOOL)accept
                      callback:(JMBoomSDKCallback)callback {
    [[JMBoomSDKBusiness shared] accountClosingComplete:accept
                                         callback:callback];
}

#pragma mark - 通用

/// 上传角色信息
/// @param ext 附加内容
/// @param callback 回调
- (void)uploadChapter:(NSString * _Nullable)chapter
            guildName:(NSString * _Nullable)guildName
          roleBalance:(NSString * _Nullable)roleBalance
               roleId:(NSString * _Nullable)roleId
               roleLv:(NSString * _Nullable)roleLv
             roleName:(NSString * _Nullable)roleName
            rolePower:(NSString * _Nullable)rolePower
            serverId:(NSString * _Nullable)serverId
          serverName:(NSString * _Nullable)serverName
                vipLv:(NSString * _Nullable)vipLv
                  ext:(NSDictionary * _Nullable)ext
             callback:(JMBoomSDKCallback)callback {
    [[JMBoomSDKBusiness shared] uploadChapter:chapter
                               guildName:guildName
                             roleBalance:roleBalance
                                  roleId:roleId
                                  roleLv:roleLv
                                roleName:roleName
                               rolePower:rolePower
                               serviceId:serverId
                             serviceName:serverName
                                   vipLv:vipLv
                                     ext:ext
                                callback:callback];
}

///获取用户信息
- (void)userInfoWithCallback:(JMBoomSDKCallback)callback {
    [[JMBoomSDKBusiness shared] userInfoWithCallback:callback];
}

///获取手机号信息
- (void)phoneInfoWithCallback:(JMBoomSDKCallback)callback {
    [[JMBoomSDKBusiness shared] phoneInfoWithCallback:callback];
}

- (void)verificationCodeWithPhoneNumber:(NSString *)phoneNumber
                               callback:(JMBoomSDKCallback)callback {
    [[JMBoomSDKBusiness shared] verificationCodeWithPhoneNumber:phoneNumber
                                      codeVerificationType:0
                                                  callback:callback];
}

#pragma mark - 防沉迷模块

/// 检查用户剩余时长
/// @param callback 回调
- (void)antiAddictionRemainWithCallback:(JMBoomSDKCallback)callback {
    [[JMBoomSDKBusiness shared] antiAddictionRemainWithCallback:callback];
}

/// 开启登录时长统计
- (void)antiAddictionCounting {
    //开启心跳
    [[JMBoomSDKBusiness shared] antiAddictionCountingWithCallback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        //游戏中，提示cp端
        if (error) [[JMRktBroadcaster shared] sendError:error];
    }];
}

#pragma mark - 七鱼客服

-(void)initQiYuCustomerWithAppKey:(NSString *)appKey appName:(NSString *)appName  groupId:(nullable NSString *)groupId staffId:(nullable NSString *)staffId callback:(JMBoomSDKCallback)callback
{
    [[JMBoomSDKBusiness qiYuCustomer] initWithAppKey:appKey appName:appName groupId:groupId staffId:staffId completion:^(BOOL success, NSError *error) {
        if (success) {
            NSDictionary *response = @{
                @"code": @0, //固定不变,客户端用不到
                @"message": @"成功", //固定不变,客户端用不到
                @"traceId": @"", //固定不变,客户端用不到
                @"result":@1
            };
            callback(response,nil);
        } else if (error) {
            callback(error.responseValue,error);
        } else {
            NSError *errorR = [NSError
                              errorWithDomain:NSStringFromClass([JMQiYuCustomer class])
                              code:-1
                              userInfo:@{
                                 NSLocalizedDescriptionKey: @"未知错误"
                              }
            ];
            callback(errorR.responseValue,errorR);
        }
    }];
}

-(void)setQiYuGameUserID:(NSString *)userId avatar:(nullable NSString *)avatarUrl callback:(JMBoomSDKCallback)callback
{
    [[JMBoomSDKBusiness qiYuCustomer] setAccountId:userId avatar:avatarUrl completion:^(BOOL success, NSError *error) {
        if (success) {
            NSDictionary *response = @{
                @"code": @0, //固定不变,客户端用不到
                @"message": @"成功", //固定不变,客户端用不到
                @"traceId": @"", //固定不变,客户端用不到
                @"result":@1
            };
            callback(response,nil);
        } else if (error) {
            callback(error.responseValue,error);
        } else {
            NSError *errorR = [NSError
                              errorWithDomain:NSStringFromClass([JMQiYuCustomer class])
                              code:-1
                              userInfo:@{
                                 NSLocalizedDescriptionKey: @"未知错误"
                              }
            ];
            callback(errorR.responseValue,errorR);
        }
    }];
}

-(void)openQiYuCustomerSessionWithCallback:(JMBoomSDKCallback)callback
{
    [[JMBoomSDKBusiness qiYuCustomer] openCustomerSessionWithCompletion:^(BOOL success, NSError *error) {
        if (success) {
            NSDictionary *response = @{
                @"code": @0, //固定不变,客户端用不到
                @"message": @"成功", //固定不变,客户端用不到
                @"traceId": @"", //固定不变,客户端用不到
                @"result":@1
            };
            callback(response,nil);
        } else if (error) {
            callback(error.responseValue,error);
        } else {
            NSError *errorR = [NSError
                              errorWithDomain:NSStringFromClass([JMQiYuCustomer class])
                              code:-1
                              userInfo:@{
                                 NSLocalizedDescriptionKey: @"未知错误"
                              }
            ];
            callback(errorR.responseValue,errorR);
        }
    }];
}
-(void)openCustomerSessionWithAccountID:(nullable NSString *)accountId avatar:(nullable NSString *)avatarUrl callback:(JMBoomSDKCallback)callback
{
    [[JMBoomSDKBusiness qiYuCustomer] openCustomerSessionWithAccountID:accountId avatar:avatarUrl ompletion:^(BOOL success, NSError *error) {
        if (success) {
            NSDictionary *response = @{
                @"code": @0, //固定不变,客户端用不到
                @"message": @"成功", //固定不变,客户端用不到
                @"traceId": @"", //固定不变,客户端用不到
                @"result":@1
            };
            callback(response,nil);
        } else if (error) {
            callback(error.responseValue,error);
        } else {
            NSError *errorR = [NSError
                              errorWithDomain:NSStringFromClass([JMQiYuCustomer class])
                              code:-1
                              userInfo:@{
                                 NSLocalizedDescriptionKey: @"未知错误"
                              }
            ];
            callback(errorR.responseValue,errorR);
        }
    }];
}

-(void)logoutQiYuCustomer
{
    [[JMBoomSDKBusiness qiYuCustomer] logOut];
}

#pragma mark - 易盾智能风控

/// 获取凭证
- (void)getToken:(NSString *)businessId completeHandler:(JMBoomSDKCallback)callback
{
    [[JMBoomSDKBusiness risk] getToken:businessId completeHandler:callback];
}

/// 设置用户信息
- (void)roleLogin:(NSString *)businessId
           roleId:(NSString *)roleId
         roleName:(NSString *)roleName
      roleAccount:(NSString *)roleAccount
       roleServer:(NSString *)roleServer
         serverId:(int)serverId
         gameJson:(NSString *)gameJson
         callback:(JMBoomSDKCallback)callback
{
    [[JMBoomSDKBusiness risk] roleLogin:businessId roleId:roleId roleName:roleName roleAccount:roleAccount roleServer:roleServer serverId:serverId gameJson:gameJson callback:callback];
}

/// 登出
- (void)roleLogout
{
    [[JMBoomSDKBusiness risk] roleLogout];
}

@end
