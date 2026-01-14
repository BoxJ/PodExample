//
//  JMBoomSDKBusiness+AccountAccountChange.h
//  JMBoomSDK
//
//  Created by Thief Toki on 2024/2/21.
//

#import <JMBoomSDKBase/JMBoomSDKBase.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomSDKBusiness (AccountAccountChange)

///换绑手机号验证
/// @param callback 回调
- (void)accountChangeWithCallback:(JMBusinessCallback)callback;

@end

NS_ASSUME_NONNULL_END
