//
//  JMBoomSDKRequest+JMBoomInitializeBusiness.h
//  JMBoomInitializeBusiness
//
//  Created by Thief Toki on 2021/1/20.
//

#import <JMBoomSDKBase/JMBoomSDKBase.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomSDKRequest (JMBoomInitializeBusiness)

///SDK验证
- (void)initSDKWithCallback:(JMRequestCallback)callback;

///激活
- (void)activateWithToken:(NSString *)token
                   adData:(NSString *)adData
                 callback:(JMRequestCallback)callback;

@end

NS_ASSUME_NONNULL_END
