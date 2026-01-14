//
//  JMBoomSDKRequest+JMBoomSDKConfig.h
//  JMBoomSDK
//
//  Created by Thief Toki on 2021/1/20.
//

#import <JMBoomSDKBase/JMBoomSDKRequest.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomSDKRequest (JMBoomSDKConfig)

- (void)fetchConfigWithCallback:(JMRequestCallback)callback;

@end

NS_ASSUME_NONNULL_END
