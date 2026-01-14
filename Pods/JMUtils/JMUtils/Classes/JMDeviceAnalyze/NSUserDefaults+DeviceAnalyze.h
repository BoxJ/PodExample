//
//  NSUserDefaults+DeviceAnalyze.h
//  JMUtils
//
//  Created by ZhengXianda on 2021/9/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSUserDefaults (DeviceAnalyze)

+ (void)localUID:(NSString *)UID;
+ (NSString *)localUID;
+ (void)localUniqueId:(NSString *)UniqueId;
+ (NSString *)localUniqueId;
    
@end

NS_ASSUME_NONNULL_END
