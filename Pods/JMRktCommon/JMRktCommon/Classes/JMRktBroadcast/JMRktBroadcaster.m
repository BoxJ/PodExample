//
//  JMRktBroadcaster.m
//  JMRktCommon
//
//  Created by Thief Toki on 2020/9/11.
//

#import "JMRktBroadcaster.h"

#import "JMRktResponse.h"

#import "NSError+JMRktExtension.h"

@implementation JMRktBroadcaster

- (void)subscribeWithCallback:(JMRktBroadcasterCallback)callback {
    [super subscribeWithCallback:^(JMBroadcast * _Nullable broadcast, NSError * _Nullable error) {
        if (error) {
            if (callback) callback(error.responseValue, error);
        } else {
            if (callback) callback([JMRktResponse successWithResult:@{
                @"type": @(broadcast.channel),
                @"content": broadcast.content ?: @{},
            }], error);
        }
    }];
}

@end
