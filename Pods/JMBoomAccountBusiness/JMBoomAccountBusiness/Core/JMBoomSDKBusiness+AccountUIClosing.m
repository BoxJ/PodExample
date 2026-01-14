//
//  JMBoomSDKBusiness+AccountUIClosing.m
//  JMBoomSDK
//
//  Created by Thief Toki on 2021/2/5.
//

#import "JMBoomSDKBusiness+AccountUIClosing.h"

#import <JMRktCommon/JMRktCommon.h>

#import "JMBoomAccountBusiness.h"

#import "JMBoomSDKWeb+Account.h"

@implementation JMBoomSDKBusiness (AccountUIClosing)

- (void)showAccountClosingWithWaitingDays:(NSUInteger)waitingDays callback:(JMBusinessCallback)callback {
    [[JMBoomSDKBusiness.web initAccountClosingWithVerifyCodeLength:JMBoomSDKBusiness.config.codeLength waitingDays:waitingDays]
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

@end
