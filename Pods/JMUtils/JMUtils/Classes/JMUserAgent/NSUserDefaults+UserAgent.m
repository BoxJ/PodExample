//
//  NSUserDefaults+UserAgent.m
//  JMUtils
//
//  Created by ZhengXianda on 2021/9/16.
//

#import "NSUserDefaults+UserAgent.h"

@implementation NSUserDefaults (UserAgent)


#define kJMUtilsUserAgent @"kJMUtilsUserAgent"

+ (void)localUserAgent:(NSString *)version {
    [[self standardUserDefaults] setObject:version forKey:kJMUtilsUserAgent];
    [[self standardUserDefaults] synchronize];
}

+ (NSString *)localUserAgent {
    return [[self standardUserDefaults] objectForKey:kJMUtilsUserAgent] ?: @"";
}

@end
