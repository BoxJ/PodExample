//
//  JMBoomSDKBusiness+JMBoomInitializeBusiness.m
//  JMBoomInitializeBusiness
//
//  Created by Thief Toki on 2021/2/4.
//

#import "JMBoomSDKBusiness+JMBoomInitializeBusiness.h"

#import <AppTrackingTransparency/ATTrackingManager.h>

#import <JMRktCommon/JMRktCommon.h>
//#import <JMNTESManager/JMNTESManager.h>
#import <JMAttributionManager/JMAttributionManager.h>

#import <JMBoomSDKBase/JMBoomSDKBase.h>

#import "JMBoomInitializeBusinessMock.h"

#import "JMBoomSDKRequest+Data.h"
#import "JMBoomSDKRequest+JMBoomInitializeBusiness.h"

#import <JMQiYuCustomer/JMQiYuCustomer.h>

@implementation JMBoomSDKBusiness (JMBoomInitializeBusiness)

- (void)initializeApp:(NSString *)appId
            secretKey:(NSString *)secretKey
          hasTracking:(BOOL)hasTracking
             callback:(JMBusinessCallback)callback {
    if (hasTracking) {
        if (@available(iOS 14, *)) {
            JMLog(@"请求跟踪权限");
            
            [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                    JMLog(@"已拥有跟踪权限");
                } else {
                    JMLog(@"未拥有跟踪权限，请在设置-隐私-跟踪中允许App请求跟踪");
                }
                
                [self initializeApp:appId
                              secretKey:secretKey
                               callback:callback];
            }];
            return;
        } else {
            JMLog(@"当前系统版本无需请求跟踪权限");
        }
    }
    
    [self initializeApp:appId
              secretKey:secretKey
               callback:callback];
}

- (void)initializeApp:(NSString *)appId
            secretKey:(NSString *)secretKey
             callback:(JMBusinessCallback)callback {
    [JMBoomSDKBusiness.info registerApp:appId secretKey:secretKey];
    
    if (JMBoomSDKBusiness.info.IDFA.length == 0) {
        [JMBoomSDKBusiness.event uploadEvent:[JMBoomSDKEventItem event:JMBoomSDKEventId_Device_Analysis_Failed]];
    }
    
    [self antiAddictionCountingPause];
    
    [self initUserAgentWithCallback:callback];
}

- (void)initUserAgentWithCallback:(JMBusinessCallback)callback {
    [[JMUserAgent shared] requestUserAgentWithCallback:^(NSString * _Nullable userAgent, NSError * _Nullable error) {
        if (error) {
            JMLog(@"UserAgent 获取失败: %@", error);
        } else {
            JMLog(@"UserAgent 获取成功: %@", userAgent);
        }
        [self initConfigWithCallback:callback];
    }];
}

- (void)initConfigWithCallback:(JMBusinessCallback)callback {
    [JMBoomSDKBusiness.config queryConfigWithCallback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            [JMBoomSDKBusiness.event uploadEvent:[JMBoomSDKEventItem event:JMBoomSDKEventId_Init_Failed error:error]];
            
            callback(responseObject, error);
        } else {
            /* - 不再用老的易盾了 下面直接[self initCLManagerWithCallback:callback];
            switch (JMBoomSDKBusiness.config.yidunMode) {
                case JMBoomSDKConfigYidunModeType_SDK: {
                    [self initNTESManagerWithCallback:callback];
                }
                    break;
                case JMBoomSDKConfigYidunModeType_Server: {
                    [self initCLManagerWithCallback:callback];
                }
                    break;;
            }
             */
            [self initCLManagerWithCallback:callback];
            
            if (JMBoomSDKBusiness.config.qiyuCustomerSwitch) {
                [self initQiYuCustomer];
            }
            if (JMBoomSDKBusiness.config.yiDunAntiProductId.length) {
                [self initYiDunRisk];
            }
        }
    }];
}
/*
- (void)initNTESManagerWithCallback:(JMBusinessCallback)callback {
    [[JMNTESManager shared] registerAppId:@"YD00980560562681"];
    [[JMNTESManager shared] awakeWithCallback:^(NSError * _Nullable error) {
        if (error) {
            JMLog(@"初始化易盾 失败：%@", error.localizedDescription);

            [JMBoomSDKBusiness.event uploadEvent:[JMBoomSDKEventItem event:JMBoomSDKEventId_NTES_Init_Failed]];
            
            NSError *localError = [JMRktResponse errorWithCode:error.code
                                                       message:error.domain
                                                      userInfo:error.userInfo];
            if (callback) callback(localError.responseValue, localError);
        } else {
            JMLog(@"初始化易盾 成功");

            [self initCLManagerWithCallback:callback];
        }
    }];
}
*/
- (void)initCLManagerWithCallback:(JMBusinessCallback)callback {
    [self registerCLManagerWithCallback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        [self initSDKWithCallback:callback];
    }];
}

- (void)initSDKWithCallback:(JMBusinessCallback)callback {
    [JMBoomSDKBusiness.request initSDKWithCallback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            [JMBoomSDKBusiness.event uploadEvent:[JMBoomSDKEventItem event:JMBoomSDKEventId_Init_Failed error:error]];
            
            callback(responseObject, error);
        } else {
            [JMBoomSDKBusiness.event uploadEvent:[JMBoomSDKEventItem event:JMBoomSDKEventId_Init_Successed]];
            
            [self initSuccessedWithCallback:^ {
                callback(responseObject, error);
            }];
        }
    }];
}

- (void)initSuccessedWithCallback:(void(^)(void))callback {
    //上传历史日志
    [JMBoomSDKBusiness.event uploadHistory];
    //广告渠道激活
    [[JMAttributionManager shared] requestAttributionInfoWithBlock:^(NSString * _Nonnull info, NSError * _Nonnull error) {
        [JMBoomSDKBusiness.request activateWithToken:[JMAttributionManager shared].attributionToken
                                            adData:[JMAttributionManager shared].attributionDetails
                                          callback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
            if (callback) callback();
        }];
    }];
    //检查历史订单
    [self registerIAPManagerWithCallback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
       
    }];
}

-(void)initQiYuCustomer
{
    if (JMBoomSDKBusiness.config.qiYuAppKey.length) {
        [[JMBoomSDKBusiness qiYuCustomer] initWithAppKey:JMBoomSDKBusiness.config.qiYuAppKey appName:JMBoomSDKBusiness.config.qiYuAppName groupId:JMBoomSDKBusiness.config.qiYuGroupId staffId:JMBoomSDKBusiness.config.qiYuStaffId completion:^(BOOL success, NSError *error) {
            JMLog(@"初始化七鱼客服 %@",error ? error.localizedDescription : @"成功");
        }];
    }
}

-(void)initYiDunRisk
{
    [[JMBoomSDKBusiness risk] initWithProductID:JMBoomSDKBusiness.config.yiDunAntiProductId completeHandler:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        JMLog(@"初始化易盾智能风控 %@",error ? error.localizedDescription : @"成功");
    }];
}

#pragma mark - data

/// 上传角色信息
- (void)uploadChapter:(NSString * _Nullable)chapter
            guildName:(NSString * _Nullable)guildName
          roleBalance:(NSString * _Nullable)roleBalance
               roleId:(NSString * _Nullable)roleId
               roleLv:(NSString * _Nullable)roleLv
             roleName:(NSString * _Nullable)roleName
            rolePower:(NSString * _Nullable)rolePower
            serviceId:(NSString * _Nullable)serviceId
          serviceName:(NSString * _Nullable)serviceName
                vipLv:(NSString * _Nullable)vipLv
                  ext:(NSDictionary * _Nullable)ext
             callback:(JMBusinessCallback)callback {
    [JMBoomSDKBusiness.request uploadChapter:chapter
                                 guildName:guildName
                               roleBalance:roleBalance
                                    roleId:roleId
                                    roleLv:roleLv
                                  roleName:roleName
                                 rolePower:rolePower
                                 serviceId:serviceId
                               serviceName:serviceName
                                     vipLv:vipLv
                                       ext:ext
                                  callback:callback];
}

@end
