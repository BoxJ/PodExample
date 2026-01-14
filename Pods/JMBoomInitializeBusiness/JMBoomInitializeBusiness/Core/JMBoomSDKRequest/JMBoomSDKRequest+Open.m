//
//  JMBoomSDKRequest+Open.m
//  JMBoomInitializeBusiness
//
//  Created by ZhengXianda on 2021/9/8.
//

#import "JMBoomSDKRequest+Open.h"

@implementation JMBoomSDKRequest (Open)

- (void)queryOpenPrivacyPolicyWithAppId:(NSString *)appId
                               callback:(JMRequestCallback)callback {
    NSString *path = @"/open/privacyPolicy";
    NSDictionary *parameters = @{
        @"appId": appId?:@"",
        @"phoneType": @2,
    };
    
    [self requestDataWithMethod:JMRequestMethodType_GET
                           path:path
                     parameters:parameters
                       callback:callback];
}

@end
