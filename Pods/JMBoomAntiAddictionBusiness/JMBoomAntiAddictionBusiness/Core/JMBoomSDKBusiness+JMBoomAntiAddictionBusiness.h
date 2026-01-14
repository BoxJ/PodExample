//
//  JMBoomSDKBusiness+JMBoomAntiAddictionBusiness.h
//  JMBoomSDK
//
//  Created by Thief Toki on 2021/2/4.
//

#import <JMBoomSDKBase/JMBoomSDKBase.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomSDKBusiness (JMBoomAntiAddictionBusiness)

/// 检查用户剩余时长
/// @param callback 回调
- (void)antiAddictionRemainWithCallback:(JMBusinessCallback)callback;

/// 防沉迷计时
/// @param callback 计时触发限制的回调
- (void)antiAddictionCountingWithCallback:(JMBusinessCallback)callback;

/// 防沉迷计时暂停
- (void)antiAddictionCountingPause;

@end

NS_ASSUME_NONNULL_END
