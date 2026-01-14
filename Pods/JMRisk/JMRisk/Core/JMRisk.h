//
//  JMRisk.h
//  JMRisk
//
//  Created by ZhengXianda on 09/11/2024.
//  Copyright (c) 2024 ZhengXianda. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <JMRktCommon/JMRktCommon.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMRisk : NSObject

#pragma mark - shared

+ (JMRisk *)shared;

/**
 * 初始化接口，客户启动app时调用，只需调用一次
 *
 * @param productId        易盾官网注册的AppId
 * @param callback        回调信息
 *
 */
- (void)init:(NSString *)productId callback:(JMRktCommonCallback)callback;

/**
 * 获取Token，10s超时
 *
 * @param businessId               场景id
 * @param callback                      获取Token完成后回调
 */
- (void)getToken:(NSString *)businessId
      completeHandler:(JMRktCommonCallback)callback;

/**
 *  设置用户角色信息,用户登录或者切换账号后请调用这个接口,在此之前确保已调用init.(调用这个接口后，才会启动外挂保护功能)
 *
 *  @param businessId                业务id
 *  @param roleId                    用户id
 *  @param roleName                  用户名字
 *  @param roleAccount               用户账号名
 *  @param roleServer                用户服务器
 *  @param serverId                  用户服务器id
 *  @param gameJson                  客户端自定义json
 *
 *  @注意事项                          上述参数除businessId必填外，可根据实际情况进行传入，所填信息需要能够定位到当前登陆玩家
 */
- (void)roleLogin:(NSString *)businessId
           roleId:(NSString *)roleId
         roleName:(NSString *)roleName
      roleAccount:(NSString *)roleAccount
       roleServer:(NSString *)roleServer
         serverId:(int)serverId
         gameJson:(NSString *)gameJson
         callback:(JMRktCommonCallback)callback;

/**
 *  退出登陆
 *
 *  @注意事项 调用setRoleInfoWithRoleId接口后再调用该接口,不能放在setRoleInfoWithRoleId的前面调用
 */
- (void)roleLogout;

/**
 * 设置服务器所属地区
 *
 * @param type              服务器类型(1:中国大陆;2:中国台湾3:其他区域。4：欧盟区域 默认大陆,不需要设置，如需接入台湾服务需要单独开通，请与商务联系。)
 */
+ (void)setServerType:(NSInteger)type;

/**
 * 设置渠道信息，供用户传入该app的渠道信息（App Store）
 *
 * @param channel              渠道信息
 */
+ (void)setChannel:(NSString *)channel;

/**
 * 设置额外信息，用户希望我们在数据上报中包含的额外信息，使用该接口设置，可多次调用
 *
 * @param key              设置额外信息的key
 * @param value          设置额外信息的值
 */
+ (void)setExtraData:(NSString *)key forValue:(NSString *)value;

/**
 * 设置通用访问的域名，即BASE_URL
 *
 *  @param host             域名
 *
 */
+ (void)setHost:(NSString *)host;

@end

NS_ASSUME_NONNULL_END
