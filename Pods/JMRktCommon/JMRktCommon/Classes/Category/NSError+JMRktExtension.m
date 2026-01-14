//
//  NSError+JMRktExtension.m
//  JMRktCommon
//
//  Created by Thief Toki on 2021/4/9.
//

#import "NSError+JMRktExtension.h"

@implementation NSError (JMRktExtension)

- (NSString *)message {
    NSString *message = self.userInfo[@"message"]?:@"";
    return message.length > 0 ? message : self.localizedDescription;
}

- (NSString *)htmlMessage {
    NSString *htmlMessage = self.userInfo[@"htmlMessage"]?:@"";
    return htmlMessage;
}

- (NSDictionary *)messageStyle {
    NSDictionary *messageStyle = self.userInfo[@"messageStyle"]?:@{};
    return messageStyle;
}

- (NSString *)traceId {
    NSString *traceId = self.userInfo[@"traceId"]?:@"";
    return traceId;
}

- (NSDictionary *)responseValue {
    return @{
        @"domain": self.domain,
        @"code": @(self.code),
        @"message": self.message,
        @"traceId": self.traceId,
        @"result": self.userInfo,
    };
}

@end
