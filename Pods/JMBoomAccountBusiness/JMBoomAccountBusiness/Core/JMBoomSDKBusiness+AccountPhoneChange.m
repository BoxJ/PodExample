//
//  JMBoomSDKBusiness+AccountPhoneChange.m
//  JMBoomSDK
//
//  Created by Thief Toki on 2021/2/4.
//

#import "JMBoomSDKBusiness+AccountPhoneChange.h"

#import <JMRktCommon/JMRktCommon.h>

#import "JMBoomAccountBusiness.h"

#import "JMBoomSDKWeb+Account.h"

@implementation JMBoomSDKBusiness (AccountPhoneChange)

- (void)phoneChangeWithCallback:(JMBusinessCallback)callback {
    switch (JMBoomSDKBusiness.info.registerType) {
        case JMBoomRegisterType_Phone: {
            [self phoneChangeUnderVerifyWithCallback:callback];
        }
            break;
        case JMBoomRegisterType_Guest: {
            if (callback) {
                NSError *error = [NSError boom_changephone_disabled];
                callback(error.responseValue, error);
            }
        }
            break;
    }
}

- (void)phoneChangeUnderVerifyWithCallback:(JMBusinessCallback)callback {
    [self phoneChangeVerifyWithCallback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            if (callback) {
                callback(error.responseValue, error);
            }
        } else {
            [[[JMBoomSDKWeb alloc] initChangePhoneWithVerifyCodeLength:JMBoomSDKBusiness.config.codeLength]
             show:[JMResponder success:^(NSDictionary *info) {
                [[JMBoomSDKBusiness shared] logout];
                [[JMRktBroadcaster shared] sendError:[NSError boom_login_out]];
                if (callback) {
                    callback(info, nil);
                }
            } cancel:^{
                if (callback) {
                    NSError *error = [NSError boom_changephone_cancel];
                    callback(error.responseValue, error);
                }
            }]];
        }
    }];
}

@end
