//
//  JMBoomSDKBusiness+RechargeUI.m
//  JMBoomSDK
//
//  Created by Thief Toki on 2021/2/5.
//

#import "JMBoomSDKBusiness+JMBoomRechargeBusinessUI.h"

#import "JMBoomRechargeBusiness.h"
#import "JMBoomRechargeBusinessMock.h"

@interface JMBoomRechargeBusinessUIProperty : NSObject

@property (nonatomic, assign) BOOL isShowing;

@property (nonatomic, strong, nullable) JMBusinessCallback callback;
@property (nonatomic, strong, nullable) NSString *orderNo;
@property (nonatomic, strong, nullable) NSString *productId;
@property (nonatomic, strong, nullable) NSString *subject;
@property (nonatomic, strong, nullable) NSString *body;
@property (nonatomic, assign) int32_t amount;

@end

@implementation JMBoomRechargeBusinessUIProperty

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

@implementation JMBoomSDKBusiness (JMBoomRechargeBusinessUI)

- (void)showRechargeViewWithOrderNo:(NSString *)orderNo
                          productId:(NSString *)productId
                            subject:(NSString *)subject
                               body:(NSString *)body
                             amount:(int32_t)amount
                           callback:(JMBusinessCallback)callback {
    if ([JMBoomRechargeBusinessUIProperty shared].isShowing) {
        JMLog(@"当前流程正在展示中，请勿重复调用");
        return;
    }
    [JMBoomRechargeBusinessUIProperty shared].isShowing = YES;
    
    [JMBoomRechargeBusinessUIProperty shared].callback = callback;
    [JMBoomRechargeBusinessUIProperty shared].orderNo = orderNo;
    [JMBoomRechargeBusinessUIProperty shared].productId = productId;
    [JMBoomRechargeBusinessUIProperty shared].subject = subject;
    [JMBoomRechargeBusinessUIProperty shared].body = body;
    [JMBoomRechargeBusinessUIProperty shared].amount = amount;
    
    if (JMBoomSDKBusiness.config.guestIdentity) {
        [self recharge_phoneLogin];
    } else {
        switch (JMBoomSDKBusiness.info.registerType) {
            case JMBoomRegisterType_Phone: {
                [self recharge_phoneLogin];
                break;
            }
            case JMBoomRegisterType_Guest: {
                [self recharge_guest];
                break;
            }
        }
    }
}

- (void)recharge_phoneLogin {
    switch (JMBoomSDKBusiness.config.payRealNameVerify) {
        case JMBoomSDKConfigPayRealNameVerifyType_None:{
            //手机号充值：不开启实名认证：充值继续
            [self recharge_limitCheck];
            break;
        }
        case JMBoomSDKConfigPayRealNameVerifyType_Open:{
            //手机号充值：开启实名认证：填写实名认证(可关闭)；若流程中断，充值终止
            [self recharge_realNameAuthenticationView];
            break;
        }
    }
}

- (void)recharge_guest {
    switch (JMBoomSDKBusiness.config.payRealNameVerify) {
        case JMBoomSDKConfigPayRealNameVerifyType_None:{
            //游客充值(未开启实名认证)：充值继续
            [self recharge_limitCheck];
            break;
        }
        case JMBoomSDKConfigPayRealNameVerifyType_Open:{
            //游客充值(开启实名认证)：弹出绑定手机号提示->绑定手机号(可关闭)->填写实名认证(可关闭)；若流程中断，充值终止
            BOOL isLock = NO;
            [[JMBoomSDKBusiness shared] showBoundTipsModalViewWithResponder:[JMResponder success:^(NSDictionary *info) {
                [[JMBoomSDKBusiness shared] showRechargeBoundModalViewWithLock:isLock
                                                               hasRegisterCL:YES
                                                                   responder:[JMResponder success:^(NSDictionary *info) {
                    [self recharge_realNameAuthenticationView];
                } cancel:^{
                   //用户取消绑定手机号
                   [self rechargeCallbackFailed:[NSError boom_bound_cancel]];
               }]];
            } cancel:^{
                //用户取消绑定手机号
                [self rechargeCallbackFailed:[NSError boom_bound_cancel]];
            }]];
            break;
        }
    }
}

- (void)recharge_realNameAuthenticationView {
    [[JMBoomSDKBusiness shared] checkRealNameStatusWithResponder:[JMResponder success:^(NSDictionary *info) {
        //用户已实名认证
        [self recharge_limitCheck];
    } failed:^(NSError *error) {
        //获取用户实名认证状态失败
        [JMRktDialog showError:error];
        [self rechargeCallbackFailed:error];
    } cancel:^{
        //用户需要实名认证
        [[JMBoomSDKBusiness shared] showRealNameAuthenticationViewWithLock:NO responder:[JMResponder success:^(NSDictionary *info) {
            [self recharge_limitCheck];
        } cancel:^{
            //用户取消实名认证
            [self rechargeCallbackFailed:[NSError boom_verify_cancel]];
        }]];
    }]];
}

- (void)recharge_limitCheck {
    [JMToast showToastLoading];
    [[JMBoomSDKBusiness shared] rechargeLimitCheckWithAmount:[JMBoomRechargeBusinessUIProperty shared].amount
                                           callback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            [JMRktDialog showError:error];
            [self rechargeCallbackFailed:error];
        } else {
            [JMToast dismissToast];
            //读取服务器限额检查结果
            NSDictionary *result = responseObject[@"result"];
            if (![result isKindOfClass:[NSDictionary class]]) {
                [self rechargeCallbackFailed:[NSError boom_common:@"解析服务器数据失败"]];
                return;
            }
            //解析限额检查结果
            if ([result[@"limitSwitch"]?:@(NO) boolValue]) {
                //限额开启
                if ([result[@"pass"]?:@(NO) boolValue]) {
                    //通过限额检查
                    [self recharge];
                } else {
                    //未通过限额检查
                    [[[JMTipsModalView alloc] initWithTitle:result[@"title"]?:@"提示"
                                                   message:result[@"toast"]?:@"支付限额"
                                              confirmTitle:@"确认"]
                     show];
                    [self rechargeCallbackFailed:[NSError boom_common:@"支付限额"]];
                }
            } else {
                //限额关闭
                [self recharge];
            }
        }
    }];
}

- (void)recharge {
    if ([JMBoomRechargeBusinessUIProperty shared].orderNo) {
        [JMToast showToastLoading];
        [[JMBoomSDKBusiness shared] rechargeWithOrderNo:[JMBoomRechargeBusinessUIProperty shared].orderNo
                                     productId:[JMBoomRechargeBusinessUIProperty shared].productId
                                       subject:[JMBoomRechargeBusinessUIProperty shared].subject
                                          body:[JMBoomRechargeBusinessUIProperty shared].body
                                        amount:[JMBoomRechargeBusinessUIProperty shared].amount
                                      callback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
            if (error) {
                if (error.code == JMBoomSDKReportCode_RechargeCancel){
                    //充值取消
                    [JMToast dismissToast];
                } else {
                    //充值报错
                    [JMRktDialog showError:error];
                }
                [self rechargeCallbackFailed:error];
            } else {
                [JMToast showToastSuccess:@"充值成功"];
                [self rechargeCallbackSuccess:responseObject];
            }
        }];
        [JMBoomRechargeBusinessUIProperty shared].orderNo = nil;
    }
}

- (void)rechargeCallbackSuccess:(NSDictionary *)responseObject {
    if ([JMBoomRechargeBusinessUIProperty shared].callback) {
        [JMBoomRechargeBusinessUIProperty shared].callback(responseObject, nil);
        [JMBoomRechargeBusinessUIProperty shared].callback = nil;
    }
    [JMBoomRechargeBusinessUIProperty shared].isShowing = NO;
}

- (void)rechargeCallbackFailed:(NSError *)error {
    if ([JMBoomRechargeBusinessUIProperty shared].callback) {
        [JMBoomRechargeBusinessUIProperty shared].callback(error.responseValue, error);
        [JMBoomRechargeBusinessUIProperty shared].callback = nil;
    }
    [JMBoomRechargeBusinessUIProperty shared].isShowing = NO;
}

@end
