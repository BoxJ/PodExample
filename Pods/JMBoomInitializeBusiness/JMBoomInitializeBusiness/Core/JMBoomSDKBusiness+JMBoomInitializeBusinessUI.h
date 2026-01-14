//
//  JMBoomSDKBusiness+JMBoomInitializeBusinessUI.h
//  JMBoomInitializeBusiness
//
//  Created by Thief Toki on 2021/2/4.
//

#import <JMBoomSDKBase/JMBoomSDKBase.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomSDKBusiness (JMBoomInitializeBusinessUI)

/// 初始化SDK
/// @param appId AppId
/// @param secretKey 加密关键字
/// @param hasTracking 是否开启跟踪
/// @param callback 初始化回调
- (void)initializeUIApp:(NSString *)appId
              secretKey:(NSString *)secretKey
            hasTracking:(BOOL)hasTracking
               callback:(JMBusinessCallback)callback;

/// 初始化SDK
/// @param appId AppId
/// @param secretKey 加密关键字
/// @param callback 初始化回调
- (void)initializeUIApp:(NSString *)appId
              secretKey:(NSString *)secretKey
               callback:(JMBusinessCallback)callback;

@end

NS_ASSUME_NONNULL_END
