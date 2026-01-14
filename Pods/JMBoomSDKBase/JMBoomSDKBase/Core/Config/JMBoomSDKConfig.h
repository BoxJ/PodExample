//
//  JMBoomSDKConfig.h
//  JMBoomSDK
//
//  Created by ZhengXianda on 10/31/2022.
//  Copyright (c) 2022 ZhengXianda. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <JMRktCommon/JMRktCommon.h>

static NSString * _Nonnull kJMBoomSDKConfigLoginStyle_CL = @"chuanglan";
static NSString * _Nonnull kJMBoomSDKConfigLoginStyle_Phone = @"phone";
static NSString * _Nonnull kJMBoomSDKConfigLoginStyle_Guest = @"guest";

typedef NS_ENUM(NSUInteger, JMBoomSDKConfigLoginRealNameVerifyType) {
    JMBoomSDKConfigLoginRealNameVerifyType_None,//不开启
    JMBoomSDKConfigLoginRealNameVerifyType_Open,//开启能关闭
    JMBoomSDKConfigLoginRealNameVerifyType_Lock,//开启不能关闭
};

typedef NS_ENUM(NSUInteger, JMBoomSDKConfigPayRealNameVerifyType) {
    JMBoomSDKConfigPayRealNameVerifyType_None,//不开启
    JMBoomSDKConfigPayRealNameVerifyType_Open,//开启能关闭
};

typedef NS_ENUM(NSUInteger, JMBoomSDKConfigYidunModeType) {
    JMBoomSDKConfigYidunModeType_SDK,//严格模式(客户端模式)
    JMBoomSDKConfigYidunModeType_Server,//服务端模式
};

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomSDKConfig : NSObject

#pragma mark - shared

+ (JMBoomSDKConfig *)shared;

@property (nonatomic, assign) BOOL isShadowMode;

+ (NSString *)version;
+ (NSString *)environment;
+ (NSString *)requestBaseURL;
+ (NSString *)webBaseURL;

@property (nonatomic, assign) NSInteger antiAddictionInterval;//防沉迷间隔(秒)
@property (nonatomic, assign) NSInteger antiAddictionSwitch;//防沉迷开关 0开启 1不开启
@property (nonatomic, strong) NSString *antiAddictionWarmPrompt;//防沉迷温馨提示
@property (nonatomic, assign) NSInteger codeLength;//验证码长度
@property (nonatomic, assign) NSInteger guestIdentity;//游客实名认证 0关 1开
@property (nonatomic, assign) JMBoomSDKConfigLoginRealNameVerifyType loginRealNameVerify;//登录实名验证,0不开启, 1开启能关闭, 2开启不能关闭
@property (nonatomic, strong) NSArray<NSString *> *loginStyle;//登录样式顺序, 枚举: chuanglan,phone,guest
@property (nonatomic, assign) NSInteger loginSwitchTime;//切换登录等待时间(秒)
@property (nonatomic, assign) JMBoomSDKConfigPayRealNameVerifyType payRealNameVerify;//支付判断实名验证, 0不开启, 1开启
@property (nonatomic, strong) NSString *privacyPolicy;//用户协议提示文案
@property (nonatomic, strong) NSString *privacyPolicyVersion;//用户协议版本号
@property (nonatomic, strong) NSArray<NSString *> *purchaseChannel;//充值渠道列表, 枚举: alipay, wxpay
@property (nonatomic, strong) NSString *purchaseNotice;//支付公告
@property (nonatomic, assign) NSInteger realNameRechargeLimit;//实名验证消费限制, 0不开启, 1开启
@property (nonatomic, assign) BOOL sandboxMark;//沙盒标记显示 1开 0关
@property (nonatomic, assign) BOOL logoMark;//Logo显示 1开 0关
@property (nonatomic, strong) NSString *serviceMail;//客服邮箱
@property (nonatomic, strong) NSString *serviceTel;//客服电话号码
@property (nonatomic, assign) JMBoomSDKConfigYidunModeType yidunMode;//易盾模式

@property (nonatomic, assign) NSInteger qiyuCustomerSwitch;//七鱼客服开关
@property (nonatomic, copy) NSString *qiYuAppKey;        //七鱼appKey
@property (nonatomic, copy) NSString *qiYuAppName;       //七鱼appName
@property (nonatomic, copy) NSString *qiYuGroupId;       //七鱼客服组ID
@property (nonatomic, copy) NSString *qiYuStaffId;       //七鱼客服ID

@property (nonatomic, copy) NSString *yiDunAntiProductId;  //易盾智能风控ProductId

- (void)queryConfigWithCallback:(JMRktCommonCallback)callback;

@end

NS_ASSUME_NONNULL_END
