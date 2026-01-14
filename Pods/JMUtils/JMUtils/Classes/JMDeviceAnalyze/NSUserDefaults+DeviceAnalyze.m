//
//  NSUserDefaults+DeviceAnalyze.m
//  JMUtils
//
//  Created by ZhengXianda on 2021/9/16.
//

#import "NSUserDefaults+DeviceAnalyze.h"

@implementation NSUserDefaults (DeviceAnalyze)


#define kJMUtilsUID @"kJMUtilsUID"
#define kJMUtilsUniqueId @"kJMUtilsUniqueId"

+ (void)localUID:(NSString *)UID {
    [[self standardUserDefaults] setObject:UID forKey:kJMUtilsUID];
    [[self standardUserDefaults] synchronize];
}

+ (NSString *)localUID {
    return [[self standardUserDefaults] objectForKey:kJMUtilsUID] ?: @"";
}

+ (void)localUniqueId:(NSString *)UniqueId {
    [[self standardUserDefaults] setObject:UniqueId forKey:kJMUtilsUniqueId];
    [[self standardUserDefaults] synchronize];
}

+ (NSString *)localUniqueId {
    return [[self standardUserDefaults] objectForKey:kJMUtilsUniqueId] ?: @"";
}

@end
