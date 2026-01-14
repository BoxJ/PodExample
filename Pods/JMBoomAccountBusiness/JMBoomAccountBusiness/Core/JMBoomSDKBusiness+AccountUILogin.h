//
//  JMBoomSDKBusiness+AccountUILogin.h
//  JMBoomSDK
//
//  Created by Thief Toki on 2021/2/5.
//

#import <JMBoomSDKBase/JMBoomSDKBase.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomSDKBusiness (AccountUILogin)

- (void)showLoginViewWithLoginForced:(BOOL)loginForced callback:(JMBusinessCallback)callback;
- (void)showAutoLoginViewWithLoginForced:(BOOL)loginForced callback:(JMBusinessCallback)callback;
- (void)showManualLoginViewWithLoginForced:(BOOL)loginForced callback:(JMBusinessCallback)callback;

@end

NS_ASSUME_NONNULL_END
