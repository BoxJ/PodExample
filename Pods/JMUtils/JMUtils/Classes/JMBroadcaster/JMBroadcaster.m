//
//  JMBroadcaster.m
//  JMBoomSDK
//
//  Created by Thief Toki on 2020/9/11.
//

#import "JMBroadcaster.h"

@implementation JMBroadcaster

#pragma mark - shared

+ (instancetype)shared {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark -

- (void)subscribeWithCallback:(JMBroadcasterCallback)callback {
    self.callback = callback;
}

- (void)sendbroadcast:(JMBroadcast *)broadcast {
    if (self.callback) {
        self.callback(broadcast, nil);
    }
}

- (void)sendError:(NSError *)error {
    if (error && self.callback) {
        self.callback(nil, error);
    }
}

@end
