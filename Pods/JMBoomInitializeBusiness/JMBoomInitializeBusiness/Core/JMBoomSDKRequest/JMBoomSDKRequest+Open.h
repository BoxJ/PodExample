//
//  JMBoomSDKRequest+Open.h
//  JMBoomInitializeBusiness
//
//  Created by ZhengXianda on 2021/9/8.
//

#import <JMBoomSDKBase/JMBoomSDKBase.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomSDKRequest (Open)

///获取公共隐私协议
- (void)queryOpenPrivacyPolicyWithAppId:(NSString *)appId
                               callback:(JMRequestCallback)callback;

@end

NS_ASSUME_NONNULL_END
