//
//  JMBoomSDKBusiness+JMBoomRealNameBusinessUI.h
//  JMBoomSDK
//
//  Created by Thief Toki on 2021/2/4.
//

#import <JMBoomSDKBase/JMBoomSDKBase.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomSDKBusiness (JMBoomRealNameBusinessUI)

/// 展示实名认证弹框
/// [ success: 已完成; failed: -; cancel: 未实名 ]
- (void)showRealNameAuthenticationViewWithCallback:(JMBusinessCallback)callback;

/// 检查用户是否完成“实名认证确认“
/// [ success: 已完成; failed: 报错; cancel: 未实名 ]
- (void)checkRealNameStatusConfirmWithResponder:(JMResponder *)responder;

/// 检查用户是否完成“实名认证“
/// [ success: 已完成; failed: 报错; cancel: 未实名 ]
- (void)checkRealNameStatusWithResponder:(JMResponder *)responder;

/// 检查用户是否完成“实名认证“，若未完成则展示实名认证弹框
/// [ success: 已完成; failed: 报错; cancel: 未实名 ]
- (void)checkRealNameStatusWithLock:(BOOL)isLock responder:(JMResponder *)responder;

/// 检查用户是否完成"实名认证"，若未完成会进入实名认证流程
/// [ success: 已完成; failed: 报错; cancel: 未实名 ]
- (void)checkRealNameOfLoginWithResponder:(JMResponder *)responder;

/// 检查手机号登录的用户是否完成"实名认证"，若未完成会进入实名认证流程
/// [ success: 已完成; failed: 报错; cancel: 未实名 ]
- (void)checkRealNameOfPhoneLoginWithResponder:(JMResponder *)responder;

/// 检查游客用户是否完成"实名认证"，若未完成会进入实名认证流程
/// [ success: 已完成; failed: 报错; cancel: 未实名 ]
- (void)checkRealNameOfGuestLoginWithResponder:(JMResponder *)responder;

/// 展示实名认证弹框
/// isLock = NO [ success: 已完成; failed: -; cancel: 未实名 ]
/// isLock = YES [ success: 已完成; failed: -; cancel: - ]
- (void)showRealNameAuthenticationViewWithLock:(BOOL)isLock responder:(JMResponder *)responder;

@end

NS_ASSUME_NONNULL_END
