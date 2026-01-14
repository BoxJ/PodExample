//
//  JMBoomSDKBusiness+JMBoomRealNameBusinessUI.m
//  JMBoomSDK
//
//  Created by Thief Toki on 2021/2/4.
//

#import "JMBoomSDKBusiness+JMBoomRealNameBusinessUI.h"

#import <JMBoomSDKBase/JMBoomSDKBase.h>

#import "JMBoomRealNameAuthenticationModalView.h"

#import "JMBoomRealNameBusiness.h"
#import "JMBoomRealNameBusinessMock.h"

#import "JMBoomSDKBusiness+JMBoomRealNameBusiness.h"

@interface JMBoomRealNameBusinessUIProperty : NSObject

@property (nonatomic, assign) BOOL isShowing;

@property (nonatomic, strong, nullable) JMBusinessCallback callback;

@end

@implementation JMBoomRealNameBusinessUIProperty

+ (instancetype)shared {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

@end

@implementation JMBoomSDKBusiness (JMBoomRealNameBusinessUI)

- (void)showRealNameAuthenticationViewWithCallback:(JMBusinessCallback)callback {
    if ([JMBoomRealNameBusinessUIProperty shared].isShowing) {
        JMLog(@"当前流程正在展示中，请勿重复调用");
        return;
    }
    [JMBoomRealNameBusinessUIProperty shared].isShowing = YES;
    
    [JMBoomRealNameBusinessUIProperty shared].callback = callback;
    
    if (JMBoomSDKBusiness.config.guestIdentity) {
        [self showRealNameAuthenticationView];
    } else {
        switch (JMBoomSDKBusiness.info.registerType) {
            case JMBoomRegisterType_Phone: {
                [self showRealNameAuthenticationView_phoneLogin];
                break;
            }
            case JMBoomRegisterType_Guest: {
                [self showRealNameAuthenticationView_guest];
                break;
            }
        }
    }
}

- (void)showRealNameAuthenticationView_phoneLogin {
    [self showRealNameAuthenticationView];
}

- (void)showRealNameAuthenticationView_guest {
    //游客用户(开启实名认证)：弹出绑定手机号(可关闭)->填写实名认证(可关闭)；
    [self showLoginBoundModalViewWithLock:NO
                            hasRegisterCL:YES
                                responder:[JMResponder success:^(NSDictionary *info) {
          [self showRealNameAuthenticationView];
      } cancel:^{
          //游客取消绑定手机号
          [self realNameCallbackFailed:[NSError boom_bound_cancel]];
    }]];
}

- (void)showRealNameAuthenticationView {
    //填写实名认证(可关闭)
    [self checkRealNameStatusWithResponder:[JMResponder success:^(NSDictionary *info) {
        //用户已实名
        [self realNameCallbackFailed:[NSError boom_verify_already]];
    } failed:^(NSError *error) {
        //用户实名状态获取失败
        [JMRktDialog showError:error];
        [self realNameCallbackFailed:error];
    } cancel:^{
        //需要实名认证
        [self showRealNameAuthenticationViewWithLock:NO responder:[JMResponder success:^(NSDictionary *info) {
            //用户实名认证成功
            [self realNameCallbackSuccess:info];
        } cancel:^{
            //用户取消实名认证
            [self realNameCallbackFailed:[NSError boom_verify_cancel]];
        }]];
    }]];
}

- (void)realNameCallbackSuccess:(NSDictionary *)responseObject {
    if ([JMBoomRealNameBusinessUIProperty shared].callback) {
        [JMBoomRealNameBusinessUIProperty shared].callback(responseObject, nil);
        [JMBoomRealNameBusinessUIProperty shared].callback = nil;
    }
    [JMBoomRealNameBusinessUIProperty shared].isShowing = NO;
}

- (void)realNameCallbackFailed:(NSError *)error {
    if ([JMBoomRealNameBusinessUIProperty shared].callback) {
        [JMBoomRealNameBusinessUIProperty shared].callback(error.responseValue, error);
        [JMBoomRealNameBusinessUIProperty shared].callback = nil;
    }
    [JMBoomRealNameBusinessUIProperty shared].isShowing = NO;
}

#pragma mark - utils

- (void)checkRealNameStatusConfirmWithResponder:(JMResponder *)responder {
    switch (JMBoomSDKBusiness.config.loginRealNameVerify) {
        case JMBoomSDKConfigLoginRealNameVerifyType_None:{
            //不开启实名认证：登录成功
            responder.cancel();
            return;
        }
            break;
        default:
            break;
    }
    if ([self isLocalkRealNameVerifyCompleted]) {
        //若该用户在当前应用已完成“实名认证确认”，继续下一步
        responder.success(@{});
    } else {
        //若该用户在当前应用未完成“实名认证确认”
        [self checkRealNameStatusWithResponder:[JMResponder success:^(NSDictionary *info) {
            //若已实名，记录“实名认证确认”标记，展示实名提示
            [self localkRealNameVerifyCompleted];
            [[[JMTipsModalView alloc] initWithTitle:nil
                                         titleImage:[JMBoomSDKResource imageNamed:@"boom_attestation_done"]
                                            message:@"该账号在娱公互动账号体系中已完成实名认证。"
                                  attributedMessage:nil
                                       confirmTitle:@"确定"
                                        cancelTitle:nil]
             show:[JMResponder success:^(NSDictionary *_) {
                responder.success(info);
            }]];
        } failed:^(NSError *error) {
            responder.failed(error);
        } cancel:^{
            //若未实名，继续下一步
            responder.cancel();
        }]];
    }
}

- (void)checkRealNameStatusWithResponder:(JMResponder *)responder {
    [self identityStatusWithCallback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            responder.failed(error);
        } else {
            if ([responseObject[@"result"]?:@(NO) boolValue]) {
                //已完成实名认证
                responder.success(responseObject);
            } else {
                //未实名认证
                responder.cancel();
            }
        }
    }];
}

- (void)checkRealNameStatusWithLock:(BOOL)isLock responder:(JMResponder *)responder {
    //检查用户实名状态
    [self checkRealNameStatusWithResponder:[JMResponder success:^(NSDictionary *info) {
        //已实名认证
        responder.success(info);
    } failed:^(NSError *error) {
        //实名状态获取失败
        responder.failed(error);
    } cancel:^{
        //需要实名认证，展示实名认证页面
        [self showRealNameAuthenticationViewWithLock:isLock responder:[JMResponder success:^(NSDictionary *info) {
            //实名认证成功
            responder.success(info);
        } cancel:^{
            //用户关闭实名认证页面, 未实名认证
            responder.cancel();
        }]];
    }]];
}

- (void)checkRealNameOfLoginWithResponder:(JMResponder *)responder {
    responder = responder;
    
    //执行手机号绑定和实名认证业务
    if (JMBoomSDKBusiness.config.guestIdentity) {
        [self checkRealNameOfPhoneLoginWithResponder:responder];
    } else {
        switch (JMBoomSDKBusiness.info.registerType) {
            case JMBoomRegisterType_Phone: {
                [self checkRealNameOfPhoneLoginWithResponder:responder];
                break;
            }
            case JMBoomRegisterType_Guest: {
                [self checkRealNameOfGuestLoginWithResponder:responder];
                break;
            }
        }
    }
}

- (void)checkRealNameOfPhoneLoginWithResponder:(JMResponder *)responder {
    switch (JMBoomSDKBusiness.config.loginRealNameVerify) {
        case JMBoomSDKConfigLoginRealNameVerifyType_None:{
            //手机号登录成功，不开启实名认证：登录成功
            responder.success(@{});
        }
            break;
        case JMBoomSDKConfigLoginRealNameVerifyType_Open:{
            [self checkRealNameStatusWithLock:NO responder:responder];
        }
            break;
        case JMBoomSDKConfigLoginRealNameVerifyType_Lock:{
            [self checkRealNameStatusWithLock:YES responder:responder];
        }
            break;
    }
}

- (void)checkRealNameOfGuestLoginWithResponder:(JMResponder *)responder {
    switch (JMBoomSDKBusiness.config.loginRealNameVerify) {
        case JMBoomSDKConfigLoginRealNameVerifyType_None:{
            [self showBoundTipsModalViewWithLock:NO responder:responder];
        }
            break;
        case JMBoomSDKConfigLoginRealNameVerifyType_Open:{
            [self checkRealNameOfGuestLoginWithLock:NO responder:responder];
        }
            break;
        case JMBoomSDKConfigLoginRealNameVerifyType_Lock:{
            [self checkRealNameOfGuestLoginWithLock:YES responder:responder];
        }
            break;
    }
}

- (void)checkRealNameOfGuestLoginWithLock:(BOOL)isLock responder:(JMResponder *)responder {
    JMResponder *localResponder = [JMResponder success:^(NSDictionary *info) {
        //绑定成功, 跳转到手机登录用户的检查流程
        [self checkRealNameOfLoginWithResponder:responder];
    } cancel:responder.cancel];
    
    if (isLock) {
        [self showLoginBoundModalViewWithLock:isLock
                                hasRegisterCL:YES
                                    responder:localResponder];
    } else {
        [self showBoundTipsModalViewWithLock:isLock responder:localResponder];
    }
}

- (void)showRealNameAuthenticationViewWithLock:(BOOL)isLock responder:(JMResponder *)responder {
    [[[JMBoomRealNameAuthenticationModalView alloc] initWithLock:isLock] show:[JMResponder success:^(NSDictionary *info) {
        //实名认证成功，记录 “实名认证确认”标识
        [self localkRealNameVerifyCompleted];
        responder.success(info);
    } cancel:^{
        responder.cancel();
    }]];
}


@end
