//
//  JMRktQiniu.m
//  JMRktQiniu
//
//  Created by ZhengXianda on 10/19/2022.
//  Copyright (c) 2022 ZhengXianda. All rights reserved.
//

#import "JMRktQiniu.h"

@implementation JMRktQiniu

- (void)registerFilePath:(NSString *)filePath
               tokenHook:(void(^)(JMRktQiniuItem *item, JMRktCommonCallback callback))tokenHook {
    self.filePath = filePath;
    self.tokenHook = tokenHook;
}

#pragma mark - image

- (void)uploadImages:(NSArray <UIImage *>*)imageList callback:(JMRktCommonCallback)callback {
    NSMutableArray *imagePathList = [NSMutableArray array];
    for (UIImage *image in imageList) {
        [imagePathList addObject:[image saveCompress]];
    }
    [self uploadImageFiles:[imagePathList copy] callback:callback];
}

- (void)uploadImageFiles:(NSArray <NSString *>*)imageFileList callback:(JMRktCommonCallback)callback {
    if (imageFileList.count == 0) {
        callback([JMRktResponse successWithResult:@[]], nil);
        return;
    }
    
    NSMutableArray *itemList = [NSMutableArray array];
    for (NSString *imagePath in imageFileList) {
        JMRktQiniuItem *item = [[JMRktQiniuItem alloc] init];
        item.name = imagePath.lastPathComponent;
        item.path = imagePath;
        item.fileName = [NSString stringWithFormat:@"%@/image/%@", self.filePath, item.name];
        item.mimeType = @"";
        item.bucketType = JMRktQiniuBucketType_Default;
        item.sceneType = JMRktQiniuSceneType_Image;
        
        [itemList addObject:item];
    }
        
    [self uploadItemList:itemList callback:callback];
}

#pragma mark - log

- (void)uploadLogsWithCallback:(JMRktCommonCallback)callback {
    [self uploadLogFiles:[JMLogger shared].fileList callback:callback];
}

- (void)uploadLogsWithDate:(NSDate *)date callback:(JMRktCommonCallback)callback {
    [self uploadLogFiles:[[JMLogger shared] fileListUsingFilter:^BOOL(NSString *logName, NSUInteger idx, BOOL *stop) {
        NSDate *fileDate = [[JMLogger shared] attributes:logName][NSFileCreationDate];
        if ([date.weeDate isEqual:fileDate.weeDate]) {
            *stop = YES;
            return YES;
        }
        return NO;
    }] callback:callback];
}

- (void)uploadLogFiles:(NSArray <NSString *>*)logFiles callback:(JMRktCommonCallback)callback {
    if (logFiles.count == 0) {
        callback([JMRktResponse successWithResult:@[]], nil);
        return;
    }
    
    NSMutableArray *itemList = [NSMutableArray array];
    for (NSString *logName in logFiles) {
        JMRktQiniuItem *item = [[JMRktQiniuItem alloc] init];
        item.name = logName;
        item.path = [[JMLogger shared] fullPath:logName];
        item.fileName = [NSString stringWithFormat:@"%@/log/ios_%@.text", self.filePath, [[JMLogger shared] dateString:logName]];
        item.mimeType = @"text/plain";
        item.bucketType = JMRktQiniuBucketType_Default;
        item.sceneType = JMRktQiniuSceneType_Log;
        
        [itemList addObject:item];
    }
        
    [self uploadItemList:itemList callback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            [[JMLogger shared] clean];
        }
        callback(responseObject, error);
    }];
}

#pragma mark - util

- (void)uploadItemList:(NSArray <JMRktQiniuItem *>*)itemList callback:(JMRktCommonCallback)callback {
    NSMutableArray *uploadRecorder = [NSMutableArray array];
    for (NSInteger i = 0; i < itemList.count; i++) {
        [uploadRecorder addObject:@""];
    }
    for (NSInteger i = 0; i < itemList.count; i++) {
        JMRktQiniuItem *item = itemList[i];
        [self uploadItem:item callback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
            if (error) {
                callback(responseObject, error);
            } else {
                uploadRecorder[i] = responseObject[@"result"]?:@"fileKey";
                
                NSArray *surplusItems = [uploadRecorder filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"length = 0"]];
                if (!surplusItems.count) {
                    callback([JMRktResponse successWithResult:uploadRecorder], nil);
                }
            }
        }];
    }
}

- (void)uploadItem:(JMRktQiniuItem *)item callback:(JMRktCommonCallback)callback {
    self.tokenHook(item, ^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            callback(responseObject, error);
        } else {
            NSDictionary *result = responseObject[@"result"] ?: @{};
            [self putFile:item.path
                      key:result[@"fileKey"] ?: @""
                    token:result[@"uploadToken"] ?: @""
                 complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                if (info.ok) {
                    callback([JMRktResponse successWithResult:result[@"fileKey"]?:@""], nil);
                } else {
                    NSError *error = [JMRktResponse errorWithCode:info.statusCode message:info.message];
                    callback(error.responseValue, error);
                }
            }
                         option:[QNUploadOption defaultOptions]];
        }
    });
}

#pragma mark - getter

- (NSString *)filePath {
    if (!_filePath) {
        _filePath = @"rkt";
    }
    return _filePath;
}

@end
