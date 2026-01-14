//
//  JMBoomSDKBusiness+JMBoomRealNameBusiness.h
//  JMBoomSDK
//
//  Created by Thief Toki on 2021/2/4.
//

#import <JMBoomSDKBase/JMBoomSDKBase.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomSDKBusiness (JMBoomRealNameBusiness)

///读取实名认证确认标识
- (void)localkRealNameVerifyCompleted;
///写入实名认证确认标识
- (BOOL)isLocalkRealNameVerifyCompleted;

/// 获取实名认证状态
/// @param callback 回调
- (void)identityStatusWithCallback:(JMBusinessCallback)callback;

/// 实名认证
/// @param idCardNumber 身份正号吗
/// @param realName 真实姓名
/// @param callback 回调
- (void)identityVerifyWithIdCardNumber:(NSString *)idCardNumber
                              realName:(NSString *)realName
                              callback:(JMBusinessCallback)callback;

@end

NS_ASSUME_NONNULL_END
