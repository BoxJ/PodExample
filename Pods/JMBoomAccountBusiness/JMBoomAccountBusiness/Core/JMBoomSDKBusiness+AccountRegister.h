//
//  JMBoomSDKBusiness+AccountRegister.h
//  JMBoomSDK
//
//  Created by Thief Toki on 2021/2/4.
//

#import <JMBoomSDKBase/JMBoomSDKBase.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomSDKBusiness (AccountRegister)

/// 初始化创蓝工具
- (void)registerCLManagerWithCallback:(JMBusinessCallback)callback;

@end

NS_ASSUME_NONNULL_END
