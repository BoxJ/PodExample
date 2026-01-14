//
//  JMBoomAntiAddictionPulse.m
//  JMBoomSDK
//
//  Created by Thief Toki on 2021/2/3.
//

#import "JMBoomAntiAddictionPulse.h"

#import "JMBoomSDKRequest+JMBoomAntiAddictionBusiness.h"

#define kMinInterval 30

@interface JMBoomAntiAddictionPulse ()

@property (nonatomic, strong) JMBusinessCallback callback;

@end

@implementation JMBoomAntiAddictionPulse

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

- (void)beatWithCallback:(JMBusinessCallback)callback {
    self.callback = callback;
    
    NSUInteger interval = MAX(kMinInterval, JMBoomSDKBusiness.config.antiAddictionInterval);
    [self beatWithInterval:interval resonance:^(NSUInteger beatCount) {
        [JMBoomSDKBusiness.request antiAddictionActiveWithCount:beatCount
                                                           interval:interval
        callback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
            if (error) {
                if (error.code >= 40000 && error.code <= 40100) {
                    switch (error.code) {
                        case 40003:
                        case 40015:
                        case 40016:
                        case 40017: {
                            if (self.callback) {
                                self.callback(nil, error);
                                self.callback = nil;
                            }
                        }
                            break;
                        default: {
                            
                        }
                            break;
                    }
                }
            } else {
                [self clear];
            }
        }];
    }];
}

@end
