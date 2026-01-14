//
//  JMBoomSDKBusiness+AccountUILogin.m
//  JMBoomSDK
//
//  Created by Thief Toki on 2021/2/5.
//

#import "JMBoomSDKBusiness+AccountUILogin.h"

#import <JMRktCommon/JMRktCommon.h>

#import "JMBoomCLManager.h"

#import "JMBoomQuickLoginModalView.h"
#import "JMBoomPhoneLoginModalView.h"
#import "JMBoomAutoLoginHintView.h"
#import "JMBoomLoginSuccessHintView.h"

#import "JMBoomAccountBusiness.h"
#import "JMBoomAccountBusinessMock.h"

@interface JMBoomSDKBusinessAccountUILoginProperty : NSObject

@property (nonatomic, assign) BOOL isShowing;

@property (nonatomic, strong, nullable) JMBusinessCallback callback;
@property (nonatomic, strong) NSDictionary *loginResponse;
@property (nonatomic, assign) BOOL isLoginForced;

@end

@implementation JMBoomSDKBusinessAccountUILoginProperty

#pragma mark - shared

+ (instancetype)shared {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

@end

@implementation JMBoomSDKBusiness (AccountUILogin)

- (void)showLoginViewWithLoginForced:(BOOL)loginForced callback:(JMBusinessCallback)callback {
    if ([JMBoomSDKBusinessAccountUILoginProperty shared].isShowing) {
        JMLog(@"当前流程正在展示中，请勿重复调用");
        return;
    }
    [JMBoomSDKBusinessAccountUILoginProperty shared].isShowing = YES;
    
    //展示登录页面
    [JMBoomSDKBusiness.event uploadEvent:[JMBoomSDKEventItem event:JMBoomSDKEventId_LoginView_Enter exStrs:@[@"0"]]];
    
    JMLog(@"JMBoom Event = JMBoomSDKEventId_LoginView_Enter:0");
    
    if (JMBoomSDKBusiness.info.token.length > 0 && [JMBoomSDKBusiness.info isLocalAgreementThrough]) {
        JMLog(@"展示自动登录");
        [self showAutoLoginViewWithLoginForced:loginForced callback:callback];
    } else {
        JMLog(@"展示手动登录");
        [self showManualLoginViewWithLoginForced:loginForced callback:callback];
    }
}

- (void)showAutoLoginViewWithLoginForced:(BOOL)loginForced callback:(JMBusinessCallback)callback {
    [JMBoomSDKBusinessAccountUILoginProperty shared].isLoginForced = loginForced;
    [JMBoomSDKBusinessAccountUILoginProperty shared].callback = callback;
    
    __weak typeof(self) weakSelf = self;
    [[[JMBoomAutoLoginHintView alloc] initWithNumber:[JMBoomCLManager shared].number
                                    protocolName:[JMBoomCLManager shared].protocolName
                                     protocolUrl:[JMBoomCLManager shared].protocolUrl
                                verifyCodeLength:JMBoomSDKBusiness.config.codeLength
                                       delayTime:JMBoomSDKBusiness.config.loginSwitchTime
                                        nickname:JMBoomSDKBusiness.info.nickname]
     show:[JMResponder success:^(NSDictionary *info) {
        JMLog(@"用户自动登录成功");
        [JMBoomSDKBusinessAccountUILoginProperty shared].loginResponse = info;
        [weakSelf loginSuccessCheck_identityStatusConfirm];
    } failed:^(NSError *error) {
        JMLog(@"用户自动登录失败");
        [[JMBoomSDKBusiness shared] logout];
        [weakSelf showManualLoginViewWithLoginForced:[JMBoomSDKBusinessAccountUILoginProperty shared].isLoginForced
                                        callback:[JMBoomSDKBusinessAccountUILoginProperty shared].callback];
        [JMRktDialog showError:error];
    } cancel:^{
        JMLog(@"用户自动登录取消");
        [weakSelf showManualLoginViewWithLoginForced:[JMBoomSDKBusinessAccountUILoginProperty shared].isLoginForced
                                        callback:[JMBoomSDKBusinessAccountUILoginProperty shared].callback];
    }]];
}

- (void)showManualLoginViewWithLoginForced:(BOOL)loginForced callback:(JMBusinessCallback)callback {
    [JMBoomSDKBusinessAccountUILoginProperty shared].isLoginForced = loginForced;
    [JMBoomSDKBusinessAccountUILoginProperty shared].callback = callback;
    
    [JMToast showToastLoading];
    
    JMBusinessCallback localAction = ^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        JMModalView *loginModalView;
        if ([JMBoomCLManager shared].number.length > 0 &&
            [JMBoomSDKBusiness.config.loginStyle containsObject:kJMBoomSDKConfigLoginStyle_CL]) {

            JMLog(@"展示创蓝一键登录");
            [JMBoomSDKBusiness.event uploadEvent:[JMBoomSDKEventItem event:JMBoomSDKEventId_CL_GetPhone exStrs:@[@"0", @"0"]]];
            JMLog(@"JMBoom Event = JMBoomSDKEventId_CL_GetPhone:0,0");
            loginModalView = [[JMBoomQuickLoginModalView alloc] initWithLoginStyle:JMBoomSDKBusiness.config.loginStyle
                                                                        number:[JMBoomCLManager shared].number
                                                                  operatorName:[JMBoomCLManager shared].operatorName
                                                                  protocolName:[JMBoomCLManager shared].protocolName
                                                                   protocolUrl:[JMBoomCLManager shared].protocolUrl
                                                              verifyCodeLength:JMBoomSDKBusiness.config.codeLength
                                                                   loginForced:[JMBoomSDKBusinessAccountUILoginProperty shared].isLoginForced];
        } else {
            JMLog(@"展示手机号登录");
            [JMBoomSDKBusiness.event uploadEvent:[JMBoomSDKEventItem event:JMBoomSDKEventId_CL_GetPhone exStrs:@[@"0", @"1"]]];
            JMLog(@"JMBoom Event = JMBoomSDKEventId_CL_GetPhone:0,1");
            loginModalView = [[JMBoomPhoneLoginModalView alloc] initWithLoginStyle:JMBoomSDKBusiness.config.loginStyle
                                                              verifyCodeLength:JMBoomSDKBusiness.config.codeLength
                                                                   loginForced:[JMBoomSDKBusinessAccountUILoginProperty shared].isLoginForced];
        }
        
        __weak typeof(self) weakSelf = self;
        [[loginModalView registerStack]
         show:[JMResponder success:^(NSDictionary *info) {
            [JMBoomSDKBusinessAccountUILoginProperty shared].loginResponse = info;
            [weakSelf loginSuccessCheck_identityStatusConfirm];
        } cancel:^{
            [weakSelf loginFailed:[NSError boom_login_cancel]];
        }]];
        
        [JMToast dismissToast];
    };
    
    if ([JMBoomCLManager shared].number.length > 0) {
        localAction([JMRktResponse success], nil);
    } else {
        [[JMBoomCLManager shared] getPhoneNumberWithEventCallback:localAction];
    }
}

- (void)loginSuccessCheck_identityStatusConfirm {
    __weak typeof(self) weakSelf = self;
    [[JMBoomSDKBusiness shared] checkRealNameStatusConfirmWithResponder:[JMResponder success:^(NSDictionary *info) {
        //已完成“实名认证确认”
        [weakSelf loginSuccessCheck_antiAddiction];
    } failed:^(NSError *error) {
        [weakSelf showManualLoginViewWithLoginForced:[JMBoomSDKBusinessAccountUILoginProperty shared].isLoginForced
                                        callback:[JMBoomSDKBusinessAccountUILoginProperty shared].callback];
        [JMRktDialog showError:error];
    } cancel:^{
        //未实名
        [weakSelf loginSuccessCheck_antiAddiction];
    }]];
}

- (void)loginSuccessCheck_antiAddiction {
    __weak typeof(self) weakSelf = self;
    JMResponder *responder = [JMResponder success:^(NSDictionary *info) {
        [weakSelf loginSuccess];
    } failed:^(NSError *error) {
        [weakSelf showManualLoginViewWithLoginForced:[JMBoomSDKBusinessAccountUILoginProperty shared].isLoginForced
                                        callback:[JMBoomSDKBusinessAccountUILoginProperty shared].callback];
    } cancel:^{
        [weakSelf loginSuccess];
    }];
    
    if (JMBoomSDKBusiness.config.antiAddictionSwitch) {
        [[JMBoomSDKBusiness shared] checkRealNameOfLoginWithResponder:responder];
    } else {
        [[JMBoomSDKBusiness shared] checkAntiAddiction:responder];
    }
}

- (void)loginFailed:(NSError *)error {
    if ([JMBoomSDKBusinessAccountUILoginProperty shared].callback) {
        [JMBoomSDKBusinessAccountUILoginProperty shared].callback(error.responseValue, error);
    }
    [JMBoomSDKBusinessAccountUILoginProperty shared].isShowing = NO;
}

- (void)loginSuccess {
    //反馈登录成功信息
    if ([JMBoomSDKBusinessAccountUILoginProperty shared].callback) {
        [JMBoomSDKBusinessAccountUILoginProperty shared].callback([JMBoomSDKBusinessAccountUILoginProperty shared].loginResponse?:@{}, nil);
        [JMBoomSDKBusinessAccountUILoginProperty shared].callback = nil;
    }
    //展示登录成功提示
    [[[JMBoomLoginSuccessHintView alloc] initWithNickname:JMBoomSDKBusiness.info.nickname] show];
    //开启心跳
    [[JMBoomSDKBusiness shared] antiAddictionCountingWithCallback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            //游戏中，时间限制触发，点击确认后提示cp端退出游戏
            [JMRktDialog showError:error responder:[JMResponder success:^(NSDictionary *info) {
                //游戏中，提示cp端
                [[JMRktBroadcaster shared] sendError:error];
            }]];
        }
    }];
    [JMBoomSDKBusinessAccountUILoginProperty shared].isShowing = NO;
}

@end

