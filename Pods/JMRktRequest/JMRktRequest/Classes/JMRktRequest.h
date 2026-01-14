//
//  JMRktRequest.h
//  JMRktRequest
//
//  Created by ZhengXianda on 10/19/2022.
//  Copyright (c) 2022 ZhengXianda. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <JMUtils/JMUtils.h>
#import <JMNetworking/JMNetworking.h>
#import <JMRequest/JMRequest.h>
#import <JMRktCommon/JMRktCommon.h>

#import <JMRktRequest/JMRktRequestConfig.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMRktRequest : NSObject

@property (nonatomic, strong) NSString *(^baseURL)(void);
@property (nonatomic, strong) NSString *(^secretKey)(void);
@property (nonatomic, strong) void(^verifyHook)(JMRktCommonCallback callback);

@property (nonatomic, strong) JMRktRequestConfig *baseHeaderConfig;
@property (nonatomic, strong) JMRktRequestConfig *baseParameterConfig;

- (void)registerBaseURL:(NSString *(^)(void))baseURL
              secretKey:(NSString *(^)(void))secretKey
             verifyHook:(void(^)(JMRktCommonCallback callback))verifyHook
       baseHeaderConfig:(JMRktRequestConfig *)baseHeaderConfig
    baseParameterConfig:(JMRktRequestConfig *)baseParameterConfig;

#pragma mark - request

- (void)requestDataWithMethod:(JMRequestMethodType)method
                         path:(NSString *)path
                   parameters:(NSDictionary *)parameters
                     callback:(JMRequestCallback)callback;

- (void)requestDataWithMethod:(JMRequestMethodType)method
                       domain:(NSString *)domain
                         path:(NSString *)path
                   parameters:(NSDictionary *)parameters
                     callback:(JMRequestCallback)callback;

- (void)requestDataWithMethod:(JMRequestMethodType)method
                         path:(NSString *)path
                   parameters:(NSDictionary *)parameters
                         body:(NSData * _Nullable)body
                     callback:(JMRequestCallback)callback;

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
                     callback:(JMRequestCallback)callback;

#pragma mark origin request

- (void)requestDataWithMethod:(JMRequestMethodType)method
                       domain:(NSString *)domain
                         path:(NSString *)path
                   parameters:(NSDictionary *)parameters
                         body:(NSData * _Nullable)body
                     callback:(JMRequestCallback)callback;

#pragma mark - property

- (NSInteger)networkReachabilityStatus;
- (NSString *)networkReachabilityStatusString;

@end

NS_ASSUME_NONNULL_END
