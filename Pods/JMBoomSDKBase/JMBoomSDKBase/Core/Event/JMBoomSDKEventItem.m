//
//  JMBoomSDKEventItem.m
//  JMBoomSDK
//
//  Created by Thief Toki on 2021/1/21.
//

#import "JMBoomSDKEventItem.h"

#import <JMRktCommon/JMRktCommon.h>

#import "JMBoomSDKRequest.h"
#import "JMBoomSDKInfo.h"

@interface JMBoomSDKEventItem ()

@property (nonatomic, assign) NSInteger eventId;
@property (nonatomic, assign) NSString *exStr1;
@property (nonatomic, assign) NSString *exStr2;
@property (nonatomic, strong) NSString *openId;
@property (nonatomic, strong) NSString *recordTime;
@property (nonatomic, strong) NSString *netType;
@property (nonatomic, assign) NSInteger errorCode;
@property (nonatomic, strong, nullable) NSString *errorMessage;

@end

@implementation JMBoomSDKEventItem

+ (instancetype)event:(NSInteger)eventId {
    return [self event:eventId
                exStrs:@[]];
}

+ (instancetype)event:(NSInteger)eventId
               exStrs:(NSArray *)exStrs {
    return [self event:eventId
                exStrs:exStrs
                 error:nil];
}

+ (instancetype)event:(NSInteger)eventId
                error:(NSError * _Nullable)error {
    return [self event:eventId
                exStrs:@[]
                 error:error];
}

+ (instancetype)event:(NSInteger)eventId
               exStrs:(NSArray *)exStrs
                error:(NSError * _Nullable)error {
    if (error) {
        return [self event:eventId
                    exStrs:exStrs
                 errorCode:error.code
              errorMessage:error.message];
    } else {
        return [self event:eventId
                    exStrs:exStrs
                 errorCode:0
              errorMessage:@""];
    }
};

+ (instancetype)event:(NSInteger)eventId
            errorCode:(NSInteger)errorCode
         errorMessage:(NSString *)errorMessage {
    return [self event:eventId
                exStrs:@[]
             errorCode:errorCode
          errorMessage:errorMessage];
}

+ (instancetype)event:(NSInteger)eventId
               exStrs:(NSArray *)exStrs
            errorCode:(NSInteger)errorCode
         errorMessage:(NSString *)errorMessage {
    JMBoomSDKEventItem *event = [[JMBoomSDKEventItem alloc] init];
    event.eventId = eventId;
    if (exStrs.count > 0) event.exStr1 = exStrs[0];
    if (exStrs.count > 1) event.exStr2 = exStrs[1];
    event.openId = [JMBoomSDKInfo shared].openId?:@"";
    event.recordTime = [JMValue TimestampMillisecond];
    event.netType = [JMBoomSDKRequest shared].networkReachabilityStatusString;
    
    event.errorCode = errorCode;
    event.errorMessage = errorMessage;
    
    return event;
}

+ (instancetype)eventWithDict:(NSDictionary *)dict {
    JMBoomSDKEventItem *event = [[JMBoomSDKEventItem alloc] init];
    
    event.errorCode = [dict[@"code"] integerValue];
    event.eventId = (NSInteger)[dict[@"eventId"] integerValue];
    event.exStr1 = dict[@"exStr1"];
    event.exStr2 = dict[@"exStr2"];
    event.netType = dict[@"netType"];
    event.recordTime = dict[@"opTime"];
    event.openId = dict[@"openId"];
    event.errorMessage = dict[@"reason"];
    
    return event;
}

- (NSDictionary *)jsonValue {
    return @{
        @"code": @(self.errorCode),
        @"eventId": @(self.eventId),
        @"exStr1": self.exStr1?:@"",
        @"exStr2": self.exStr2?:@"",
        @"netType": self.netType?:@"",
        @"opTime": self.recordTime?:@"",
        @"openId": self.openId?:@"",
        @"reason": self.errorMessage?:@"",
    };
}



@end
