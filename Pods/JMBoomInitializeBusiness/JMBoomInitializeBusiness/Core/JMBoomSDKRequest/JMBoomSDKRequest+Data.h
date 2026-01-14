//
//  JMBoomSDKRequest+Data.h
//  JMBoomInitializeBusiness
//
//  Created by ZhengXianda on 2022/7/5.
//

#import "JMBoomSDKRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomSDKRequest (Data)

/// 上传角色信息
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
             callback:(JMRequestCallback)callback;

@end

NS_ASSUME_NONNULL_END
