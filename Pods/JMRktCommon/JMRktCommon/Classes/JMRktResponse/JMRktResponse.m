//
//  JMRktResponse.m
//  JMRktCommon
//
//  Created by Thief Toki on 2021/1/20.
//

#import "JMRktResponse.h"

#import <JMUtils/JMUtils.h>

@implementation JMRktResponse

#pragma mark - success

+ (NSDictionary *)success {
    return [self successWithResult:@(YES)];
}

+ (NSDictionary *)successWithResult:(NSObject *)result {
    return @{
        @"code": @0,
        @"message": @"成功",
        @"traceId": @"",
        @"result": result?:@{},
    };
}

#pragma mark - error

+ (NSError *)errorWithCode:(NSInteger)code
                      message:(NSString *)message {
    return [self errorWithCode:code
                       message:message
                      userInfo:@{}
                  messageStyle:@{}
                       traceId:@""];
}

+ (NSError *)errorWithCode:(NSInteger)code
                      message:(NSString *)message
                     userInfo:(NSDictionary *)userInfo {
    return [self errorWithCode:code
                       message:message
                      userInfo:userInfo
                  messageStyle:@{}
                       traceId:@""];
}

+ (NSError *)errorWithCode:(NSInteger)code
                   message:(NSString *)message
                  userInfo:(NSDictionary *)userInfo
              messageStyle:(NSDictionary *)messageStyle
                   traceId:(NSString *)traceId {
    NSMutableDictionary *localUserInfo = [(userInfo ?: @{}) mutableCopy];
    
    localUserInfo[@"messageStyle"] = messageStyle ?: @{};
    if (message.hasHTMLTag) {
        localUserInfo[@"message"] = [message stringWithoutHTMLTags];
        localUserInfo[@"htmlMessage"] = message;
    } else {
        localUserInfo[@"message"] = message;
    }
    localUserInfo[@"traceId"] = traceId;
    
    return [NSError errorWithDomain:@"JMRktSDK_Error"
                               code:code
                           userInfo:[localUserInfo copy]];
}

@end
