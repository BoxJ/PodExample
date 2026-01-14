//
//  JMUserAgent.h
//  JMUtils
//
//  Created by ZhengXianda on 2021/9/16.
//

#import <Foundation/Foundation.h>

#import "NSUserDefaults+UserAgent.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^JMUserAgentCallback)(NSString * _Nullable userAgent,
                                   NSError * _Nullable error);

@interface JMUserAgent : NSObject

#pragma mark - shared

+ (instancetype)shared;

@property (nonatomic, strong) JMUserAgentCallback callback;

- (NSString *)localUserAgent;
- (void)requestUserAgentWithCallback:(JMUserAgentCallback)callback;

@end

NS_ASSUME_NONNULL_END
