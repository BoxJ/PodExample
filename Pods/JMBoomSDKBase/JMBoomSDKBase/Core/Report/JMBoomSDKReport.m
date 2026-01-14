//
//  JMBoomSDKReport.m
//  JMBoomSDKReport
//
//  Created by ZhengXianda on 08/04/2021.
//  Copyright (c) 2021 ZhengXianda. All rights reserved.
//

#import "JMBoomSDKReport.h"

#import <JMRktCommon/JMRktCommon.h>

#import "JMBoomSDKEvent.h"

@implementation NSError (JMBoomSDKReport)

+ (instancetype)boom_common:(NSString *)message {
    return [NSError boom_reportWithCode:JMBoomSDKReportCode_Common message:message];
}

+ (instancetype)boom_reportWithCode:(NSInteger)code message:(NSString *)message {
    NSError *report = [JMRktResponse errorWithCode:code message:message];
    JMBoomSDKEventItem *eventItem = [JMBoomSDKEventItem event:JMBoomSDKEventId_SDK_Error error:report];
    [[JMBoomSDKEvent shared] uploadEvent:eventItem];
    return report;
}

+ (instancetype)boom_login_cancel {
    return [self boom_reportWithCode:JMBoomSDKReportCode_LoginCancel message:@"用户关闭登录页面"];
}

+ (instancetype)boom_login_out {
    return [self boom_reportWithCode:JMBoomSDKReportCode_LoginOut message:@"请客户端执行登出操作"];
}

+ (instancetype)boom_bound_cancel {
    return [self boom_reportWithCode:JMBoomSDKReportCode_BoundCancel message:@"用户关闭手机号绑定界面"];
}

+ (instancetype)boom_changephone_cancel {
    return [self boom_reportWithCode:JMBoomSDKReportCode_ChangePhoneCancel message:@"用户关闭换绑手机号界面"];
}

+ (instancetype)boom_changeaccount_cancel {
    return [self boom_reportWithCode:JMBoomSDKReportCode_ChangeAccountCancel message:@"用户关闭账号迁移界面"];
}

+ (instancetype)boom_changephone_disabled {
    return [self boom_reportWithCode:JMBoomSDKReportCode_ChangePhoneDisabled message:@"游客账号无法使用"];
}

+ (instancetype)boom_changeaccount_disabled {
    return [self boom_reportWithCode:JMBoomSDKReportCode_ChangeAccountDisabled message:@"游客账号无法使用"];
}

+ (instancetype)boom_login_crashaccountclosing {
    return [self boom_reportWithCode:JMBoomSDKReportCode_LoginCrashAccountClosing message:@"中止账号注销流程"];
}

+ (instancetype)boom_verify_cancel {
    return [self boom_reportWithCode:JMBoomSDKReportCode_VerifyCancel message:@"用户关闭实名认证页面"];
}

+ (instancetype)boom_recharge_cancel {
    return [self boom_reportWithCode:JMBoomSDKReportCode_RechargeCancel message:@"用户关闭支付界面"];
}

+ (instancetype)boom_verify_already {
    return [self boom_reportWithCode:JMBoomSDKReportCode_VerifyAlready message:@"用户已实名"];
}

@end
