//
//  JMBoomSDKUI.h
//  JMBoomSDK
//
//  Created by ZhengXianda on 10/31/2022.
//  Copyright (c) 2022 ZhengXianda. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <JMBoomSDK/JMBoomSDKCallback.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomSDKUI: NSObject

#pragma mark - shared

+ (instancetype)shared;

/// 设置日志调试开关
/// @param isDebug 调试开关，默认为NO
+ (void)debug:(BOOL)isDebug;

#pragma mark - 主题

typedef NS_ENUM(NSUInteger, JMBoomStyle) {
    JMBoomStyle_DEFAULT = 0, //默认
    JMBoomStyle_BLACKGOLD, //黑金
    JMBoomStyle_BLUE, //蓝色
    JMBoomStyle_ORANGE, //橙色
    JMBoomStyle_PURPLE, //紫色
};

/// 设置SDK图形界面风格
/// @param style 风格
- (void)registerStyle:(JMBoomStyle)style;

/// 自定义SDK图形界面主题
/// @param customTheme JSONString {Key:Value}
/// Key: JMBRNButtonBackgroundColor; 全局按钮（方形）背景色
/// Key: JMBRNButtonTitleFont; 全局按钮（方形）字体
/// Key: JMBRNButtonConfirmTitleColor; 全局按钮（方形）确认按钮字体颜色
/// Key: JMBRNButtonCancelTitleColor; 全局按钮（方形）取消按钮字体颜色
/// Key: JMBRNWindowTitleFont; 全局弹框标题字体
/// Key: JMBRNWindowCheckboxSelectedTintColor; 窗口勾选控件选中图片前景色
/// Key: JMBRNWindowPhoneIconTintColor; 窗口手机图标图片前景色
/// Key: JMBRNWindowGuestIconTintColor; 窗口游客图标图片前景色
/// Value: int字符串 "1"
/// Value: float字符串 "1.111"
/// Value: 文本字符串 "内容"
/// Value: ARGB字符串 "#FFAABBCC"
/// Value: 字体名称字符串 "Font-Bold"
- (void)registerCustomTheme:(NSString *)customTheme;

#pragma mark - 初始化

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

#pragma mark - 登录

/// 展示单机游戏登录视图
/// @param callback 登录结果
- (void)showLocalLoginViewWithCallback:(JMBoomSDKCallback)callback;

/// 展示登录视图
/// @param callback 登录结果
- (void)showLoginViewWithCallback:(JMBoomSDKCallback)callback;

/// 展示登录视图，无关闭按钮
/// @param callback 登录结果
- (void)showForcedLoginViewWithCallback:(JMBoomSDKCallback)callback;

#pragma mark - 实名模块

/// 展示实名认证视图
/// @param callback 实名验证流程结束的回调
- (void)showRealNameAuthenticationViewWithCallback:(JMBoomSDKCallback)callback;

#pragma mark - 充值模块

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

#pragma mark - 安全模块

/// 账号注销
/// @param waitingDays 注销冷静期，即waitingDays天后完成注销，取值范围 7～30，默认为7
- (void)accountClosingWaitingDays:(NSUInteger)waitingDays;

/// 换绑手机号
- (void)phoneChange;

/// 账号迁移
- (void)accountChange;

/// 登出
- (void)logout;

#pragma mark - 建议反馈

/// 展示建议反馈
- (void)showFeedbackWithCallback:(JMBoomSDKCallback)callback;

#pragma mark - 七鱼客服

-(void)initQiYuCustomerWithAppKey:(NSString *)appKey appName:(NSString *)appName groupId:(nullable NSString *)groupId staffId:(nullable NSString *)staffId callback:(JMBoomSDKCallback)callback;
-(void)setQiYuGameUserID:(NSString *)userId avatar:(nullable NSString *)avatarUrl callback:(JMBoomSDKCallback)callback;
-(void)openQiYuCustomerSessionWithCallback:(JMBoomSDKCallback)callback;
/// 打开客服
/// - Parameters:
///   - accountId: 用户ID
///   - avatarUrl: 用户头像
///   - callback: 回调
-(void)openCustomerSessionWithAccountID:(nullable NSString *)accountId avatar:(nullable NSString *)avatarUrl callback:(JMBoomSDKCallback)callback;
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
