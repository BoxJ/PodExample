//
//  JMBoomSDKReport.h
//  JMBoomSDKReport
//
//  Created by ZhengXianda on 08/04/2021.
//  Copyright (c) 2021 ZhengXianda. All rights reserved.
//

#import <Foundation/Foundation.h>

static const NSInteger JMBoomSDKReportCode_Common = -1;

static const NSInteger JMBoomSDKReportCode_LoginCancel = -2001;
static const NSInteger JMBoomSDKReportCode_LoginOut = -2002;
static const NSInteger JMBoomSDKReportCode_BoundCancel = -2011;
static const NSInteger JMBoomSDKReportCode_ChangePhoneCancel = -2012;
static const NSInteger JMBoomSDKReportCode_ChangeAccountCancel = -2013;

static const NSInteger JMBoomSDKReportCode_ChangePhoneDisabled = 30034;
static const NSInteger JMBoomSDKReportCode_ChangeAccountDisabled = 30035;
static const NSInteger JMBoomSDKReportCode_LoginCrashAccountClosing = 30037;

static const NSInteger JMBoomSDKReportCode_VerifyCancel = -3001;
static const NSInteger JMBoomSDKReportCode_RechargeCancel = -4001;
static const NSInteger JMBoomSDKReportCode_VerifyAlready = -5001;

NS_ASSUME_NONNULL_BEGIN

@interface NSError (JMBoomSDKReport)

+ (instancetype)boom_common:(NSString *)message;

+ (instancetype)boom_reportWithCode:(NSInteger)code message:(NSString *)message;

+ (instancetype)boom_login_cancel;
+ (instancetype)boom_login_out;
+ (instancetype)boom_bound_cancel;
+ (instancetype)boom_changephone_cancel;
+ (instancetype)boom_changeaccount_cancel;
+ (instancetype)boom_changephone_colling;
+ (instancetype)boom_changephone_disabled;
+ (instancetype)boom_changeaccount_disabled;
+ (instancetype)boom_login_crashaccountclosing;
+ (instancetype)boom_verify_cancel;
+ (instancetype)boom_recharge_cancel;
+ (instancetype)boom_verify_already;

@end

NS_ASSUME_NONNULL_END
