//
//  JMBoomSDKRequest+JMBoomAccountBusiness.m
//  JMBoomAccountBusiness
//
//  Created by ZhengXianda on 11/02/2022.
//  Copyright (c) 2022 ZhengXianda. All rights reserved.
//

#import "JMBoomSDKRequest+JMBoomAccountBusiness.h"

@implementation JMBoomSDKRequest (JMBoomAccountBusiness)

#pragma mark - login

- (void)quickLoginWithToken:(NSString *)token
                   callback:(JMRequestCallback)callback {
    NSString *path = @"/client/security/chuanglan/login";
    NSDictionary *parameters = @{
        @"cancelClosing": @(NO),
        @"token": token,
    };

    [self requestDataWithMethod:JMRequestMethodType_POST
                           path:path
                     parameters:parameters
                       callback:callback];
}

- (void)guestLoginWithCallback:(JMRequestCallback)callback {
    NSString *path = @"/client/security/guest/login";
    NSDictionary *parameters = @{

    };

    [self requestDataWithMethod:JMRequestMethodType_POST
                           path:path
                     parameters:parameters
                       callback:callback];
}

- (void)loginWithCallback:(JMRequestCallback)callback {
    NSString *path = @"/client/security/login";
    NSDictionary *parameters = @{
        @"cancelClosing": @(NO),
    };

    [self requestDataWithMethod:JMRequestMethodType_POST
                           path:path
                     parameters:parameters
                       callback:callback];
}

- (void)phoneLoginWithPhoneNumber:(NSString *)phoneNumber
                 verificationCode:(NSString *)verificationCode
                         callback:(JMRequestCallback)callback {
    NSString *path = @"/client/security/phone/login";
    NSDictionary *parameters = @{
        @"cancelClosing": @(NO),
        @"phoneNumber": phoneNumber,
        @"verificationCode": verificationCode,
    };

    [self requestDataWithMethod:JMRequestMethodType_POST
                           path:path
                     parameters:parameters
                       callback:callback];
}

- (void)loginContinueWithTraceId:(NSString *)traceId
                       traceType:(NSInteger)traceType
                        callback:(JMRequestCallback)callback {
    NSString *path = @"/client/security/login/continue";
    NSDictionary *parameters = @{
        @"traceId": traceId,
        @"traceType": @(traceType),
        @"idfa": JMBoomSDKBusiness.info.IDFA?:@"",
    };

    [self requestDataWithMethod:JMRequestMethodType_POST
                           path:path
                     parameters:parameters
                       callback:callback];
}

#pragma mark - bound

- (void)guestBoundWithPhoneNumber:(NSString *)phoneNumber
                 verificationCode:(NSString *)verificationCode
                         callback:(JMRequestCallback)callback {
    NSString *path = @"/client/security/guest/bound";
    NSDictionary *parameters = @{
        @"phoneNumber": phoneNumber,
        @"verificationCode": verificationCode,
    };

    [self requestDataWithMethod:JMRequestMethodType_POST
                           path:path
                     parameters:parameters
                       callback:callback];
}

- (void)guestBoundWithToken:(NSString *)token
                   callback:(JMRequestCallback)callback {
    NSString *path = @"/client/security/guest/bound/chuanglan";
    NSDictionary *parameters = @{
        @"token": token,
    };

    [self requestDataWithMethod:JMRequestMethodType_POST
                           path:path
                     parameters:parameters
                       callback:callback];
}


#pragma mark - userInfo

- (void)userInfoWithCallback:(JMRequestCallback)callback {
    NSString *path = @"/client/security/userInfo";
    NSDictionary *parameters = @{
        
    };

    [self requestDataWithMethod:JMRequestMethodType_GET
                           path:path
                     parameters:parameters
                       callback:callback];
}

- (void)guestIdCheckWithCallback:(JMRequestCallback)callback {
    NSString *path = @"/client/security/guest/check";
    NSDictionary *parameters = @{
    
    };

    [self requestDataWithMethod:JMRequestMethodType_POST
                           path:path
                     parameters:parameters
                       callback:callback];
}

- (void)phoneChangeVerifyWithCallback:(JMRequestCallback)callback {
    NSString *path = @"/client/security/phone/change/verify";
    NSDictionary *parameters = @{
        
    };

    [self requestDataWithMethod:JMRequestMethodType_POST
                           path:path
                     parameters:parameters
                       callback:callback];
}

- (void)accountChangeVerifyWithCallback:(JMRequestCallback)callback {
    NSString *path = @"/client/security/account/change/verify";
    NSDictionary *parameters = @{
        
    };

    [self requestDataWithMethod:JMRequestMethodType_POST
                           path:path
                     parameters:parameters
                       callback:callback];
}

#pragma mark - account closing

- (void)accountClosingWithCallback:(JMRequestCallback)callback {
    NSString *path = @"/client/security/logout";
    NSDictionary *parameters = @{
        
    };

    [self requestDataWithMethod:JMRequestMethodType_POST
                           path:path
                     parameters:parameters
                       callback:callback];
}

- (void)accountClosingCheckWaitingDays:(NSUInteger)waitingDays
                              callback:(JMRequestCallback)callback {
    NSString *path = @"/client/security/logout/check";
    NSDictionary *parameters = @{
        @"waitingDays": @(waitingDays),
    };

    [self requestDataWithMethod:JMRequestMethodType_POST
                           path:path
                     parameters:parameters
                       callback:callback];
}

- (void)accountClosingCheckIdCardNumber:(NSString *)idCardNumber
                               callback:(JMRequestCallback)callback {
    NSString *path = @"/client/security/logout/idCard";
    NSDictionary *parameters = @{
        @"idCardNumber": idCardNumber,
    };

    [self requestDataWithMethod:JMRequestMethodType_POST
                           path:path
                     parameters:parameters
                       callback:callback];
}

- (void)accountClosingCheckPhoneNumber:(NSString *)phoneNumber
                              callback:(JMRequestCallback)callback {
    NSString *path = @"/client/security/logout/phone";
    NSDictionary *parameters = @{
        @"phoneNumber": phoneNumber,
    };

    [self requestDataWithMethod:JMRequestMethodType_GET
                           path:path
                     parameters:parameters
                       callback:callback];
}

- (void)accountClosingCheckPhoneNumber:(NSString *)phoneNumber
                      verificationCode:(NSString *)verificationCode
                              callback:(JMRequestCallback)callback {
    NSString *path = @"/client/security/logout/phone/code";
    NSDictionary *parameters = @{
        @"phoneNumber": phoneNumber,
        @"verificationCode": verificationCode,
    };

    [self requestDataWithMethod:JMRequestMethodType_POST
                           path:path
                     parameters:parameters
                       callback:callback];
}

- (void)accountClosingComplete:(BOOL)accept
                      callback:(JMRequestCallback)callback {
    NSString *path = @"/client/security/logout/complete";
    NSDictionary *parameters = @{
        @"cancel": @(!accept),
    };

    [self requestDataWithMethod:JMRequestMethodType_POST
                           path:path
                     parameters:parameters
                       callback:callback];
}

#pragma mark - util

- (void)verificationCodeWithPhoneNumber:(NSString *)phoneNumber
                   codeVerificationType:(NSInteger)codeVerificationType
                               callback:(JMRequestCallback)callback {
    NSString *path = @"/client/security/verificationCode";
    NSDictionary *parameters = @{
        @"phoneNumber": phoneNumber,
        @"codeVerificationType": @(codeVerificationType),
    };

    [self requestDataWithMethod:JMRequestMethodType_GET
                           path:path
                     parameters:parameters
                       callback:callback];
}

@end
