//
//  JMBoomSDKBusiness+AccountUIAccountChange.m
//  JMBoomSDK
//
//  Created by Thief Toki on 2021/2/4.
//

#import "JMBoomSDKBusiness+AccountUIAccountChange.h"

#import <JMRktCommon/JMRktCommon.h>
#import <JMBoomSDKBase/JMBoomSDKBase.h>

#import "JMBoomAccountBusiness.h"
#import "JMBoomAccountBusinessMock.h"

#import "JMBoomSDKWeb+Account.h"

@implementation JMBoomSDKBusiness (AccountUIAccountChange)

- (void)showAccountChangeView {
    __weak typeof(self) weakSelf = self;
    switch (JMBoomSDKBusiness.info.registerType) {
        case JMBoomRegisterType_Phone: {
            //手机号登录成功，开启不强制实名认证：填写实名认证(可关闭)
            //正式用户：开启实名认证：填写实名认证(可关闭)；若流程中断，充值终止
            [self checkRealNameStatusWithResponder:[JMResponder success:^(NSDictionary *info) {
                //用户已实名
                [weakSelf accountChangeUnderVerify];
            } failed:^(NSError *error) {
                //用户实名状态获取失败
                [JMRktDialog showError:error];
            } cancel:^{
                //询问用户是否需要进行实名认证
                [weakSelf showBoundChangeTriggerRealNameAuthenticationTipsModalViewWithResponder:[JMResponder success:^(NSDictionary *info) {
                    [weakSelf showRealNameAuthenticationViewWithLock:NO responder:[JMResponder success:^(NSDictionary *info) {
                        //用户实名认证成功
                    } cancel:^{
                        //用户取消实名认证
                    }]];
                } cancel:^{
                    //用户取消实名认证
                }]];
            }]];
            break;
        }
        case JMBoomRegisterType_Guest: {
            [JMToast showToast:@"游客账号无法使用"];
            break;
        }
    }
}

- (void)accountChangeUnderVerify {
    [self accountChangeVerifyWithCallback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            [JMRktDialog showError:error];
        } else {
            [[JMBoomSDKBusiness.web initChangeAccountWithVerifyCodeLength:JMBoomSDKBusiness.config.codeLength]
             show:[JMResponder success:^(NSDictionary *info) {
                [[JMBoomSDKBusiness shared] logout];
                [[JMRktBroadcaster shared] sendError:[NSError boom_login_out]];
                [[[JMTipsModalView alloc] initWithTitle:@"提示"
                                                    message:@"更换手机号成功，请重新登录游戏"
                                               confirmTitle:@"确认"]
                 show:[JMResponder responder]];
            }]];
        }
    }];
}

@end
