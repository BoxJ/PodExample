//
//  JMBoomSDKEvent.m
//  JMBoomSDK
//
//  Created by ZhengXianda on 11/01/2022.
//  Copyright (c) 2022 ZhengXianda. All rights reserved.
//

#import "JMBoomSDKEvent.h"

#import "JMBoomSDKRequest.h"

#import "JMBoomSDKRequest+JMBoomSDKEvent.h"

@interface JMBoomSDKEvent ()

@property (nonatomic, strong) NSString *directoryPath;

@property (nonatomic, strong) NSMutableArray *eventList;

@end

@implementation JMBoomSDKEvent

#pragma mark - shared

+ (instancetype)shared {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        self.directoryPath = [documentsDirectory stringByAppendingString:@"/JMBoomSDK/Event/"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:self.directoryPath]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:self.directoryPath
                                      withIntermediateDirectories:NO
                                                       attributes:nil
                                                            error:nil];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(save)
                                                     name:UIApplicationWillTerminateNotification
                                                    object:nil];
    }
    return self;
}

#pragma mark - 基础操作

- (void)uploadEvent:(JMBoomSDKEventItem *)event {
    [self.eventList addObject:event];
    [self uploadEvents:[self.eventList copy]];
    [self.eventList removeAllObjects];
}

- (void)uploadEvents:(NSArray <JMBoomSDKEventItem *>*)events {
    if (events.count == 0) return;
    __weak typeof(self) weakSelf = self;
    [[JMBoomSDKRequest shared] uploadEvents:events
                                   callback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (error) {
            [strongSelf recordEvents:events];
        }
    }];
}

- (void)recordEvent:(JMBoomSDKEventItem *)event {
    [self recordEvents:@[event]];
}

- (void)recordEvents:(NSArray <JMBoomSDKEventItem *>*)events {
    [self.eventList addObjectsFromArray:events];
    
    if (self.eventList.count >= 10) {
        if ([self save]) {
            [self.eventList removeAllObjects];
        }
    }
}

- (BOOL)save {
    if (self.eventList.count == 0) return false;
    NSString *filePath = [self.directoryPath stringByAppendingFormat:@"%@.event", [JMValue Timestamp]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    }
    
    NSMutableArray * eventDictList = [NSMutableArray array];
    for (JMBoomSDKEventItem *event in self.eventList) {
        [eventDictList addObject:event.jsonValue];
    }
    
    return [[eventDictList copy] writeToFile:filePath atomically:NO];
}

#pragma mark - 对目标文件的处理

- (NSString *)fullPath:(NSString *)fileName {
    NSString *fullName = [fileName copy];
    if (![fullName hasSuffix:@"event"]) {
        fullName = [NSString stringWithFormat:@"%zd.event", [fullName integerValue]];
    }
    NSString *filePath = [self.directoryPath stringByAppendingFormat:@"%@", fullName];
    return filePath;
}

- (NSArray <JMBoomSDKEventItem *> *)read:(NSString *)fileName {
    NSArray *eventDictList = [[NSArray alloc] initWithContentsOfFile:[self fullPath:fileName]];
    NSMutableArray *eventList = [NSMutableArray array];
    for (NSDictionary *eventDict in eventDictList) {
        [eventList addObject:[JMBoomSDKEventItem eventWithDict:eventDict]];
    }
    return [eventList copy];
}

- (BOOL)remove:(NSString *)fileName {
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:[self fullPath:fileName] error:&error];
    return !error;
}

#pragma mark - 文件批处理

- (void)uploadHistory {
    NSArray *fileList = [self fileList];
    
    for (NSInteger i = 0; i < fileList.count && i <= 1; i++) {
        NSString *fileName = fileList[i];
        
        NSArray <JMBoomSDKEventItem *>* events = [self read:fileName];
        [self uploadEvents:events];
        
        [self remove:fileName];
    }
}

- (NSArray *)fileList {
    NSArray *fileNames = [[NSFileManager defaultManager] subpathsAtPath:self.directoryPath];
    fileNames = [fileNames sortedArrayUsingComparator:^NSComparisonResult(NSString *fileName1, NSString *fileName2) {
        if ([fileName1 integerValue] > [fileName2 integerValue]) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
    return fileNames;
}

#pragma mark - getter

- (NSMutableArray *)eventList {
    if (!_eventList) {
        _eventList = [NSMutableArray array];
    }
    return _eventList;
}

@end
