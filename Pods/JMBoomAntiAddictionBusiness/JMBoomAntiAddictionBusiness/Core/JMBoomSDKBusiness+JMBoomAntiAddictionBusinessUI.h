//
//  JMBoomSDKBusiness+JMBoomAntiAddictionBusinessUI.h
//  JMBoomSDK
//
//  Created by Thief Toki on 2021/2/5.
//

#import <JMBoomSDKBase/JMBoomSDKBase.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomSDKBusiness (JMBoomAntiAddictionBusinessUI)

///防沉迷检查
/// [ success: 登录成功（通过检查）; failed: 重新登录（请求报错/ 触发限制后取消实名认证）; cancel: 登录成功（触发实名后取消） ]
- (void)checkAntiAddiction:(JMResponder *)responder;

@end

NS_ASSUME_NONNULL_END
