//
//  JMBoomSDKBusiness+JMBoomRechargeBusiness.m
//  JMBoomSDK
//
//  Created by Thief Toki on 2021/2/4.
//

#import "JMBoomSDKBusiness+JMBoomRechargeBusiness.h"

#import "JMBoomIAPManager.h"

#import "JMBoomSDKRequest+JMBoomRechargeBusiness.h"

@implementation JMBoomSDKBusiness (JMBoomRechargeBusiness)

#define kJMBoomSDKLatestOrderNumberKey @"kJMBoomSDKLatestOrderNumberKey"

- (NSString *)localLatestOrderNumber {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kJMBoomSDKLatestOrderNumberKey];
}

- (void)localLatestOrderNumber:(NSString *)orderNo {
    [[NSUserDefaults standardUserDefaults] setObject:orderNo forKey:kJMBoomSDKLatestOrderNumberKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)rechargeLimitCheckWithAmount:(int32_t)amount
                            callback:(JMBusinessCallback)callback {
    [JMBoomSDKBusiness.request rechargeLimitCheckWithAmount:amount
                                                       callback:callback];
}

- (void)rechargeWithOrderNo:(NSString *)orderNo
                        productId:(NSString *)productId
                          subject:(NSString *)subject
                             body:(NSString *)body
                           amount:(int32_t)amount
                         callback:(JMBusinessCallback)callback {
    [[JMBoomIAPManager shared] rechargeWithOrderNo:orderNo
                                         productId:productId
                                           subject:subject
                                              body:body
                                            amount:amount
                                          callback:callback];
}

@end
