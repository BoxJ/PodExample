//
//  JMBoomSDKBusiness+AccountUIClosing.h
//  JMBoomSDK
//
//  Created by Thief Toki on 2021/2/5.
//

#import <JMBoomSDKBase/JMBoomSDKBase.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomSDKBusiness (AccountUIClosing)

- (void)showAccountClosingWithWaitingDays:(NSUInteger)waitingDays callback:(JMBusinessCallback)callback;

@end

NS_ASSUME_NONNULL_END
