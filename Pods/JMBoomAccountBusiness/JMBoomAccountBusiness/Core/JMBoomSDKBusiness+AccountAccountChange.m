//
//  JMBoomSDKBusiness+AccountAccountChange.m
//  JMBoomSDK
//
//  Created by Thief Toki on 2024/2/21.
//

#import "JMBoomSDKBusiness+AccountAccountChange.h"

#import <JMRktCommon/JMRktCommon.h>

#import "JMBoomAccountBusiness.h"

#import "JMBoomSDKWeb+Account.h"

@implementation JMBoomSDKBusiness (AccountAccountChange)

- (void)accountChangeWithCallback:(JMBusinessCallback)callback {
    switch (JMBoomSDKBusiness.info.registerType) {
        case JMBoomRegisterType_Phone: {
            [self accountChangeUnderVerifyWithCallback:callback];
        }
            break;
        case JMBoomRegisterType_Guest: {
            if (callback) {
                NSError *error = [NSError boom_changeaccount_disabled];
                callback(error.responseValue, error);
            }
        }
            break;
    }
}

- (void)accountChangeUnderVerifyWithCallback:(JMBusinessCallback)callback {
    [self accountChangeVerifyWithCallback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            if (callback) {
                callback(error.responseValue, error);
            }
        } else {
            [[[JMBoomSDKWeb alloc] initChangeAccountWithVerifyCodeLength:JMBoomSDKBusiness.config.codeLength]
             show:[JMResponder success:^(NSDictionary *info) {
                [[JMBoomSDKBusiness shared] logout];
                [[JMRktBroadcaster shared] sendError:[NSError boom_login_out]];
                if (callback) {
                    callback(info, nil);
                }
            } cancel:^{
                if (callback) {
                    NSError *error = [NSError boom_changeaccount_cancel];
                    callback(error.responseValue, error);
                }
            }]];
        }
    }];
}

@end
