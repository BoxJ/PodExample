//
//  JMBoomCLManager.m
//  JMBoomSDK
//
//  Created by Thief Toki on 2020/8/6.
//

#import "JMBoomCLManager.h"

#import <JMRktCommon/JMRktCommon.h>

#import <JMBoomSDKBase/JMBoomSDKBase.h>

@implementation JMBoomCLManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self registerAppId:@"3d3c97d7246d"];
    }
    return self;
}

- (void)awakeWithEventCallback:(JMCLCallback)callback {
    __weak typeof(self) weakSelf = self;
    [self awakeWithCallback:^(NSDictionary * _Nonnull info, NSError * _Nullable error) {
        if (error) {
            JMLog(@"创蓝初始化获取三网信息失败：%@", error.localizedDescription);
            [JMBoomSDKBusiness.event recordEvent:[JMBoomSDKEventItem event:JMBoomSDKEventId_CL_Init_Failed error:error]];
        } else {
            JMLog(@"创蓝初始化获取三网信息成功");
        }
        
        [weakSelf sendResult:info error:error toCallback:callback];
    }];
}

- (void)getPhoneNumberWithEventCallback:(JMCLCallback)callback {
    __weak typeof(self) weakSelf = self;
    [self getPhoneNumberWithCallback:^(NSDictionary * _Nonnull info, NSError * _Nullable error) {
        if (error) {
            JMLog(@"创蓝预取号失败：%@", error.localizedDescription);
        } else {
            JMLog(@"创蓝预取号成功");
        }
        
        [weakSelf sendResult:info error:error toCallback:callback];
    }];
}

- (void)loginAuthWithEventCallback:(JMCLCallback)callback {
    __weak typeof(self) weakSelf = self;
    [self loginAuthWithCallback:^(NSDictionary * _Nonnull info, NSError * _Nullable error) {
        if (error) {
            JMLog(@"一键登录Token获取失败：%@", error.localizedDescription);
        } else {
            JMLog(@"一键登录Token获取成功");
        }
        
        [weakSelf sendResult:info error:error toCallback:callback];
    }];
}

- (void)sendResult:info error:(NSError *)error toCallback:(JMCLCallback)callback {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (error) {
            NSError *localError = [JMRktResponse errorWithCode:error.code
                                                        message:error.domain
                                                       userInfo:error.userInfo];
            callback(localError.responseValue, localError);
        } else {
            callback([JMRktResponse successWithResult:info], nil);
        }
    });
}

@end
