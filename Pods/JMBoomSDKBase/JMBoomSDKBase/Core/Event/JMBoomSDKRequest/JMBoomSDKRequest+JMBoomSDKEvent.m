//
//  JMBoomSDKRequest+JMBoomSDKEvent.m
//  JMBoomSDK
//
//  Created by Thief Toki on 2021/1/20.
//

#import "JMBoomSDKRequest+JMBoomSDKEvent.h"

#import "JMBoomSDKInfo.h"

#import "JMBoomSDKEventItem.h"

@implementation JMBoomSDKRequest (JMBoomSDKEvent)

- (void)uploadEvents:(NSArray <JMBoomSDKEventItem *>*)events
            callback:(JMRequestCallback)callback {
    NSString *path = @"/client/data";
    NSMutableArray *eventDatas = [NSMutableArray array];
    for (JMBoomSDKEventItem *event in events) {        
        NSMutableDictionary *eventData = [event.jsonValue mutableCopy];
        [eventData addEntriesFromDictionary:@{
            @"model": [JMBoomSDKInfo shared].model?:@"",
            @"resolution": [[JMBoomSDKInfo shared] resolution]?:@"",
            @"source": @"none",
            @"uploadTime": [JMBoomSDKInfo shared].timestamp?:@"",
            @"version": [JMBoomSDKInfo shared].version?:@"",
            @"idfa": [JMBoomSDKInfo shared].IDFA?:@"",
            @"uuid": [JMBoomSDKInfo shared].UID?:@"",
            @"uniqueId": [JMBoomSDKInfo shared].uniqueId?:@"",
        }];
        [eventDatas addObject:[eventData copy]];
    }
    NSDictionary *parameters = @{
        @"data": [eventDatas copy]
    };
    [self requestDataWithMethod:JMRequestMethodType_POST_JSON
                           path:path
                     parameters:parameters
                       callback:callback];
}

@end
