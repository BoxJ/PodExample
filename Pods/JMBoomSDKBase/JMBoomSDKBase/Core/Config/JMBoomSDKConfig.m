//
//  JMBoomSDKConfig.m
//  JMBoomSDK
//
//  Created by ZhengXianda on 10/25/2022.
//  Copyright (c) 2022 ZhengXianda. All rights reserved.
//

#import "JMBoomSDKConfig.h"

#import "JMBoomSDKBaseEnv.h"
#import "JMBoomSDKRequest.h"

#import "JMBoomSDKRequest+JMBoomSDKConfig.h"

@implementation JMBoomSDKConfig

#pragma mark - shared

+ (JMBoomSDKConfig *)shared {
    static JMBoomSDKConfig * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JMBoomSDKConfig alloc] init];
    });
    return instance;
}

+ (NSString *)version {
    return JMBoomSDKBase_Version;
}

+ (NSString *)environment {
    return JMBoomSDKBase_Environment;
}

+ (NSString *)requestBaseURL {
    return [self shared].isShadowMode ? JMBoomSDKBase_RequestBaseURLForShadow : JMBoomSDKBase_RequestBaseURL;
}

+ (NSString *)webBaseURL {
    return [self shared].isShadowMode ? JMBoomSDKBase_WebBaseURLForShadow : JMBoomSDKBase_WebBaseURL;
}

- (void)queryConfigWithCallback:(JMRktCommonCallback)callback {
    [[JMBoomSDKRequest shared] fetchConfigWithCallback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            callback(responseObject, error);
        } else {
            NSDictionary *result = responseObject[@"result"];
//            NSLog(@"SDK配置：%@",result);
            self.antiAddictionInterval = [result[@"antiAddictionInterval"] integerValue];//防沉迷间隔(秒)
            self.antiAddictionSwitch = [result[@"antiAddictionSwitch"] integerValue];//防沉迷开关 0开启 1不开启
            self.antiAddictionWarmPrompt = result[@"antiAddictionWarmPrompt"];//防沉迷温馨提示
            self.codeLength = [result[@"codeLength"] integerValue];//验证码长度
            self.guestIdentity = [result[@"guestIdentity"] integerValue];//游客实名认证 0关 1开
            self.loginRealNameVerify = (JMBoomSDKConfigLoginRealNameVerifyType)[result[@"loginRealNameVerify"] integerValue];//登录实名验证,0不开启, 1开启能关闭, 2开启不能关闭
            self.loginStyle = result[@"loginStyle"];//登录样式顺序, 枚举: chuanglan,phone,guest
            self.loginSwitchTime = [result[@"loginSwitchTime"] integerValue];//切换登录等待时间(秒)
            self.payRealNameVerify = (JMBoomSDKConfigPayRealNameVerifyType)[result[@"payRealNameVerify"] integerValue];//支付判断实名验证, 0不开启, 1开启
            self.purchaseChannel = result[@"purchaseChannel"];//充值渠道列表, 枚举: alipay, wxpay
            self.purchaseNotice = result[@"purchaseNotice"];//支付公告
            self.realNameRechargeLimit = [result[@"realNameRechargeLimit"] integerValue];//实名验证消费限制, 0不开启, 1开启
            self.sandboxMark = [result[@"sandboxMark"] boolValue];//沙盒标记显示 1开 0关
            self.logoMark = [result[@"logoMark"] boolValue];//Logo显示 1开 0关
            self.serviceMail = result[@"serviceMail"];//客服邮箱
            self.serviceTel = result[@"serviceTel"];//客服电话号码
            self.yidunMode = (JMBoomSDKConfigYidunModeType)[result[@"yidunMode"] integerValue];//易盾模式
            if (result[@"qiyuCustomerServiceStatus"]) {
                //七鱼开关
                self.qiyuCustomerSwitch = [result[@"qiyuCustomerServiceStatus"] integerValue];//七鱼 0关 1开
                if (self.qiyuCustomerSwitch) {
                    self.qiYuAppKey = result[@"qiyuCustomerServiceAppKey"];  //七鱼 appKey
                    self.qiYuAppName = result[@"appName"] ?: @"";//七鱼 appName
                    if (result[@"qiyuCustomerServiceGroupId"]) {
                        self.qiYuGroupId = [NSString stringWithFormat:@"%@",result[@"qiyuCustomerServiceGroupId"]];  //七鱼 客服组
                    }
                    if (result[@"qiyuCustomerServiceId"]) {
                        self.qiYuStaffId = [NSString stringWithFormat:@"%@",result[@"qiyuCustomerServiceId"]];  //七鱼 客服
                    }
                }
            }
            if (result[@"yidunAntiProductId"]) {
                self.yiDunAntiProductId = result[@"yidunAntiProductId"];
            }
            
            callback(responseObject, error);
        }
    }];
}

@end
