//
//  JMBoomSDKEvent.h
//  JMBoomSDK
//
//  Created by ZhengXianda on 11/01/2022.
//  Copyright (c) 2022 ZhengXianda. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <JMBoomSDKBase/JMBoomSDKEventItem.h>

static const NSInteger JMBoomSDKEventId_Init_Successed = 1;///初始化成功 trackEvent
static const NSInteger JMBoomSDKEventId_Init_Failed = 2;///初始化失败 trackEventFail
static const NSInteger JMBoomSDKEventId_Register_Successed = 3;///注册成功 trackOneMonthsignup
static const NSInteger JMBoomSDKEventId_Login_Failed = 4;///注册登录失败 trackOneMonthNotLogin
static const NSInteger JMBoomSDKEventId_Login_Successed = 5;///登录成功 trackOneMonthLogin
static const NSInteger JMBoomSDKEventId_Order_Start = 6;///启动支付流程 trackPayEvent
static const NSInteger JMBoomSDKEventId_Pay_Failed = 7;///IAP支付失败 trackPayEventFail
static const NSInteger JMBoomSDKEventId_Order_Successed = 8;///订单创建成功 trackPayordersuccess
static const NSInteger JMBoomSDKEventId_Order_Failed = 9;///订单创建失败 trackPayorderfail
static const NSInteger JMBoomSDKEventId_Pay_Successed = 10;///IAP支付成功 trackPayEventsuccess
static const NSInteger JMBoomSDKEventId_Agreement_Through = 11;///用户通过协议
static const NSInteger JMBoomSDKEventId_SDK_Error = 12;///SDK本地报错
static const NSInteger JMBoomSDKEventId_LoginView_Enter = 13;///打开登录界面
static const NSInteger JMBoomSDKEventId_PhoneNumberInput = 14;///手机号输入界面有输入内容
static const NSInteger JMBoomSDKEventId_VerificationCodeInput = 15;///验证码输入界面有输入内容
static const NSInteger JMBoomSDKEventId_CL_GetPhone = 16;///CL登录获取手机号结果
static const NSInteger JMBoomSDKEventId_Bound_Successed = 18;///游客转正（手机号绑定）成功
static const NSInteger JMBoomSDKEventId_LoginView_Enter_Successed = 19;///打开登录界面成功
static const NSInteger JMBoomSDKEventId_Login_Code_Successed = 1000;///登录/转正 验证码获取成功 loginmesg
static const NSInteger JMBoomSDKEventId_Login_Code_Failed = 1001;///登录/转正 验证码获取失败 loginmesgFail
static const NSInteger JMBoomSDKEventId_Login_Cancel = 1002;///自动登录 切换（取消）
static const NSInteger JMBoomSDKEventId_Login_Code_Wrong = 1021;///登录输入验证码错误 loginmesgerr
static const NSInteger JMBoomSDKEventId_Binding_Code_Wrong = 1022;///绑定输入验证码错误 bindingmesgerr
static const NSInteger JMBoomSDKEventId_NTES_Init_Failed = 2001;///易盾初始化失败 yidunerr
static const NSInteger JMBoomSDKEventId_CL_Init_Failed = 2002;///创蓝初始化失败 chuanglanerr
static const NSInteger JMBoomSDKEventId_Device_Analysis_Failed = 2003;///设备解析失败（IDFA获取失败）permissionErr

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomSDKEvent : NSObject

+ (instancetype)shared;

- (void)uploadEvent:(JMBoomSDKEventItem *)event;

- (void)uploadHistory;

- (void)recordEvent:(JMBoomSDKEventItem *)event;

@end

NS_ASSUME_NONNULL_END
