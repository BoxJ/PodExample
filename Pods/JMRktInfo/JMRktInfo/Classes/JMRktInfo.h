//
//  JMRktInfo.h
//  JMRktInfo
//
//  Created by ZhengXianda on 10/19/2022.
//  Copyright (c) 2022 ZhengXianda. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMRktInfo : NSObject

#pragma mark - shared

+ (instancetype)shared;

#pragma mark - 本地数据 App Local Info

//静态
@property (nonatomic, strong, readonly) NSString *signatureMethod; ///< 加密方法
@property (nonatomic, strong, readonly) NSString *bundleId; ///< 包名
@property (nonatomic, strong, readonly) NSString *appVersion; ///< App版本号
@property (nonatomic, strong, readonly) NSString *IMSI; ///< 国际移动用户识别码
@property (nonatomic, strong, readonly) NSString *model; ///< 设备类型
@property (nonatomic, strong, readonly) NSString *version; ///< 设备系统版本
@property (nonatomic, strong, readonly) NSString *resolution; ///< 设备分辨率
@property (nonatomic, strong, readonly) NSString *ptype; ///< 设备平台类型
@property (nonatomic, strong, readonly) NSString *env; ///< 运行环境
@property (nonatomic, strong, readonly) NSString *IDFA; ///< 广告id
@property (nonatomic, strong, readonly) NSString *UID; ///< 唯一识别码
@property (nonatomic, strong, readonly) NSString *uniqueId; ///< 游客的唯一识别码
//动态
@property (nonatomic, strong, readonly) NSString *timestamp; ///<当前时间戳字符串
@property (nonatomic, strong, readonly) NSString *userAgent; ///<用户代理
@property (nonatomic, strong, readonly) NSString *nonce; ///<临时随机数

/// 加载新的 UniqueId 存于 KeyChain
- (void)LoadUniqueId;
/// 加载新的 UniqueId 存于 沙盒
- (void)LoadUniqueIdLocal;

/// 生成新的 UniqueId 存于 KeyChain
- (void)CreateNewUniqueId;
/// 生成新的 UniqueId 存于 沙盒
- (void)CreateNewUniqueIdLocal;

#pragma mark - 初始化信息 App Register Info

@property (nonatomic, strong) NSString *appId;///<AppId
@property (nonatomic, strong) NSString *secretKey;///<App密钥
- (void)registerApp:(NSString *)appId secretKey:(NSString *)secretKey;

#pragma mark - 扩展信息 App Extend Info

///扩展信息加载方法：如果有扩展信息添加，需要重写这两个方法实现初始加载和清除。
- (void)loadExtendInfo;
- (void)clearExtendInfo;

#pragma mark - 游客ID存储方式

- (NSString *)localGuestLoginMode;
- (void)localGuestLoginMode:(NSString *)mode;

@end

NS_ASSUME_NONNULL_END
