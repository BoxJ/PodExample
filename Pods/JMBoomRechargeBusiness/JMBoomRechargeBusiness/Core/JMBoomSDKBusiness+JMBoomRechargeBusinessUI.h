//
//  JMBoomSDKBusiness+JMBoomRechargeBusinessUI.h
//  JMBoomSDK
//
//  Created by Thief Toki on 2021/2/5.
//

#import <JMBoomSDKBase/JMBoomSDKBase.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomSDKBusiness (JMBoomRechargeBusinessUI)

- (void)showRechargeViewWithOrderNo:(NSString *)orderNo
                          productId:(NSString *)productId
                            subject:(NSString *)subject
                               body:(NSString *)body
                             amount:(int32_t)amount
                           callback:(JMBusinessCallback)callback;

@end

NS_ASSUME_NONNULL_END
