//
//  NSUserDefaults+UserAgent.h
//  JMUtils
//
//  Created by ZhengXianda on 2021/9/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSUserDefaults (UserAgent)

+ (void)localUserAgent:(NSString *)version;
+ (NSString *)localUserAgent;
    
@end

NS_ASSUME_NONNULL_END
