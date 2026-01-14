//
//  JMRktQiniu.h
//  JMRktQiniu
//
//  Created by ZhengXianda on 10/19/2022.
//  Copyright (c) 2022 ZhengXianda. All rights reserved.
//

#import <Qiniu/QiniuSDK.h>

#import <JMUtils/JMUtils.h>
#import <JMUIKit/JMUIKit.h>
#import <JMRktCommon/JMRktCommon.h>
#import <JMRktQiniu/JMRktQiniuType.h>
#import <JMRktQiniu/JMRktQiniuItem.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMRktQiniu : QNUploadManager

@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, strong) void(^tokenHook)(JMRktQiniuItem *item, JMRktCommonCallback callback);

- (void)registerFilePath:(NSString *)filePath
               tokenHook:(void(^)(JMRktQiniuItem *item, JMRktCommonCallback callback))tokenHook;

- (void)uploadImages:(NSArray <UIImage *>*)imageList callback:(JMRktCommonCallback)callback;
- (void)uploadImageFiles:(NSArray <NSString *>*)imageFileList callback:(JMRktCommonCallback)callback;

- (void)uploadLogsWithCallback:(JMRktCommonCallback)callback;
- (void)uploadLogsWithDate:(NSDate *)date callback:(JMRktCommonCallback)callback;
- (void)uploadLogFiles:(NSArray <NSString *>*)logFiles callback:(JMRktCommonCallback)callback;

@end

NS_ASSUME_NONNULL_END
