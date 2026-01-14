//
//  JMBoomSDKBusiness+AccountUILocalLogin.m
//  JMBoomAccountBusiness
//
//  Created by Thief Toki on 2021/3/30.
//

#import "JMBoomSDKBusiness+AccountUILocalLogin.h"

#import <JMRktCommon/JMRktCommon.h>

#import "JMBoomCLManager.h"

#import "JMBoomQuickLoginModalView.h"
#import "JMBoomPhoneLoginModalView.h"
#import "JMBoomAutoLoginHintView.h"
#import "JMBoomLoginSuccessHintView.h"

#import "JMBoomAccountBusiness.h"
#import "JMBoomAccountBusinessMock.h"

@interface JMBoomSDKBusinessAccountUILocalLoginProperty : NSObject

@property (nonatomic, assign) BOOL isShowing;

@property (nonatomic, strong, nullable) JMBusinessCallback callback;
@property (nonatomic, strong) NSDictionary *loginResponse;

@end

@implementation JMBoomSDKBusinessAccountUILocalLoginProperty

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

@implementation JMBoomSDKBusiness (AccountUILocalLogin)

- (void)showLocalLoginViewWithCallback:(JMBusinessCallback)callback {
    if ([JMBoomSDKBusinessAccountUILocalLoginProperty shared].isShowing) {
        JMLog(@"当前流程正在展示中，请勿重复调用");
        return;
    }
    [JMBoomSDKBusinessAccountUILocalLoginProperty shared].isShowing = YES;
    
    if (JMBoomSDKBusiness.info.token.length > 0 && [JMBoomSDKBusiness.info isLocalAgreementThrough]) {
        [self autoLocalLoginWithCallback:callback];
    } else {
        [self localLoginWithCallback:callback];
    }
}

- (void)autoLocalLoginWithCallback:(JMBusinessCallback)callback {
    [JMBoomSDKBusinessAccountUILocalLoginProperty shared].callback = callback;
    
    __weak typeof(self) weakSelf = self;
    [self loginWithCallback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            [weakSelf localLoginWithCallback:callback];
        } else {
            [JMBoomSDKBusinessAccountUILocalLoginProperty shared].loginResponse = responseObject;
            [weakSelf localLoginSuccessCheck_identityStatusConfirm];
        }
    }];
}

- (void)localLoginWithCallback:(JMBusinessCallback)callback {
    [JMBoomSDKBusinessAccountUILocalLoginProperty shared].callback = callback;
    
    __weak typeof(self) weakSelf = self;
    [self guestLoginWithCallback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            [weakSelf localLoginFailed:error];
        } else {
            [JMBoomSDKBusinessAccountUILocalLoginProperty shared].loginResponse = responseObject;
            [weakSelf localLoginSuccessCheck_identityStatusConfirm];
        }
    }];
}

- (void)localLoginSuccessCheck_identityStatusConfirm {
    __weak typeof(self) weakSelf = self;
    [[JMBoomSDKBusiness shared] checkRealNameStatusConfirmWithResponder:[JMResponder success:^(NSDictionary *info) {
        //已完成“实名认证确认”
        [weakSelf localLoginSuccessCheck_antiAddiction];
    } failed:^(NSError *error) {
        [weakSelf localLoginFailed:error];
    } cancel:^{
        //未实名
        [weakSelf localLoginSuccessCheck_antiAddiction];
    }]];
}

- (void)localLoginSuccessCheck_antiAddiction {
    __weak typeof(self) weakSelf = self;
    JMResponder *responder = [JMResponder success:^(NSDictionary *info) {
        [weakSelf localLoginSuccess];
    } failed:^(NSError *error) {
        [weakSelf localLoginFailed:error];
    } cancel:^{
        [weakSelf localLoginSuccess];
    }];
    
    if (JMBoomSDKBusiness.config.antiAddictionSwitch) {
        [[JMBoomSDKBusiness shared] checkRealNameOfLoginWithResponder:responder];
    } else {
        [[JMBoomSDKBusiness shared] checkAntiAddiction:responder];
    }
}

- (void)localLoginFailed:(NSError *)error {
    if ([JMBoomSDKBusinessAccountUILocalLoginProperty shared].callback) {
        [JMBoomSDKBusinessAccountUILocalLoginProperty shared].callback(error.responseValue, error);
    }
    [JMBoomSDKBusinessAccountUILocalLoginProperty shared].isShowing = NO;
}

- (void)localLoginSuccess {
    //反馈登录成功信息
    if ([JMBoomSDKBusinessAccountUILocalLoginProperty shared].callback) {
        [JMBoomSDKBusinessAccountUILocalLoginProperty shared].callback([JMBoomSDKBusinessAccountUILocalLoginProperty shared].loginResponse?:@{}, nil);
        [JMBoomSDKBusinessAccountUILocalLoginProperty shared].callback = nil;
    }
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
    [JMBoomSDKBusinessAccountUILocalLoginProperty shared].isShowing = NO;
}

@end

