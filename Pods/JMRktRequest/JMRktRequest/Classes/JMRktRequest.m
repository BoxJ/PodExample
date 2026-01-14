//
//  JMRktRequest.m
//  JMRktRequest
//
//  Created by ZhengXianda on 10/19/2022.
//  Copyright (c) 2022 ZhengXianda. All rights reserved.
//

#import "JMRktRequest.h"

@implementation JMRktRequest

- (instancetype)init {
    self = [super init];
    if (self) {
        [[JMNetworkReachabilityManager sharedManager] startMonitoring];
    }
    return self;
}

#pragma mark - Util

- (void)registerBaseURL:(NSString *(^)(void))baseURL
              secretKey:(NSString *(^)(void))secretKey
             verifyHook:(void(^)(JMRktCommonCallback callback))verifyHook
       baseHeaderConfig:(JMRktRequestConfig *)baseHeaderConfig
    baseParameterConfig:(JMRktRequestConfig *)baseParameterConfig{
    self.baseURL = baseURL;
    self.secretKey = secretKey;
    self.verifyHook = verifyHook;
    self.baseHeaderConfig = baseHeaderConfig;
    self.baseParameterConfig = baseParameterConfig;
}

- (void)requestDataWithMethod:(JMRequestMethodType)method
                         path:(NSString *)path
                   parameters:(NSDictionary *)parameters
                     callback:(JMRequestCallback)callback {
    [self requestDataWithMethod:method
                           path:path
                     parameters:parameters
                           body:nil
                       callback:callback];
}

- (void)requestDataWithMethod:(JMRequestMethodType)method
                       domain:(NSString *)domain
                         path:(NSString *)path
                   parameters:(NSDictionary *)parameters
                     callback:(JMRequestCallback)callback {
    [self requestDataWithMethod:method
                         domain:domain
                           path:path
                     parameters:parameters
                           body:nil
                       callback:callback];
}

- (void)requestDataWithMethod:(JMRequestMethodType)method
                         path:(NSString *)path
                   parameters:(NSDictionary *)parameters
                         body:(NSData * _Nullable)body
                     callback:(JMRequestCallback)callback {
    [self requestDataWithMethod:method
                           path:path
                         header:@{}
                  headerSignKey:@""
                headerSignOrder:@[]
                     parameters:parameters
              parametersSignKey:@""
            parametersSignOrder:@[]
                           body:body
                       callback:callback];
}

#pragma mark verify origin request

- (void)requestDataWithMethod:(JMRequestMethodType)method
                         path:(NSString *)path
                       header:(NSDictionary *)header
                headerSignKey:(NSString *)headerSignKey
              headerSignOrder:(NSArray <NSString *>*)headerSignOrder
                   parameters:(NSDictionary *)parameters
            parametersSignKey:(NSString *)parametersSignKey
          parametersSignOrder:(NSArray <NSString *>*)parametersSignOrder
                         body:(NSData * _Nullable)body
                     callback:(JMRequestCallback)callback {
    self.verifyHook(^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            NSError *localError = [JMRktResponse errorWithCode:error.code
                                                       message:error.domain
                                                      userInfo:error.userInfo];
            if (callback) callback([localError responseValue], localError);
        } else {
            NSDictionary *baseHeaderInfo = self.baseHeaderConfig ?
            [self.baseHeaderConfig infoByAppendingInfo:header
                                               signKey:headerSignKey
                                             signOrder:headerSignOrder
                                             secretKey:self.secretKey()]
            : @{};
            
            NSDictionary *baseParameterInfo = self.baseParameterConfig ?
            [self.baseParameterConfig infoByAppendingInfo:parameters
                                                  signKey:parametersSignKey
                                                signOrder:parametersSignOrder
                                                secretKey:self.secretKey()]
            : @{};
            
            [[JMRequest shared] setHTTPHeaderFromDictionary:baseHeaderInfo];
            [self requestDataWithMethod:method
                                 domain:self.baseURL()
                                   path:path
                             parameters:baseParameterInfo
                                   body:body
                               callback:callback];
        }
    });
}

#pragma mark origin request

- (void)requestDataWithMethod:(JMRequestMethodType)method
                       domain:(NSString *)domain
                         path:(NSString *)path
                   parameters:(NSDictionary *)parameters
                         body:(NSData * _Nullable)body
                     callback:(JMRequestCallback)callback {
    [[JMRequest shared] requestDataWithMethod:method
                                       domain:domain
                                         path:path
                                   parameters:parameters
                                         body:body
                                     callback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            JMLog(@"[%@] 请求失败 network %@", path, error.localizedDescription);
            
            if (callback) callback(error.responseValue, error);
        } else {
            //解析错误数据
            NSInteger code = [responseObject[@"code"] integerValue];
            if (!error && code != 0) {
                NSString *message = responseObject[@"message"];
                NSDictionary *messageStyle = responseObject[@"messageStyle"];
                if (![messageStyle isKindOfClass:[NSDictionary class]]) {
                    messageStyle = @{};
                }
                NSString *traceId = responseObject[@"traceId"];
                error = [JMRktResponse errorWithCode:code
                                              message:message
                                             userInfo:@{}
                                         messageStyle:messageStyle
                                              traceId:traceId];
            }
            
            if (error) {
                JMLog(@"[%@] 请求失败 server %@", path, error.localizedDescription);
            } else {
                JMLog(@"[%@] 请求成功", path);
            }
            
            if (callback) callback(responseObject, error);
        }
    }];
}

#pragma mark - getter

- (NSInteger)networkReachabilityStatus {
    return (NSInteger)[JMNetworkReachabilityManager sharedManager].networkReachabilityStatus;
}

- (NSString *)networkReachabilityStatusString {
    NSString *netType = @"";
    switch (self.networkReachabilityStatus) {
        case JMNetworkReachabilityStatusReachableViaWiFi:
            netType = @"WI-FI";
            break;
        case JMNetworkReachabilityStatusReachableViaWWAN:
            netType = @"WWAN";
            break;
        default:
            netType = @"Unknown";
            break;
    }
    return netType;
}

@end
