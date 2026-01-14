//
//  JMBoomSDKBusiness+JMBoomInitializeBusiness.h
//  JMBoomInitializeBusiness
//
//  Created by Thief Toki on 2021/2/4.
//

#import <JMBoomSDKBase/JMBoomSDKBase.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomSDKBusiness (JMBoomInitializeBusiness)

/// 初始化SDK
/// @param appId AppId
/// @param secretKey 加密关键字
/// @param hasTracking 是否开启跟踪
/// @param callback 初始化回调
- (void)initializeApp:(NSString *)appId
            secretKey:(NSString *)secretKey
          hasTracking:(BOOL)hasTracking
             callback:(JMBusinessCallback)callback;

/// 初始化SDK
/// @param appId AppId
/// @param secretKey 加密关键字
/// @param callback 初始化回调
- (void)initializeApp:(NSString *)appId
            secretKey:(NSString *)secretKey
             callback:(JMBusinessCallback)callback;

/// 上传角色信息
/// @param ext 附加内容
/// @param callback 回调
- (void)uploadChapter:(NSString * _Nullable)chapter
            guildName:(NSString * _Nullable)guildName
          roleBalance:(NSString * _Nullable)roleBalance
               roleId:(NSString * _Nullable)roleId
               roleLv:(NSString * _Nullable)roleLv
             roleName:(NSString * _Nullable)roleName
            rolePower:(NSString * _Nullable)rolePower
            serviceId:(NSString * _Nullable)serviceId
          serviceName:(NSString * _Nullable)serviceName
                vipLv:(NSString * _Nullable)vipLv
                  ext:(NSDictionary * _Nullable)ext
             callback:(JMBusinessCallback)callback;

@end

NS_ASSUME_NONNULL_END
