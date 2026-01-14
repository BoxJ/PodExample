//
//  JMAttributionManager.m
//  JMAttributionManager
//
//  Created by ZhengXianda on 08/25/2021.
//  Copyright (c) 2021 ZhengXianda. All rights reserved.
//

#import "JMAttributionManager.h"

#import <AdServices/AdServices.h>

@implementation JMAttributionManager

#pragma mark - shared

+ (instancetype)shared {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)requestAttributionInfoWithBlock:(void (^)(NSString *info, NSError *error))completionHandler {
    if (@available(iOS 14.3, *)) {
        NSError *error;
        self.attributionToken = [AAAttribution attributionTokenWithError:&error];
        if (completionHandler) completionHandler(self.attributionToken?:@"", error);
    } else {
        if (completionHandler) completionHandler(@"", nil);
//        __weak typeof(self) weakSelf = self;
//        if ([[ADClient sharedClient] respondsToSelector:@selector(requestAttributionDetailsWithBlock:)]) {
//            [[ADClient sharedClient] requestAttributionDetailsWithBlock:^(NSDictionary<NSString *,NSObject *> * _Nullable attributionDetails, NSError * _Nullable error) {
//                if (error) {//归因信息获取失败
//                    if (completionHandler) completionHandler(@"", error);
//                } else {
//                    NSDictionary *details = (NSDictionary<NSString *,NSString *> *)attributionDetails.allValues.firstObject;
//                    NSError *parseError = nil;
//                    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:details
//                                                                       options:NSJSONWritingPrettyPrinted
//                                                                         error:&parseError];
//                    if (parseError) {//归因信息解析失败
//                        if (completionHandler) completionHandler(@"", parseError);
//                    } else {
//                        weakSelf.attributionDetails = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//                        if (completionHandler) completionHandler(weakSelf.attributionDetails?:@"", nil);
//                    }
//                }
//            }];
//        } else {
//            if (completionHandler) completionHandler(@"", nil);
//        }
    }
}

@end

