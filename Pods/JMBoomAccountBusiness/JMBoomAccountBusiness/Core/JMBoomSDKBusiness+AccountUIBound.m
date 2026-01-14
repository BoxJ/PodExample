//
//  JMBoomSDKBusiness+AccountUIBound.m
//  JMBoomSDK
//
//  Created by Thief Toki on 2021/2/4.
//

#import "JMBoomSDKBusiness+AccountUIBound.h"

#import "JMBoomCLManager.h"

#import "JMQuickBindPhoneModalView.h"
#import "JMBoomBindPhoneModalView.h"

#import "JMBoomAccountBusinessMock.h"

@implementation JMBoomSDKBusiness (AccountUIBound)

- (void)showBoundTipsModalViewWithResponder:(JMResponder *)responder {
    if (JMBoomSDKBusiness.config.guestIdentity) {
        //绑定成功
        responder.success(@{});
    } else {
        [[[JMTipsModalView alloc] initWithTitle:@"提示"
                                      message:@"游客模式有可能造成游戏数据的丢失，我们强烈建议您绑定手机号。"
                                 confirmTitle:@"绑定手机"
                                  cancelTitle:@"取消"]
         show:responder];
    }
}

- (void)showLoginBoundModalViewWithLock:(BOOL)isLock
                          hasRegisterCL:(BOOL)hasRegisterCL
                              responder:(JMResponder *)responder {
    [self showBoundModalViewWithLock:isLock
                       hasRegisterCL:hasRegisterCL
                                type:JMBoomBindPhoneType_Login
                           responder:responder];
}

- (void)showRechargeBoundModalViewWithLock:(BOOL)isLock
                             hasRegisterCL:(BOOL)hasRegisterCL
                                 responder:(JMResponder *)responder {
    [self showBoundModalViewWithLock:isLock
                       hasRegisterCL:hasRegisterCL
                                type:JMBoomBindPhoneType_Recharge
                           responder:responder];
}

- (void)showBoundModalViewWithLock:(BOOL)isLock
                    hasRegisterCL:(BOOL)hasRegisterCL
                             type:(JMBoomBindPhoneType)type
                        responder:(JMResponder *)responder {
    __weak typeof(self) weakSelf = self;
    if (JMBoomSDKBusiness.config.guestIdentity) {
        //绑定成功
        responder.success(@{});
    } else {
        BOOL hasCL = [JMBoomSDKBusiness.config.loginStyle containsObject:kJMBoomSDKConfigLoginStyle_CL];
        BOOL hasNumber = [JMBoomCLManager shared].number.length > 0;

        JMModalView *modaView;
        if (hasCL && hasNumber) {
            JMLog(@"展示创蓝一键绑定");
            [JMBoomSDKBusiness.event uploadEvent:[JMBoomSDKEventItem event:JMBoomSDKEventId_CL_GetPhone exStrs:@[@"1", @"0"]]];
            JMLog(@"JMBoom Event = JMBoomSDKEventId_CL_GetPhone:1,0");
            
            modaView = [[JMQuickBindPhoneModalView alloc] initWithNumber:[JMBoomCLManager shared].number
                                                            operatorName:[JMBoomCLManager shared].operatorName
                                                            protocolName:[JMBoomCLManager shared].protocolName
                                                             protocolUrl:[JMBoomCLManager shared].protocolUrl
                                                        verifyCodeLength:JMBoomSDKBusiness.config.codeLength
                                                                    lock:isLock
                                                                    type:type];
        } else {
            if (hasRegisterCL) {
                [[JMBoomCLManager shared] getPhoneNumberWithEventCallback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
                    [weakSelf showBoundModalViewWithLock:isLock hasRegisterCL:NO type:type responder:responder];
                }];
            } else {
                JMLog(@"展示手机号绑定");
                [JMBoomSDKBusiness.event uploadEvent:[JMBoomSDKEventItem event:JMBoomSDKEventId_CL_GetPhone exStrs:@[@"1", @"1"]]];
                JMLog(@"JMBoom Event = JMBoomSDKEventId_CL_GetPhone:1,1");
                
                modaView = [[JMBoomBindPhoneModalView alloc] initWithLock:isLock
                                                                type:type
                                                    verifyCodeLength:JMBoomSDKBusiness.config.codeLength];
            }
        }
        [[modaView registerStack]
         show:[JMResponder success:^(NSDictionary *info) {
            //转正成功，检查用户实名信息
            [weakSelf checkRealNameStatusConfirmWithResponder:[JMResponder success:^(NSDictionary *_) {
                //已实名
                responder.success(info);
            } failed:^(NSError *error) {
                //检查实名认证信息失败
                responder.success(info);
            } cancel:^{
                //未实名
                responder.success(info);
            }]];
        } cancel:^{
            //用户取消转正
            responder.cancel();
        }]];
    }
}

- (void)showBoundTipsModalViewWithLock:(BOOL)isLock responder:(JMResponder *)responder {
    __weak typeof(self) weakSelf = self;
    if (JMBoomSDKBusiness.config.guestIdentity) {
        //绑定成功
        responder.success(@{});
    } else {
        //展示绑定手机号提示
        [weakSelf showBoundTipsModalViewWithResponder:[JMResponder success:^(NSDictionary *info) {
            //去绑定
            [weakSelf showBoundModalViewWithLock:isLock
                                   hasRegisterCL:YES
                                            type:JMBoomBindPhoneType_Login
                                       responder:[JMResponder success:^(NSDictionary *info) {
                //绑定成功
                responder.success(@{});
            } cancel:^{
                //用户关闭绑定页面
                responder.cancel();
            }]];
        } cancel:^{
            //不去绑定
            responder.cancel();
        }]];
    }
}


- (void)showBoundChangeTriggerRealNameAuthenticationTipsModalViewWithResponder:(JMResponder *)responder {
    [[[JMTipsModalView alloc] initWithTitle:@"提示"
                                   message:@"更换手机号需要先进行实名认证，是否进行实名认证？"
                              confirmTitle:@"确认"
                               cancelTitle:@"取消"]
     show:responder];
}

@end
