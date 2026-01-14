//
//  JMBoomSDKBusiness+AntiAddictionError.h
//  JMBoomSDK
//
//  Created by Thief Toki on 2021/2/7.
//

#import <JMBoomSDKBase/JMBoomSDKBase.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomSDKBusiness (AntiAddictionError)

- (BOOL)errorIsAntiAddiction:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
