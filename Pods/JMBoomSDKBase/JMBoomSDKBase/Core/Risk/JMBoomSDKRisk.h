
#import <JMBusiness/JMBusiness.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomSDKRisk : NSObject

#pragma mark - shared

+ (instancetype)shared;

/// 初始化
/// - Parameters:
///   - productId: ProductID
///   - callback: 回调
- (void)initWithProductID:(NSString *)productId completeHandler:(JMBusinessCallback)callback;

/// 异步获取Token
/// - Parameters:
///   - businessId: 业务ID
///   - callback: 回调
- (void)getToken:(NSString *)businessId completeHandler:(JMBusinessCallback)callback;

/// 设置用户信息
/// - Parameters:
///   - businessId: 业务ID
///   - roleId: 用户/玩家的角色 ID，非游戏类型应用，roleId 可以与 roleAccount 相同
///   - roleName: 用户/玩家的角色名称，非游戏类型应用，roleName 可以是当前用户昵称相同
///   - roleAccount: 用户/玩家的账号，如业务方同时接入易盾反垃圾，则此账号需要与反垃圾接入中的account一致
///   - roleServer: 用户/玩家的角色的服务器名称
///   - serverId: 用户/玩家的角色所属服务器的 ID
///   - gameJson: 游戏类型应用需要上传的信息，对应一个 json 字符串
///   - callback: 回调
- (void)roleLogin:(NSString *)businessId
           roleId:(NSString *)roleId
         roleName:(NSString *)roleName
      roleAccount:(NSString *)roleAccount
       roleServer:(NSString *)roleServer
         serverId:(int)serverId
         gameJson:(NSString *)gameJson
         callback:(JMBusinessCallback)callback;

/// 登出
- (void)roleLogout;

@end

NS_ASSUME_NONNULL_END
