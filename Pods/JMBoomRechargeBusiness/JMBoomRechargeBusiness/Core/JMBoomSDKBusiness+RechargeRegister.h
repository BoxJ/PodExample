//
//  JMBoomSDKBusiness+RechargeRegister.h
//  JMBoomSDK
//
//  Created by Thief Toki on 2021/2/4.
//

#import <JMBoomSDKBase/JMBoomSDKBase.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomSDKBusiness (RechargeRegister)

/// 初始化充值管理器
/// @param callback 如果有未完成订单会触发回调，没有则回调不触发
- (void)registerIAPManagerWithCallback:(JMBusinessCallback)callback;

@end

NS_ASSUME_NONNULL_END
