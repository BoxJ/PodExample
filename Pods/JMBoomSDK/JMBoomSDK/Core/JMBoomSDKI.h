//
//  JMBoomSDKI.h
//  JMBoomSDK
//
//  Created by ZhengXianda on 10/31/2022.
//  Copyright (c) 2022 ZhengXianda. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <JMBoomSDK/JMBoomSDKCallback.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomSDKI: NSObject

+ (void)showSDKInfo;

#pragma mark - shared

+ (instancetype)shared;

/// 设置日志调试开关
/// @param isDebug 调试开关，默认为NO
+ (void)debug:(BOOL)isDebug;

#pragma mark - 初始化模块

/// 注册沙盒App
/// @param appId AppId
/// @param secretKey 加密关键字
/// @param callback 初始化回调
- (void)registerShadowApp:(NSString *)appId
                secretKey:(NSString *)secretKey
                 callback:(JMBoomSDKCallback)callback;

/// 注册沙盒App
/// @param appId AppId
/// @param secretKey 加密关键字
/// @param hasTracking 是否开启广告跟踪
/// @param callback 初始化回调
- (void)registerShadowApp:(NSString *)appId
                secretKey:(NSString *)secretKey
              hasTracking:(BOOL)hasTracking
                 callback:(JMBoomSDKCallback)callback;

/// 注册App
/// @param appId AppId
/// @param secretKey 加密关键字
/// @param callback 初始化回调
- (void)registerApp:(NSString *)appId
          secretKey:(NSString *)secretKey
           callback:(JMBoomSDKCallback)callback;

/// 注册App
/// @param appId AppId
/// @param secretKey 加密关键字
/// @param hasTracking 是否开启广告跟踪
/// @param callback 初始化回调
- (void)registerApp:(NSString *)appId
          secretKey:(NSString *)secretKey
        hasTracking:(BOOL)hasTracking
           callback:(JMBoomSDKCallback)callback;

/// 订阅SDK通知
/// @param callback 通知内容
/// type: 0; 退出登录
/// content: {}; 附加内容
- (void)subscribeNotification:(JMBoomSDKCallback)callback;

#pragma mark - 实名模块


/// 获取实名认证状态
/// @param callback 回调
- (void)identityStatusWithCallback:(JMBoomSDKCallback)callback;

/// 实名认证
/// @param idCardNumber 身份正号吗
/// @param realName 真实姓名
/// @param callback 回调
- (void)identityVerifyWithIdCardNumber:(NSString *)idCardNumber
                        realName:(NSString *)realName
                        callback:(JMBoomSDKCallback)callback;

#pragma mark - 充值模块

/// 充值资格检查
/// @param amount 充值金额,单位：分，范围[1,100000]
/// @param callback 回调
- (void)rechargeLimitCheckWithAmount:(int32_t)amount
                            callback:(JMBoomSDKCallback)callback;

/// iap充值
/// @param orderNo 订单号
/// @param productId 商品Id
/// @param subject 商品的标题/交易标题/订单标题/订单关键字 最大长度128
/// @param body 对一笔交易的具体描述信息 最大长度256
/// @param amount 充值金额,单位：分，范围[1,100000]
/// @param callback 回调
- (void)rechargeWithOrderNo:(NSString *)orderNo
                  productId:(NSString *)productId
                    subject:(NSString *)subject
                       body:(NSString *)body
                     amount:(int32_t)amount
                   callback:(JMBoomSDKCallback)callback;

#pragma mark - 账号模块

#pragma mark 登录

/// 自动登录
/// @param callback 回调
- (void)loginWithCallback:(JMBoomSDKCallback)callback;

/// 一键登录
/// @param callback 回调
- (void)quickLoginWithCallback:(JMBoomSDKCallback)callback;

/// 手机号登录
/// @param phoneNumber 手机号
/// @param verificationCode 验证码
/// @param callback 回调
- (void)phoneLoginWithPhoneNumber:(NSString *)phoneNumber
                 verificationCode:(NSString *)verificationCode
                         callback:(JMBoomSDKCallback)callback;

/// 游客登录
/// @param callback 回调
- (void)guestLoginWithCallback:(JMBoomSDKCallback)callback;

/// 登录中断后，继续登录
/// @param traceId 中断的登录的操作Id，在回调内容查看
/// @param traceType 中断的登录操作类型，暂时没用
/// @param callback 回调
- (void)loginContinueWithTraceId:(NSString *)traceId
                       traceType:(NSInteger)traceType
                        callback:(JMBoomSDKCallback)callback;

#pragma mark 绑定手机号

/// 游客一键转正
- (void)quickGuestBoundWithCallback:(JMBoomSDKCallback)callback;

/// 游客转正
/// @param phoneNumber 手机号
/// @param verificationCode 验证码
/// @param callback 回调
- (void)guestBoundWithPhoneNumber:(NSString *)phoneNumber
                 verificationCode:(NSString *)verificationCode
                         callback:(JMBoomSDKCallback)callback;

#pragma mark 换绑

/// 换绑手机号
/// @param callback 回调
- (void)phoneChangeWithCallback:(JMBoomSDKCallback)callback;

/// 账号迁移
/// @param callback 回调
- (void)accountChangeWithCallback:(JMBoomSDKCallback)callback;

#pragma mark 登出

///登出
- (void)logout;

#pragma mark 注销

/// 账号注销前的账号信息验证
/// @param waitingDays 注销冷静期，即waitingDays天后完成注销，取值范围 7～30，默认为7
/// @param callback 回调
- (void)accountClosingCheckWaitingDays:(NSUInteger)waitingDays
                              callback:(JMBoomSDKCallback)callback;

/// 账号注销前的用户身份信息验证
/// @param idCardNumber 身份证号
/// @param callback 回调
- (void)accountClosingCheckIdCardNumber:(NSString *)idCardNumber
                               callback:(JMBoomSDKCallback)callback;

/// 账号注销前的请求验证码
/// @param phoneNumber 手机号
/// @param callback 回调
- (void)accountClosingSendVerificationCode:(NSString *)phoneNumber
                                  callback:(JMBoomSDKCallback)callback;

/// 账号注销前的手机号身份验证
/// @param phoneNumber 手机号
/// @param verificationCode 验证码
/// @param callback 回调
- (void)accountClosingCheckPhoneNumber:(NSString *)phoneNumber
                      verificationCode:(NSString *)verificationCode
                              callback:(JMBoomSDKCallback)callback;

/// 账号注销启动
/// @param accept 用户确认，若用户未确认则取消注销行为
/// @param callback 回调
- (void)accountClosingComplete:(BOOL)accept
                      callback:(JMBoomSDKCallback)callback;

#pragma mark - 通用

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
            serverId:(NSString * _Nullable)serverId
          serverName:(NSString * _Nullable)serverName
                vipLv:(NSString * _Nullable)vipLv
                  ext:(NSDictionary * _Nullable)ext
             callback:(JMBoomSDKCallback)callback;

/// 获取用户信息
/// @param callback 回调
- (void)userInfoWithCallback:(JMBoomSDKCallback)callback;

/// 获取手机号信息
/// @param callback 回调
- (void)phoneInfoWithCallback:(JMBoomSDKCallback)callback;

/// 获取验证码，登录、注册或绑定手机号时使用
/// @param phoneNumber 手机号
/// @param callback 回调
- (void)verificationCodeWithPhoneNumber:(NSString *)phoneNumber
                               callback:(JMBoomSDKCallback)callback;

#pragma mark - 防沉迷模块

/// 检查用户剩余时长
/// @param callback 回调
- (void)antiAddictionRemainWithCallback:(JMBoomSDKCallback)callback;

/// 开启登录时长统计
- (void)antiAddictionCounting;


#pragma mark - 七鱼客服

-(void)initQiYuCustomerWithAppKey:(NSString *)appKey appName:(NSString *)appName groupId:(nullable NSString *)groupId staffId:(nullable NSString *)staffId callback:(JMBoomSDKCallback)callback;

/// 设置游戏信息
/// - Parameters:
///   - userId: 游戏用户ID
///   - avatarUrl: 游戏用户头像 (可空)
-(void)setQiYuGameUserID:(NSString *)userId avatar:(nullable NSString *)avatarUrl callback:(JMBoomSDKCallback)callback;

/// 打开客服页面
-(void)openQiYuCustomerSessionWithCallback:(JMBoomSDKCallback)callback;


/// 打开客服
/// - Parameters:
///   - accountId: 用户ID
///   - avatarUrl: 用户头像
///   - callback: 回调
-(void)openCustomerSessionWithAccountID:(nullable NSString *)accountId avatar:(nullable NSString *)avatarUrl callback:(JMBoomSDKCallback)callback;

/// 客服退出登录
-(void)logoutQiYuCustomer;

#pragma mark - 易盾智能风控

/// 获取凭证
/// - Parameters:
///   - businessId: 业务ID
///   - callback: 回调
- (void)getToken:(NSString *)businessId completeHandler:(JMBoomSDKCallback)callback;


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
         callback:(JMBoomSDKCallback)callback;


/// 登出
- (void)roleLogout;

@end

NS_ASSUME_NONNULL_END
