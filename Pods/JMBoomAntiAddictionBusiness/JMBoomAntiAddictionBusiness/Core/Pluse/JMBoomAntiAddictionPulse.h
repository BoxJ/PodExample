//
//  JMBoomAntiAddictionPulse.h
//  JMBoomSDK
//
//  Created by Thief Toki on 2021/2/3.
//

#import <JMUtils/JMUtils.h>

#import <JMBusiness/JMBusiness.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomAntiAddictionPulse : JMPulse

+ (instancetype)shared;

- (void)beatWithCallback:(JMBusinessCallback)callback;

@end

NS_ASSUME_NONNULL_END
