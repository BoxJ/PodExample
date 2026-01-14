//
//  JMBoomSDKRequest+JMBoomSubmitBusiness.m
//  JMBoomSubmitBusiness
//
//  Created by ZhengXianda on 11/02/2022.
//  Copyright (c) 2022 ZhengXianda. All rights reserved.
//

#import "JMBoomSDKRequest+JMBoomSubmitBusiness.h"

#import <JMBoomSubmitBusiness/JMBoomSubmitType.h>

@implementation JMBoomSDKRequest (JMBoomSubmitBusiness)

- (void)uploadSubmitWithContact:(NSString *)contact
                          issue:(NSString *)issue
                      issueTime:(NSDate *)issueTime
                      issueType:(JMBoomSubmitType)issueType
                        logFile:(NSString *)logFile
                    screenshots:(NSArray <NSString *>*)screenshots
                       callback:(JMBusinessCallback)callback {
    NSString *path = @"/client/data//feedback";
    NSDictionary *parameters = @{
        @"contact": contact ?: @"",
        @"issue": issue ?: @"",
        @"issueTime": @(issueTime.timeIntervalSince1970*1000),
        @"issueType": @(issueType),
        @"language": [JMDeviceAnalyze language] ?: @"",
        @"logFile": logFile?:@"",
        @"model": [JMDeviceAnalyze Platform] ?: @"",
        @"netType": self.networkReachabilityStatusString ?: @"",
        @"resolution": [JMDeviceAnalyze Resolution] ?: @"",
        @"screenshots": screenshots?:@[],
        @"version": [JMDeviceAnalyze SystemVersion] ?: @"",
    };
    [self requestDataWithMethod:JMRequestMethodType_POST_JSON
                           path:path
                     parameters:parameters
                       callback:callback];
}

- (void)querySubmitHistoryListWithId:(NSInteger)submitId
                            callback:(JMBusinessCallback)callback {
    NSString *path = @"/client/data/feedback/history";
    NSDictionary *parameters = @{
        @"feedbackId": @(submitId),
        @"size": @(20),
    };
    [self requestDataWithMethod:JMRequestMethodType_GET
                           path:path
                     parameters:parameters
                       callback:callback];
}

- (void)querySubmitHistoryDeiatlWithId:(NSInteger)submitId
                              callback:(JMBusinessCallback)callback {
    NSString *path = @"/client/data/feedback/details";
    NSDictionary *parameters = @{
        @"feedbackId": @(submitId),
    };
    [self requestDataWithMethod:JMRequestMethodType_GET
                           path:path
                     parameters:parameters
                       callback:callback];
}

@end
