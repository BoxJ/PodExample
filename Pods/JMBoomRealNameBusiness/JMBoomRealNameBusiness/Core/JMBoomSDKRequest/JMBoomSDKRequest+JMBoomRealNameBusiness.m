//
//  JMBoomSDKRequest+JMBoomRealNameBusiness.m
//  JMBoomRealNameBusiness
//
//  Created by ZhengXianda on 11/02/2022.
//  Copyright (c) 2022 ZhengXianda. All rights reserved.
//

#import "JMBoomSDKRequest+JMBoomRealNameBusiness.h"

@implementation JMBoomSDKRequest (JMBoomRealNameBusiness)

- (void)identityStatusWithCallback:(JMBusinessCallback)callback {
    NSString *path = @"/client/identity/status";
    NSDictionary *parameters = @{
    
    };

    [self requestDataWithMethod:JMRequestMethodType_GET
                           path:path
                     parameters:parameters
                       callback:callback];
}

- (void)identityVerifyWithIdCardNumber:(NSString *)idCardNumber
                              realName:(NSString *)realName
                              callback:(JMBusinessCallback)callback {
    NSString *path = @"/client/identity/verify";
    NSDictionary *parameters = @{
        @"idCardNumber": idCardNumber,
        @"realName": realName,
    };

    [self requestDataWithMethod:JMRequestMethodType_POST
                           path:path
                     parameters:parameters
                       callback:callback];
}

@end
