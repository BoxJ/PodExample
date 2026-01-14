//
//  JMBoomSDKBusiness+JMBoomRealNameBusiness.m
//  JMBoomSDK
//
//  Created by Thief Toki on 2021/2/4.
//

#import "JMBoomSDKBusiness+JMBoomRealNameBusiness.h"

#import "JMBoomSDKRequest+JMBoomRealNameBusiness.h"

@implementation JMBoomSDKBusiness (JMBoomRealNameBusiness)

///实名认证确认标识（用户id）
#define kBoomRealNameVerifyCompletedKey(openId) [NSString stringWithFormat:@"RealNameVerifyCompletedKey_%@", openId]

- (void)localkRealNameVerifyCompleted {
    NSString *userKey = kBoomRealNameVerifyCompletedKey(JMBoomSDKBusiness.info.openId);
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:userKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isLocalkRealNameVerifyCompleted {
    NSString *userKey = kBoomRealNameVerifyCompletedKey(JMBoomSDKBusiness.info.openId);
    return [[NSUserDefaults standardUserDefaults] boolForKey:userKey];
}

- (void)identityStatusWithCallback:(JMBusinessCallback)callback {
    [JMBoomSDKBusiness.request identityStatusWithCallback:callback];
}

- (void)identityVerifyWithIdCardNumber:(NSString *)idCardNumber
                        realName:(NSString *)realName
                        callback:(JMBusinessCallback)callback {
    [JMBoomSDKBusiness.request identityVerifyWithIdCardNumber:idCardNumber
                                                   realName:realName
                                                   callback:callback];
}

@end
