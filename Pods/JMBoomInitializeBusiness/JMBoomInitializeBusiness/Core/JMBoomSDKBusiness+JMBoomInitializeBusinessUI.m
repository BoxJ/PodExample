//
//  JMBoomSDKBusiness+JMBoomInitializeBusinessUI.m
//  JMBoomInitializeBusiness
//
//  Created by Thief Toki on 2021/2/4.
//

#import "JMBoomSDKBusiness+JMBoomInitializeBusinessUI.h"

#import <JMUIKit/JMUIKit.h>
#import <JMRktCommon/JMRktCommon.h>

#import <JMBoomSDKBase/JMBoomSDKBase.h>

#import "JMBoomAgreementModalView.h"
#import "JMBoomErrorModalView.h"

#import "JMBoomInitializeBusiness.h"

#import "JMBoomSDKRequest+Open.h"

@interface JMBoomSDKBusinessBoomInitializeUIProperty : NSObject

@property (nonatomic, assign) BOOL isShowing;

@property (nonatomic, strong) NSString *appId;
@property (nonatomic, strong) NSString *secretKey;
@property (nonatomic, assign) BOOL hasTracking;
@property (nonatomic, strong, nullable) JMBusinessCallback callback;

@end

@implementation JMBoomSDKBusinessBoomInitializeUIProperty

+ (instancetype)shared {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

@end

@implementation JMBoomSDKBusiness (JMBoomInitializeBusinessUI)

- (void)initializeUIApp:(NSString *)appId
              secretKey:(NSString *)secretKey
            hasTracking:(BOOL)hasTracking
               callback:(JMBusinessCallback)callback {
    if ([JMBoomSDKBusinessBoomInitializeUIProperty shared].isShowing) {
        JMLog(@"当前流程正在展示中，请勿重复调用");
        return;
    }
    
    [JMBoomSDKBusinessBoomInitializeUIProperty shared].isShowing = YES;
    
    [JMBoomSDKBusinessBoomInitializeUIProperty shared].appId = appId;
    [JMBoomSDKBusinessBoomInitializeUIProperty shared].secretKey = secretKey;
    [JMBoomSDKBusinessBoomInitializeUIProperty shared].hasTracking = hasTracking;
    [JMBoomSDKBusinessBoomInitializeUIProperty shared].callback = callback;
    
    [self queryPreAgreement];
}

- (void)initializeUIApp:(NSString *)appId
              secretKey:(NSString *)secretKey
               callback:(JMBusinessCallback)callback {
    [self initializeUIApp:appId
                secretKey:secretKey
              hasTracking:NO
                 callback:callback];
}

- (void)queryPreAgreement {
    JMLog(@"初始化前，获取隐私协议");
    [JMBoomSDKBusiness.request queryOpenPrivacyPolicyWithAppId:[JMBoomSDKBusinessBoomInitializeUIProperty shared].appId
                                                    callback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            JMLog(@"获取前置隐私协议失败：%@", error.message);
            [[[JMBoomErrorModalView alloc] init] show:[JMResponder success:^(NSDictionary *info) {
                [self queryPreAgreement];
            }]];
        } else {
            JMLog(@"获取前置隐私协议成功");
            NSDictionary *result = responseObject[@"result"];
            NSString *privacyPolicy = result[@"privacyPolicy"];//用户协议提示文案
            NSString *privacyPolicyVersion = result[@"privacyPolicyVersion"];//用户协议版本号
            [JMBoomSDKBusiness.info updateLocalAgreement:privacyPolicyVersion content:privacyPolicy];
            
            [self showAgreementAlert];
        }
    }];
}

- (void)showAgreementAlert {
    JMResponder *responder = [JMResponder success:^(NSDictionary *info) {
        //同意用户协议，记录用户协议已确认标识，记录用户协议已同意标识
        [JMBoomSDKBusiness.info localAgreementFinished];
        [JMBoomSDKBusiness.event recordEvent:[JMBoomSDKEventItem event:JMBoomSDKEventId_Agreement_Through]];

        [self registerApp];
    } cancel:^{
        [self showAgreementDisagreeConfirmAlert];
    }];
    
    //判断是否以完成用户协议确认，若以完成，则执行成功事件。
    BOOL isFinish = [JMBoomSDKBusiness.info isLocalAgreementFinished];
    if (isFinish) {
        responder.success(@{});
        return;
    }
        
    [[[JMBoomAgreementModalView alloc] initWithMessage:[JMBoomSDKBusiness.info localAgreementContent]]
     show:responder];
}

- (void)showAgreementDisagreeConfirmAlert {
    JMResponder *responder = [JMResponder success:^(NSDictionary *info) {
        [self showAgreementAlert];
    } cancel:^{
        JMLog(@"%@", @"用户不同意协议内容");
        exit(0);
    }];
    
    [[[JMTipsModalView alloc] initWithTitle:@"提示"
                                    message:@"你是否放弃体验该游戏？"
                               confirmTitle:@"取消"
                                cancelTitle:@"确定"]
     show:responder];
}


- (void)registerApp {
    [JMToast showToastLoading];
    [[JMBoomSDKBusiness shared] initializeApp:[JMBoomSDKBusinessBoomInitializeUIProperty shared].appId
                                  secretKey:[JMBoomSDKBusinessBoomInitializeUIProperty shared].secretKey
                                hasTracking:[JMBoomSDKBusinessBoomInitializeUIProperty shared].hasTracking
                                   callback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        [JMToast dismissToast];
        if (error) {
            JMLog(@"初始化失败：%@", error.message);
            [[[JMBoomErrorModalView alloc] init] show:[JMResponder success:^(NSDictionary *info) {
                [self registerApp];
            }]];
        } else {
            if ([JMBoomSDKBusinessBoomInitializeUIProperty shared].callback) {
                [JMBoomSDKBusinessBoomInitializeUIProperty shared].callback([JMRktResponse success], nil);
            }
            [JMBoomSDKBusinessBoomInitializeUIProperty shared].isShowing = NO;
        }
    }];
}

@end
