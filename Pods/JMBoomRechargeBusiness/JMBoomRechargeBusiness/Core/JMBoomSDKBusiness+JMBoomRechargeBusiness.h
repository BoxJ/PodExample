//
//  JMBoomSDKBusiness+JMBoomRechargeBusiness.h
//  JMBoomSDK
//
//  Created by Thief Toki on 2021/2/4.
//

#import <JMBoomSDKBase/JMBoomSDKBase.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomSDKBusiness (JMBoomRechargeBusiness)

///读取订单号
- (NSString *)localLatestOrderNumber;
///写入订单号
- (void)localLatestOrderNumber:(NSString *)orderNo;

/// 充值资格检查
/// @param amount 充值金额,单位：分，范围[1,100000]
/// @param callback 回调
- (void)rechargeLimitCheckWithAmount:(int32_t)amount
                            callback:(JMBusinessCallback)callback;

/// iap充值
/// @param orderNo 订单号
/// @param productId 商品Id
/// @param subject 商品的标题/交易标题/订单标题/订单关键字 最大长度128
/// @param body 对一笔交易的具体描述信息 最大长度256
/// @param amount 充值金额,单位：分，范围[1,100000]
/// @param callback 回调
- (void)rechargeWithOrderNo:(NSString *)orderNo
                  productId:(NSString *)productId
                    subject:(NSString *)subject
                       body:(NSString *)body
                     amount:(int32_t)amount
                   callback:(JMBusinessCallback)callback;

@end

NS_ASSUME_NONNULL_END
