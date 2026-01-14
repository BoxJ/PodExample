//
//  JMUserAgent.m
//  JMUtils
//
//  Created by ZhengXianda on 2021/9/16.
//

#import "JMUserAgent.h"

#import <WebKit/WebKit.h>

@implementation JMUserAgent

#pragma mark - shared

+ (instancetype)shared {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (NSString *)localUserAgent {
    return [NSUserDefaults localUserAgent] ?: @"";
}

- (void)requestUserAgentWithCallback:(JMUserAgentCallback)callback {
    self.callback = callback;

    NSString *userAgent = [NSUserDefaults localUserAgent];
    
    if (userAgent && userAgent.length > 0) {
        self.callback(userAgent, nil);
    } else {
        __weak typeof(self) weakSelf = self;
        
        static WKWebView *JMLoadUserAgentWebView = nil;
        dispatch_async(dispatch_get_main_queue(), ^{
            JMLoadUserAgentWebView = [[WKWebView alloc] init];
            [JMLoadUserAgentWebView evaluateJavaScript:@"navigator.userAgent" completionHandler:^(id _Nullable result, NSError * _Nullable error) {
                if (error) {
                    weakSelf.callback(nil, error);
                } else {
                    NSString *originUA = [NSString stringWithFormat:@"%@",result];
                    [NSUserDefaults localUserAgent:originUA];
                    
                    weakSelf.callback(originUA, nil);
                }
                JMLoadUserAgentWebView = nil;
            }];
        });
    }
}

- (JMUserAgentCallback)callback {
    if (!_callback) {
        _callback = ^(NSString *userAgent, NSError *error) {
            
        };
    }
    return _callback;
}

@end
