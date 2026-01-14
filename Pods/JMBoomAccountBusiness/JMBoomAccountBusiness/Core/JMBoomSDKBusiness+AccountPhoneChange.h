//
//  JMBoomSDKBusiness+AccountPhoneChange.h
//  JMBoomSDK
//
//  Created by Thief Toki on 2021/2/4.
//

#import <JMBoomSDKBase/JMBoomSDKBase.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomSDKBusiness (AccountPhoneChange)

///换绑手机号验证
/// @param callback 回调
- (void)phoneChangeWithCallback:(JMBusinessCallback)callback;

@end

NS_ASSUME_NONNULL_END
