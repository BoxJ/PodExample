//
//  JMBoomSDKRequest+JMBoomRechargeBusiness.h
//  JMBoomRechargeBusiness
//
//  Created by ZhengXianda on 11/02/2022.
//  Copyright (c) 2022 ZhengXianda. All rights reserved.
//

#import <JMBoomSDKBase/JMBoomSDKBase.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomSDKRequest (JMBoomRechargeBusiness)

- (void)rechargeLimitCheckWithAmount:(int32_t)amount
                            callback:(JMBusinessCallback)callback;

- (void)rechargeCheckWithOrderNo:(NSString *)orderNo
                         receipt:(NSString *)receipt
                        callback:(JMBusinessCallback)callback;

- (void)rechargeCreateWithOrderNo:(NSString *)orderNo
                        productId:(NSString *)productId
                          subject:(NSString *)subject
                             body:(NSString *)body
                           amount:(int32_t)amount
                         callback:(JMBusinessCallback)callback;

@end

NS_ASSUME_NONNULL_END
