//
//  JMRequest.m
//  JMNetworking
//
//  Created by zhengxianda on 2018/12/18.
//  Copyright © 2018 Toki. All rights reserved.
//

#import "JMRequest.h"

#import <JMNetworking/JMNetworking.h>

NSString *const JMNResponseObjectErrorKey = @"JMResponseObject";

@implementation JMRequest

#pragma mark - shared

+ (instancetype)shared {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - live cycle

- (instancetype)init {
    if (self = [super init]) {
        self.manager = [JMHTTPSessionManager manager];
        self.manager.requestSerializer.timeoutInterval = 20;
        self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                                  @"application/json",
                                                                  @"text/json",
                                                                  @"text/plain",
                                                                  @"text/javascript",
                                                                  @"text/html",
                                                                  nil];
    }
    return self;
}

#pragma mark - public

- (NSDictionary <NSString *, NSString *>*)HTTPheaders {
    return self.manager.requestSerializer.HTTPRequestHeaders;
}

- (void)setHTTPHeaderFromDictionary:(NSDictionary *)dictionary {
    [self.manager.requestSerializer clearHeader];
    
    [self addHTTPHeaderFromDictionary:dictionary];
}

- (void)addHTTPHeaderFromDictionary:(NSDictionary *)dictionary {
    for (NSString *key in dictionary.allKeys) {
        [self.manager.requestSerializer setValue:dictionary[key] forHTTPHeaderField:key];
    }
}

- (void)removeHTTPHeaderFromKeys:(NSArray *)keys {
    for (NSString *key in keys) {
        [self.manager.requestSerializer setValue:@"" forHTTPHeaderField:key];
    }
}

- (void)requestDataWithMethod:(JMRequestMethodType)method
                       domain:(NSString *)domain
                         path:(NSString *)path
                   parameters:(NSDictionary *)parameters
                         body:(NSData *)body
                     callback:(JMRequestCallback)callback {
    NSString *urlString = [NSString stringWithFormat:@"%@%@", domain, path];
    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [self requestDataWithMethod:method
                      URLString:urlString
                     parameters:parameters
                           body:body
                       callback:callback];
}

- (void)requestDataWithMethod:(JMRequestMethodType)method
                    URLString:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                         body:(NSData *)body
                     callback:(JMRequestCallback)callback {
    NSString *methodString = [JMRequestMethod stringWithRequestMethod:method];
    BOOL isEncodingParametersInURI = [JMRequestMethod isEncodingParametersInURIWithRequestMethod:method];
    NSString *urlString = [[NSURL URLWithString:URLString
                                  relativeToURL:self.manager.baseURL]
                           absoluteString];
    
    NSError *error;
    NSMutableURLRequest *request =
    [self.manager.requestSerializer requestWithMethod:methodString
                                            URLString:urlString
                                           parameters:parameters
                            isEncodingParametersInURI:isEncodingParametersInURI
                                                error:&error];
    if (body) request.HTTPBody = body;
    
    if (error) {
        if (callback) callback(nil, error);
    } else {
        NSURLSessionDataTask *task = [self.manager dataTaskWithRequest:request
                                                        uploadProgress:nil
                                                      downloadProgress:nil
                                                     completionHandler:^(NSURLResponse * _Nonnull response,
                                                                         id _Nullable responseObject,
                                                                         NSError * _Nullable error) {
            //解析相应数据为字典
            NSDictionary * responseDict = @{};
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                responseDict = responseObject;
            }
            
            if (callback) callback(responseDict, error);
        }];
        [task resume];
    }
}

@end
