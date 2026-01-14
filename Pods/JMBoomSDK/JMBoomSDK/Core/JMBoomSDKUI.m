//
//  JMBoomSDKUI.m
//  JMBoomSDK
//
//  Created by ZhengXianda on 10/31/2022.
//  Copyright (c) 2022 ZhengXianda. All rights reserved.
//

#import "JMBoomSDKUI.h"

#import "JMBoomSDKResource.h"
#import "JMBoomSDKBusiness.h"

#import <JMUtils/JMUtils.h>
#import <JMRktCommon/JMRktCommon.h>
#import <JMBoomInitializeBusiness/JMBoomInitializeBusiness.h>
#import <JMBoomAccountBusiness/JMBoomAccountBusiness.h>
#import <JMBoomAntiAddictionBusiness/JMBoomAntiAddictionBusiness.h>
#import <JMBoomRealNameBusiness/JMBoomRealNameBusiness.h>
#import <JMBoomRechargeBusiness/JMBoomRechargeBusiness.h>
#import <JMBoomSubmitBusiness/JMBoomSubmitBusiness.h>

@implementation JMBoomSDKUI

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

#pragma mark - 主题

- (void)registerStyle:(JMBoomStyle)style {
    [[JMBoomSDKResource shared] registerResourceStyle:(JMBoomSDKResourceStyle)style];
}

- (void)registerCustomTheme:(NSString *)customTheme {
    NSData *jsonData = [customTheme dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *customThemeMap =
    [NSJSONSerialization JSONObjectWithData:jsonData
                                    options:NSJSONReadingMutableContainers
                                      error:nil];
    if (!customThemeMap) return;
    
    NSMutableDictionary *prepareTheme = [@{
        @"JMBRNButtonBackgroundColor": JMBRNButtonBackgroundColor,
        @"JMBRNButtonTitleFont": JMBRNButtonTitleFont,
        @"JMBRNButtonConfirmTitleColor": JMBRNButtonConfirmTitleColor,
        @"JMBRNButtonCancelTitleColor": JMBRNButtonCancelTitleColor,
        @"JMBRNWindowTitleFont": JMBRNWindowTitleFont,
        @"JMBRNWindowCheckboxSelectedTintColor": JMBRNWindowCheckboxSelectedTintColor,
        @"JMBRNWindowPhoneIconTintColor": JMBRNWindowPhoneIconTintColor,
        @"JMBRNWindowGuestIconTintColor": JMBRNWindowGuestIconTintColor,
    } mutableCopy];
    for (NSString *prepareKey in prepareTheme.allKeys) {
        NSString *customValue = customThemeMap[prepareKey];
        if (customValue && [customValue length] > 0) {
            NSString *resourceName = prepareTheme[prepareKey];
            if ([prepareKey isEqual:@"JMBRNButtonTitleFont"]) {
                customValue = [customValue stringByAppendingString:@":15"];
            }
            if ([prepareKey isEqual:@"JMBRNWindowTitleFont"]) {
                customValue = [customValue stringByAppendingString:@":22"];
            }
            prepareTheme[resourceName] = customValue;
        }
        [prepareTheme removeObjectForKey:prepareKey];
    }
    [[JMBoomSDKResource shared] registerResourceMap:[prepareTheme copy]];
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
    
    [[JMBoomSDKBusiness shared] initializeUIApp:appId
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
    
    [[JMBoomSDKBusiness shared] initializeUIApp:appId
                             secretKey:secretKey
                               hasTracking:hasTracking
                              callback:callback];
}

- (void)subscribeNotification:(JMBoomSDKCallback)callback {
    [[JMRktBroadcaster shared] subscribeWithCallback:callback];
}

#pragma mark - 登录

- (void)showLocalLoginViewWithCallback:(JMBoomSDKCallback)callback {
    [[JMBoomSDKBusiness shared] showLocalLoginViewWithCallback:callback];
}

- (void)showLoginViewWithCallback:(JMBoomSDKCallback)callback {
    [[JMBoomSDKBusiness shared] showLoginViewWithLoginForced:NO
                                               callback:callback];
}

- (void)showForcedLoginViewWithCallback:(JMBoomSDKCallback)callback {
    [[JMBoomSDKBusiness shared] showLoginViewWithLoginForced:YES
                                               callback:callback];
}

#pragma mark - 实名模块

- (void)showRealNameAuthenticationViewWithCallback:(JMBoomSDKCallback)callback {
    [[JMBoomSDKBusiness shared] showRealNameAuthenticationViewWithCallback:callback];
}

#pragma mark - 充值模块

- (void)rechargeWithOrderNo:(NSString *)orderNo
                  productId:(NSString *)productId
                    subject:(NSString *)subject
                       body:(NSString *)body
                     amount:(int32_t)amount
                   callback:(JMBoomSDKCallback)callback {
    [[JMBoomSDKBusiness shared] showRechargeViewWithOrderNo:orderNo
                                         productId:productId
                                           subject:subject
                                              body:body
                                            amount:amount
                                          callback:callback];
}

#pragma mark - 安全模块

- (void)accountClosingWaitingDays:(NSUInteger)waitingDays {
    [[JMBoomSDKBusiness shared] showAccountClosingWithWaitingDays:waitingDays callback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        
    }];
}

- (void)phoneChange {
    [[JMBoomSDKBusiness shared] showPhoneChangeView];
}

- (void)accountChange {
    [[JMBoomSDKBusiness shared] showAccountChangeView];
}

- (void)logout {
    [[JMBoomSDKBusiness shared] logout];
}

#pragma mark - 建议反馈

/// 展示建议反馈
- (void)showFeedbackWithCallback:(JMBoomSDKCallback)callback {
    [[JMBoomSDKBusiness shared] showSubmitWithHistoryStatus:JMBoomSDKBusiness.info.openId.length > 0
                                                 callback:callback];
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
