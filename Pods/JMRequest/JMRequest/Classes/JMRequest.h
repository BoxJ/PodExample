//
//  JMRequest.h
//  JMNetworking
//
//  Created by zhengxianda on 2018/12/18.
//  Copyright © 2018 Toki. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JMRequestMethod.h"
#import "JMRequestCallback.h"

@class JMHTTPSessionManager;

NS_ASSUME_NONNULL_BEGIN

@interface JMRequest : NSObject

@property (nonatomic, strong, readwrite) JMHTTPSessionManager *manager;

+ (instancetype)shared;

- (NSDictionary <NSString *, NSString *>*)HTTPheaders;
- (void)setHTTPHeaderFromDictionary:(NSDictionary *)dictionary;
- (void)addHTTPHeaderFromDictionary:(NSDictionary *)dictionary;
- (void)removeHTTPHeaderFromKeys:(NSArray *)keys;

/**
发起网络请求

@param method 网络请求方法
@param domain 域名 / ip+端口
@param path 路径
@param parameters 参数
@param callback 请求回调
*/
- (void)requestDataWithMethod:(JMRequestMethodType)method
                       domain:(NSString *)domain
                         path:(NSString *)path
                   parameters:(NSDictionary *)parameters
                         body:(NSData * _Nullable)body
                     callback:(JMRequestCallback)callback;

/**
发起网络请求

@param method 网络请求方法
@param URLString 接口地址
@param parameters 参数
@param callback 请求回调
*/
- (void)requestDataWithMethod:(JMRequestMethodType)method
                    URLString:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                         body:(NSData * _Nullable)body
                     callback:(JMRequestCallback)callback;

@end

NS_ASSUME_NONNULL_END
