//
//  JMLogger.h
//  JMBoomSDK
//
//  Created by Thief Toki on 2020/7/10.
//

#import <JMUtils/JMFileArchive.h>

#define JMLog(frmt, ...) \
do {\
if ([JMLogger shared].isAbbreviated) { \
    if ([JMLogger shared].isEnable) { \
        NSString *log = [NSString stringWithFormat:(frmt), ##__VA_ARGS__];\
        NSString *fullLog = [NSString stringWithFormat:@"[%s:%d%s]:%@", __FILE_NAME__, __LINE__, __FUNCTION__, log];\
        NSLog(@"%@", fullLog);\
    } \
} else { \
    if ([JMLogger shared].isEnable) NSLog(frmt, ##__VA_ARGS__);\
    NSString *log = [NSString stringWithFormat:(frmt), ##__VA_ARGS__];\
    NSString *fullLog = [NSString stringWithFormat:@"| %s:%d |-v\n| %s |-v\n| %@ |", __FILE_NAME__, __LINE__, __FUNCTION__, log];\
    [[JMLogger shared] Log:fullLog];\
} \
} while(NO)

NS_ASSUME_NONNULL_BEGIN

@interface JMLogger : JMFileArchiveForString

@property (nonatomic, assign) BOOL isAbbreviated;
@property (nonatomic, assign) BOOL isEnable;
@property (nonatomic, strong) NSString *logName;

+ (instancetype)shared;

- (void)Log:(NSString *)log;

- (BOOL)save;

@end

NS_ASSUME_NONNULL_END
