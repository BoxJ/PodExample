//
//  JMBoomSDKWeb.m
//  JMBoomSDK
//
//  Created by ZhengXianda on 11/2/22.
//

#import "JMBoomSDKWeb.h"

#import "JMBoomSDKResource.h"
#import "JMBoomSDKConfig.h"
#import "JMBoomSDKRequest.h"
#import "JMBoomSDKInfo.h"

@implementation JMBoomSDKWeb

- (instancetype)init {
    self = [super init];
    if (self) {
        [self registerBaseURL:JMBoomSDKConfig.webBaseURL
                    paramHook:^NSDictionary<NSString *,id> * _Nonnull{
            return @{
                @"header": [[JMBoomSDKRequest shared].baseHeaderConfig
                            infoByAppendingInfo:@{}
                            signKey:@""
                            signOrder:@[]
                            secretKey:[JMBoomSDKInfo shared].secretKey],
                @"other": @{
                        @"appId" : [JMBoomSDKInfo shared].appId?:@"",
                        @"secretKey" : [JMBoomSDKInfo shared].secretKey?:@"",
                        @"signatureMethod" : [JMBoomSDKInfo shared].signatureMethod?:@"",
                        @"bundleId" : [JMBoomSDKInfo shared].bundleId?:@"",
                        @"appVersion" : [JMBoomSDKInfo shared].appVersion?:@"",
                        @"SDKVersion" : JMBoomSDKConfig.version?:@"",
                        @"imsi" : [JMBoomSDKInfo shared].IMSI?:@"",
                        @"model" : [JMBoomSDKInfo shared].model?:@"",
                        @"version" : [JMBoomSDKInfo shared].version?:@"",
                        @"resolution" : [JMBoomSDKInfo shared].resolution?:@"",
                        @"ptype" : [JMBoomSDKInfo shared].ptype?:@"",
                        @"env" : [JMBoomSDKInfo shared].env?:@"",
                        @"idfa" : [JMBoomSDKInfo shared].IDFA?:@"",
                        @"uid" : [JMBoomSDKInfo shared].UID?:@"",
                        @"uniqueId" : [JMBoomSDKInfo shared].uniqueId?:@"",
                        @"token" : [JMBoomSDKInfo shared].token?:@"",
                        @"openId" : [JMBoomSDKInfo shared].openId?:@"",
                        @"isRegister" : @([JMBoomSDKInfo shared].isRegister)?:@0,
                        @"nickname" : [JMBoomSDKInfo shared].nickname?:@"",
                        @"registerType" : @([JMBoomSDKInfo shared].registerType)?:@0,
                        @"networkReachabilityStatus" : @([JMBoomSDKRequest shared].networkReachabilityStatus)?:@0,
                },
                @"origin": [JMBoomSDKConfig.webBaseURL stringByAppendingString:@"/"],
            };
        } themeHook:^NSDictionary<NSString *,id> * _Nonnull{
            return @{
                @"JMBRNButtonBackgroundColor": [[JMBoomSDKResource shared] resourceValueWithName:JMBRNButtonBackgroundColor],
                @"JMBRNButtonTitleFont": [[JMBoomSDKResource shared] resourceValueWithName:JMBRNButtonTitleFont],
                @"JMBRNButtonConfirmTitleColor": [[JMBoomSDKResource shared] resourceValueWithName:JMBRNButtonConfirmTitleColor],
                @"JMBRNButtonCancelTitleColor": [[JMBoomSDKResource shared] resourceValueWithName:JMBRNButtonCancelTitleColor],
                @"JMBRNWindowTitleFont": [[JMBoomSDKResource shared] resourceValueWithName:JMBRNWindowTitleFont],
                @"JMBRNWindowCheckboxSelectedTintColor": [[JMBoomSDKResource shared] resourceValueWithName:JMBRNWindowCheckboxSelectedTintColor],
                @"JMBRNWindowPhoneIconTintColor": [[JMBoomSDKResource shared] resourceValueWithName:JMBRNWindowPhoneIconTintColor],
                @"JMBRNWindowGuestIconTintColor": [[JMBoomSDKResource shared] resourceValueWithName:JMBRNWindowGuestIconTintColor],
            };
        }];
    }
    return self;
}

- (void)setupBridge {
    [super setupBridge];
}

@end
