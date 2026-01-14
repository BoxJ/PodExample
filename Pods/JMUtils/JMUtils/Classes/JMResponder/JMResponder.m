//
//  JMResponder.m
//  JMBoomSDK
//
//  Created by Thief Toki on 2020/8/10.
//

#import "JMResponder.h"

@implementation JMResponder

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.success = ^(NSDictionary *info) {
            
        };
        self.failed = ^(NSError *error) {
            
        };
        self.cancel = ^{
            
        };
    }
    return self;
}

+ (instancetype)responder {
    return [[self alloc] init];
}

+ (instancetype)success:(JMResponderBlockSuccess)success
                 failed:(JMResponderBlockFailed)failed
                 cancel:(JMResponderBlockCancel)cancel {
    JMResponder *responder = [[JMResponder alloc] init];
    if (responder) {
        responder.success = success?:responder.success;
        responder.failed = failed?:responder.failed;
        responder.cancel = cancel?:responder.cancel;
    }
    return responder;
}

+ (instancetype)success:(JMResponderBlockSuccess)success
                 failed:(JMResponderBlockFailed)failed {
    return [self success:success failed:failed cancel:nil];
}
+ (instancetype)success:(JMResponderBlockSuccess)success
                 cancel:(JMResponderBlockCancel)cancel {
    return [self success:success failed:nil cancel:cancel];
}
+ (instancetype)failed:(JMResponderBlockFailed)failed
                cancel:(JMResponderBlockCancel)cancel {
    return [self success:nil failed:failed cancel:cancel];
}

+ (instancetype)success:(JMResponderBlockSuccess)success {
    return [self success:success failed:nil cancel:nil];
}
+ (instancetype)failed:(JMResponderBlockFailed)failed {
    return [self success:nil failed:failed cancel:nil];
}
+ (instancetype)cancel:(JMResponderBlockCancel)cancel {
    return [self success:nil failed:nil cancel:cancel];
}

@end
