//
//  JMPayment.h
//  JMPayment
//
//  Created by xianda.zheng on 02/18/2021.
//  Copyright (c) 2021 xianda.zheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^JMPaymentProductsCallback)(SKProductsResponse *response);

@protocol JMPaymentServerNoticeDelegate

- (void)transactionDidCompleted:(NSString *)receiptString
            applicationUserName:(NSString *)applicationUserName
                  transactionId:(NSString *)transactionId
                     serverResp:(void(^)(id resp, NSError *error))resp;

- (void)transactionDidFailed:(NSError *)error;

@end

@interface JMPayment : NSObject <UIApplicationDelegate>

+ (instancetype)shared;

@property (nonatomic, weak) id<JMPaymentServerNoticeDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *completeTrans;
@property (nonatomic, strong) NSMutableArray *restoreTrans;
@property (nonatomic, strong) NSMutableArray *failedTrans;

///查询商品信息时间限制
@property (nonatomic, assign) NSTimeInterval queryProductInfoTimeout;
///查询商品信息
- (void)queryProductInfo:(NSString *)productIdentifier callback:(JMPaymentProductsCallback)callback;

- (void)addPayment:(NSString *)productIdentifier orderNumber:(NSString *)orderNumber;

- (void)startWithDelegate:(id<JMPaymentServerNoticeDelegate>)delegate;
- (void)contineuUnFinishedTransactions;

@end

NS_ASSUME_NONNULL_END
