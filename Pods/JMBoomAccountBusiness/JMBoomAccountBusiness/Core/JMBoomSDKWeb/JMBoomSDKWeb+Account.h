//
//  JMBoomSDKWeb+Account.h
//  JMBoomSDK
//
//  Created by Thief Toki on 2021/2/4.
//

#import <JMBoomSDKBase/JMBoomSDKBase.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomSDKWeb (Account)

- (instancetype)initChangePhoneWithVerifyCodeLength:(NSInteger)codeLength;
- (instancetype)initChangeAccountWithVerifyCodeLength:(NSInteger)codeLength;
- (instancetype)initAccountClosingWithVerifyCodeLength:(NSInteger)codeLength waitingDays:(NSUInteger)waitingDays;

@end

NS_ASSUME_NONNULL_END
