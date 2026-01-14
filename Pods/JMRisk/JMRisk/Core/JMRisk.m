//
//  JMRisk.m
//  JMRisk
//
//  Created by ZhengXianda on 09/11/2024.
//  Copyright (c) 2024 ZhengXianda. All rights reserved.
//

#import "JMRisk.h"

#import <RiskPerception/NTESRiskUniPerception.h>
#import <RiskPerception/NTESRiskUniConfiguration.h>

@implementation JMRisk

#pragma mark - shared

+ (JMRisk *)shared {
    static JMRisk *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)init:(NSString *)productId callback:(JMRktCommonCallback)callback {
    [[NTESRiskUniPerception fomentBevelDeadengo] init:productId callback:^(int code, NSString * _Nonnull msg, NSString * _Nonnull content) {
        if (code == 200) {
            if (callback) {
                callback([JMRktResponse success], nil);
            }
        } else {
            if (callback) {
                NSError *error = [JMRktResponse errorWithCode:code message:msg userInfo:@{
                    @"content": content,
                }];
                callback([error responseValue], error);
            }
        }
    }];
}

- (void)getToken:(NSString *)businessId completeHandler:(JMRktCommonCallback)callback {
    [[NTESRiskUniPerception fomentBevelDeadengo] getTokenAsync:businessId withTimeout:10000 completeHandler:^(AntiCheatResult * _Nonnull result) {
        if (result.code == 200) {
            if (callback) {
                callback([JMRktResponse successWithResult:@{
                    @"businessId": result.businessId,
                    @"token": result.token,
                }], nil);
            }
        } else {
            if (callback) {
                NSError *error = [JMRktResponse errorWithCode:result.code message:result.codeStr userInfo:@{
                    @"businessId": businessId,
                    @"token": result.token,
                }];
                callback([error responseValue], error);
            }
        }
    }];
}

- (void)roleLogin:(NSString *)businessId 
           roleId:(NSString *)roleId
         roleName:(NSString *)roleName
      roleAccount:(NSString *)roleAccount
       roleServer:(NSString *)roleServer
         serverId:(int)serverId
         gameJson:(NSString *)gameJson
         callback:(JMRktCommonCallback)callback {
    int ret =
    [[NTESRiskUniPerception fomentBevelDeadengo]
     setRoleInfo:businessId
     roleId:roleId
     roleName:roleName
     roleAccount:roleAccount
     roleServer:roleServer
     serverId:serverId
     gameJson:gameJson];
    if (ret == 0) {
        if (callback) {
            callback([JMRktResponse success], nil);
        }
    } else {
        NSString *msg;
        switch (ret) {
            case 201: msg = @"未初始化";
                break;
            case 203: msg = @"参数不合法";
                break;
            default:
                msg = @"未知错误";
        }
        if (callback) {
            NSError *error = [JMRktResponse errorWithCode:ret message:msg];
            callback([error responseValue], error);
        }
    }
}

- (void)roleLogout {
    [[NTESRiskUniPerception fomentBevelDeadengo] logOut];
}

+ (void)setServerType:(NSInteger)type {
    [NTESRiskUniConfiguration setServerType:type];
}

+ (void)setChannel:(NSString *)channel {
    [NTESRiskUniConfiguration setChannel:channel];
}

+ (void)setExtraData:(NSString *)key forValue:(NSString *)value {
    [NTESRiskUniConfiguration setExtraData:key forValue:value];
}

+ (void)setHost:(NSString *)host {
    [NTESRiskUniConfiguration setHost:host];
}

@end
