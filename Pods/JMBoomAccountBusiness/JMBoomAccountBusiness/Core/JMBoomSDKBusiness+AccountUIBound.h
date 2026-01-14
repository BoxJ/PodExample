//
//  JMBoomSDKBusiness+AccountUIBound.h
//  JMBoomSDK
//
//  Created by Thief Toki on 2021/2/4.
//

#import <JMBoomSDKBase/JMBoomSDKBase.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomSDKBusiness (AccountUIBound)

/// 展示转正（绑定手机号）提示弹框
/// [ success: 确认; failed: -; cancel: 取消 ]
- (void)showBoundTipsModalViewWithResponder:(JMResponder *)responder;

/// 展示登录转正（绑定手机号）弹框
/// isLock = NO [ success: 转正成功（已实名/未实名）; failed: -; cancel: 取消转正 ]
/// isLock = YES [ success: 转正成功（已实名/未实名）; failed: -; cancel: - ]
/// hasRegisterCL 如果创蓝管理器中没有手机号，是否执行手机号获取
- (void)showLoginBoundModalViewWithLock:(BOOL)isLock
                          hasRegisterCL:(BOOL)hasRegisterCL
                              responder:(JMResponder *)responder;

/// 展示充值转正（绑定手机号）弹框
/// isLock = NO [ success: 转正成功（已实名/未实名）; failed: -; cancel: 取消转正 ]
/// isLock = YES [ success: 转正成功（已实名/未实名）; failed: -; cancel: - ]
/// hasRegisterCL 如果创蓝管理器中没有手机号，是否执行手机号获取
- (void)showRechargeBoundModalViewWithLock:(BOOL)isLock
                             hasRegisterCL:(BOOL)hasRegisterCL
                                 responder:(JMResponder *)responder;

/// 展示转正（绑定手机号）提示弹框，若用户同意则展示转正（绑定手机号）弹框
/// isLock = NO [ success: 转正成功（已实名/未实名）; failed: -; cancel: 取消转正 ]
/// isLock = YES [ success: 转正成功（已实名/未实名）; failed: -; cancel: - ]
- (void)showBoundTipsModalViewWithLock:(BOOL)isLock responder:(JMResponder *)responder;

/// 展示换绑手机号触发的实名认证提示弹框
/// [ success: 确认; failed: -; cancel: 取消 ]
- (void)showBoundChangeTriggerRealNameAuthenticationTipsModalViewWithResponder:(JMResponder *)responder;

@end

NS_ASSUME_NONNULL_END
