//
//  JMBoomSDKRequest.m
//  JMBoomSDK
//
//  Created by ZhengXianda on 11/2/22.
//

#import "JMBoomSDKRequest.h"

//#import <JMNTESManager/JMNTESManager.h>

#import "JMBoomSDKConfig.h"
#import "JMBoomSDKInfo.h"

@implementation JMBoomSDKRequest

#pragma mark - shared

+ (JMBoomSDKRequest *)shared {
    static JMBoomSDKRequest * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self registerBaseURL:^NSString * _Nonnull{
            return JMBoomSDKConfig.requestBaseURL;
        }
                    secretKey:^NSString * _Nonnull{
            return [JMBoomSDKInfo shared].secretKey;
        }
                   verifyHook:^(JMRktCommonCallback _Nonnull callback) {
            /* - 该服务已经下线，直接返回成功
            [[JMNTESManager shared] getTokenWithCallback:^(NSError * _Nullable error) {
                if (error) {
                    NSError *localError = [JMRktResponse errorWithCode:error.code
                                                               message:error.domain
                                                              userInfo:error.userInfo];
                    if (callback) callback(localError.responseValue, localError);
                } else {
                    if (callback) callback([JMRktResponse success], nil);
                }
            }];
             */
            if (callback) callback([JMRktResponse success], nil);
        }
                baseHeaderConfig:[JMRktRequestConfig configWithInfoHook:^NSDictionary<NSString *,id> * _Nonnull{
            return @{
                @"boom-app-id" :[JMBoomSDKInfo shared].appId?:@"",
                @"boom-c-imsi" :[JMBoomSDKInfo shared].IMSI?:@"",
                @"boom-c-model" :[JMBoomSDKInfo shared].model?:@"",
                //易盾老的服务已经下线，直接塞空字符串
//                @"boom-c-token" :[JMNTESManager shared].token?:@"",//易盾的token
                @"boom-c-token" :@"",
                @"boom-client-bmc" :@"0",
                @"boom-client-model" :[JMBoomSDKInfo shared].model?:@"",
                @"boom-client-ptype" :[JMBoomSDKInfo shared].ptype?:@"",
                @"boom-client-source" :@"none",
                @"boom-client-token" :[JMBoomSDKInfo shared].token?:@"",//登录的token
                @"boom-client-ua" :[JMBoomSDKInfo shared].userAgent?:@"",
                @"boom-client-uuid" :[JMBoomSDKInfo shared].UID?:@"",//
                @"boom-nonce" :[JMBoomSDKInfo shared].nonce?:@"",
                @"boom-signature-method" :[JMBoomSDKInfo shared].signatureMethod?:@"",
                @"boom-timestamp" :[JMBoomSDKInfo shared].timestamp?:@"",
                @"boom-version" :JMBoomSDKConfig.version?:@"",
            };
         } signKeyHook:^NSString * _Nonnull{
             return @"boom-signature";
         } signOrderHook:^NSArray<NSString *> * _Nonnull{
             return @[
                 @"boom-app-id",
                 @"boom-c-imsi",
                 @"boom-c-model",
                 @"boom-c-token",
                 @"boom-client-bmc",
                 @"boom-client-model",
                 @"boom-client-ptype",
                 @"boom-client-source",
                 @"boom-client-token",
                 @"boom-client-ua",
                 @"boom-client-uuid",
                 @"boom-nonce",
                 @"boom-signature-method",
                 @"boom-timestamp",
                 @"boom-version",
             ];
         }]
          baseParameterConfig:[JMRktRequestConfig configWithInfoHook:^NSDictionary<NSString *,id> * _Nonnull{
            return @{
                @"idfa": [JMBoomSDKInfo shared].IDFA?:@"",
                @"uuid": [JMBoomSDKInfo shared].UID?:@"",
                @"uniqueId": [JMBoomSDKInfo shared].uniqueId?:@"",
                @"openId": [JMBoomSDKInfo shared].openId?:@"",
                @"bundleId": [JMBoomSDKInfo shared].bundleId?:@"",
            };
         } signKeyHook:^NSString * _Nonnull{
             return @"";
         } signOrderHook:^NSArray<NSString *> * _Nonnull{
             return @[];
         }]];
    }
    return self;
}

@end
