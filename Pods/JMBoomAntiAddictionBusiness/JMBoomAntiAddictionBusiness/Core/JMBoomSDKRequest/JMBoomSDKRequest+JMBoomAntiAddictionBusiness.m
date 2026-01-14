//
//  JMBoomSDKRequest+JMBoomAntiAddictionBusiness.m
//  JMBoomAntiAddictionBusiness
//
//  Created by ZhengXianda on 11/02/2022.
//  Copyright (c) 2022 ZhengXianda. All rights reserved.
//

#import "JMBoomSDKRequest+JMBoomAntiAddictionBusiness.h"

@implementation JMBoomSDKRequest (JMBoomAntiAddictionBusiness)

- (void)antiAddictionActiveWithCount:(NSInteger)count
                            interval:(NSTimeInterval)interval
                            callback:(JMBusinessCallback)callback {
    NSString *path = @"/client/antiAddiction/active";
    NSDictionary *parameters = @{
        @"count": @(count),
        @"interval": @(interval),
    };

    [self requestDataWithMethod:JMRequestMethodType_POST
                           path:path
                     parameters:parameters
                       callback:callback];
}

- (void)antiAddictionRemainWithCallback:(JMBusinessCallback)callback {
    NSString *path = @"/client/antiAddiction/remain";
    NSDictionary *parameters = @{
    
    };

    [self requestDataWithMethod:JMRequestMethodType_GET
                           path:path
                     parameters:parameters
                       callback:callback];
}

@end
