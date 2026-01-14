//
//  JMBoomSDKRequest+JMBoomRechargeBusiness.m
//  JMBoomRechargeBusiness
//
//  Created by ZhengXianda on 11/02/2022.
//  Copyright (c) 2022 ZhengXianda. All rights reserved.
//

#import "JMBoomSDKRequest+JMBoomRechargeBusiness.h"

@implementation JMBoomSDKRequest (JMBoomRechargeBusiness)

- (void)rechargeLimitCheckWithAmount:(int32_t)amount
                            callback:(JMBusinessCallback)callback {
    NSString *path = @"/client/recharge/check";
    NSDictionary *parameters = @{
        @"amount": @(amount),
    };

    [self requestDataWithMethod:JMRequestMethodType_POST
                           path:path
                     parameters:parameters
                       callback:callback];
}

- (void)rechargeCheckWithOrderNo:(NSString *)orderNo
                         receipt:(NSString *)receipt
                        callback:(JMBusinessCallback)callback {
    NSString *path = @"/client/recharge/iap/check/v2";
    NSDictionary *parameters = @{
        @"cpOrderNo": orderNo,
        @"receipt": receipt,
    };

    [self requestDataWithMethod:JMRequestMethodType_POST_JSON
                           path:path
                     parameters:parameters
                       callback:callback];
}

- (void)rechargeCreateWithOrderNo:(NSString *)orderNo
                        productId:(NSString *)productId
                          subject:(NSString *)subject
                             body:(NSString *)body
                           amount:(int32_t)amount
                         callback:(JMBusinessCallback)callback {
    NSString *path = @"/client/recharge/order/create/v3";
    NSDictionary *parameters = @{
        @"cpOrderNo": orderNo,
        @"extra": [NSString stringWithFormat:@"{\n  \"productId\" : \"%@\"\n}",productId],
        @"purchaseChannel": @"3",
        @"subject": subject,
        @"body": body,
        @"amount": @(amount),
    };

    [self requestDataWithMethod:JMRequestMethodType_POST_JSON
                           path:path
                         header:@{}
                  headerSignKey:@""
                headerSignOrder:@[]
                     parameters:parameters
              parametersSignKey:@"sign"
            parametersSignOrder:@[@"amount",
                                  @"body",
                                  @"cpOrderNo",
                                  @"extra",
                                  @"goodsCount",
                                  @"goodsId",
                                  @"openId",
                                  @"purchaseChannel",
                                  @"subject"]
                           body:nil
                       callback:callback];
}

@end
