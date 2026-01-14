//
//  JMLogger.m
//  JMBoomSDK
//
//  Created by Thief Toki on 2020/7/10.
//

#import "JMLogger.h"

#import "JMValue.h"
#import "NSDate+JMExtension.h"

@interface JMLogger ()

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *directoryPath;
@property (nonatomic, strong) NSString *filePath;

@end

@implementation JMLogger

#pragma mark - shared

+ (instancetype)shared {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initWithName:NSStringFromClass([self class]) suffix:@"log"];
    });
    return instance;
}

- (instancetype)initWithName:(NSString *)name suffix:(NSString *)suffix {
    self = [super initWithName:name suffix:suffix];
    if (self) {
        NSTimeInterval timestampOfToday = [NSDate date].weeDate.timeIntervalSince1970;
        self.logName = [NSString stringWithFormat:@"%.0f", timestampOfToday];
        [self read:self.logName];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(save)
                                                     name:UIApplicationWillTerminateNotification
                                                    object:nil];
    }
    return self;
}

- (void)Log:(NSString *)log {
    if (!self.info) self.info = @"";
    self.info = [self.info stringByAppendingString:@"\n"];
    self.info = [self.info stringByAppendingString:log?:@"日志内容丢失"];
}

- (BOOL)save {
    if (self.isEnable) {
        [self save:self.logName];
        self.info = @"";
        return YES;
    }
    return NO;
}

@end
