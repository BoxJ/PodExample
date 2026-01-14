//
//  JMRktInfo.m
//  JMRktInfo
//
//  Created by ZhengXianda on 10/19/2022.
//  Copyright (c) 2022 ZhengXianda. All rights reserved.
//

#import "JMRktInfo.h"

#import <JMUtils/JMUtils.h>

#define GuestLoginMode_normal @"normal"
#define GuestLoginMode_local @"local"

@interface JMRktInfo ()

@property (nonatomic, strong, readwrite) NSString *signatureMethod; ///< 加密方法
@property (nonatomic, strong, readwrite) NSString *bundleId; ///< 包名
@property (nonatomic, strong, readwrite) NSString *appVersion; ///< App版本号
@property (nonatomic, strong, readwrite) NSString *IMSI; ///< 国际移动用户识别码
@property (nonatomic, strong, readwrite) NSString *model; ///< 设备类型
@property (nonatomic, strong, readwrite) NSString *version; ///< 设备系统版本
@property (nonatomic, strong, readwrite) NSString *resolution; ///< 设备分辨率
@property (nonatomic, strong, readwrite) NSString *ptype; ///< 设备平台类型
@property (nonatomic, strong, readwrite) NSString *env; ///< 运行环境
@property (nonatomic, strong, readwrite) NSString *IDFA; ///< 广告id
@property (nonatomic, strong, readwrite) NSString *UID; ///< 唯一识别码
@property (nonatomic, strong, readwrite) NSString *uniqueId; ///< 游客的唯一识别码

@end

@implementation JMRktInfo

#pragma mark - shared

+ (instancetype)shared {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - 本地数据 App Local Info

- (void)LoadUniqueId {
    [self localGuestLoginMode:GuestLoginMode_normal];
    self.uniqueId = [JMDeviceAnalyze UniqueId];
}

- (void)LoadUniqueIdLocal {
    [self localGuestLoginMode:GuestLoginMode_local];
    self.uniqueId = [JMDeviceAnalyze UniqueIdLocal];
}

- (void)CreateNewUniqueId {
    [self localGuestLoginMode:GuestLoginMode_normal];
    self.uniqueId = [JMDeviceAnalyze UniqueIdNewOne];
}

- (void)CreateNewUniqueIdLocal {
    [self localGuestLoginMode:GuestLoginMode_local];
    self.uniqueId = [JMDeviceAnalyze UniqueIdNewOneLocal];
}

#pragma mark - 本地数据 App Local Info

- (NSString *)timestamp {
    return [JMValue TimestampMillisecond];
}

- (NSString *)userAgent {
    if (![JMUserAgent shared].localUserAgent) {
        [[JMUserAgent shared] requestUserAgentWithCallback:^(NSString * _Nullable userAgent, NSError * _Nullable error) {
            if (error) {
                JMLog(@"UserAgent 重新获取失败: %@", error);
            } else {
                JMLog(@"UserAgent 重新获取成功: %@", userAgent);
            }
        }];
    }
    return [JMUserAgent shared].localUserAgent;
}

- (NSString *)nonce {
    return [JMValue Nonce];
}

- (void)loadLocalInfo {
    self.signatureMethod = @"HMAC-SHA1";
    self.bundleId = [JMDeviceAnalyze BundleId];
    self.appVersion = [JMDeviceAnalyze AppVersion];
    self.IMSI = [JMDeviceAnalyze IMSI];
    self.model = [JMDeviceAnalyze Platform];
    self.version = [JMDeviceAnalyze SystemVersion];
    self.resolution = [JMDeviceAnalyze Resolution];
    self.ptype = @"2";
    self.env = @"4";
    self.IDFA = [JMDeviceAnalyze IDFA];
    self.UID = [JMDeviceAnalyze UID];
    
    if ([[self localGuestLoginMode] isEqualToString:GuestLoginMode_normal]) {
        [self LoadUniqueId];
    } else {
        [self LoadUniqueIdLocal];
    }
}

#pragma mark - 初始化信息 App Register Info

- (void)registerApp:(NSString *)appId secretKey:(NSString *)secretKey {
    self.appId = appId;
    self.secretKey = secretKey;
    
    [self loadLocalInfo];
    [self loadExtendInfo];
}

#pragma mark - 扩展数据 App Extend Info

- (void)loadExtendInfo {
    
}

- (void)clearExtendInfo {
    
}

#pragma mark - 游客ID存储方式

#define kJMVoyageSDKGuestLoginMode @"kJMVoyageSDKGuestLoginMode"

- (NSString *)localGuestLoginMode {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kJMVoyageSDKGuestLoginMode];
}

- (void)localGuestLoginMode:(NSString *)mode {
    [[NSUserDefaults standardUserDefaults] setObject:mode forKey:kJMVoyageSDKGuestLoginMode];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
