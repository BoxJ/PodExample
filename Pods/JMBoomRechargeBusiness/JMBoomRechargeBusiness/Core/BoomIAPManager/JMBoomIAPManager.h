//
//  JMBoomIAPManager.h
//  JMBoomSDK
//
//  Created by Thief Toki on 2020/7/7.
//

#import <Foundation/Foundation.h>

#import <JMBusiness/JMBusiness.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomIAPManager : NSObject

+ (instancetype)shared;

- (void)initIAPManagerWithCallback:(JMBusinessCallback)callback;

- (void)rechargeWithOrderNo:(NSString *)orderNo
                  productId:(NSString *)productId
                    subject:(NSString *)subject
                       body:(NSString *)body
                     amount:(int32_t)amount
                   callback:(JMBusinessCallback)callback;

@end

NS_ASSUME_NONNULL_END
