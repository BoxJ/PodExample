//
//  JMBoomIAPManager.m
//  JMBoomSDK
//
//  Created by Thief Toki on 2020/7/7.
//

#import "JMBoomIAPManager.h"

#import <JMPayment/JMPayment.h>
#import <JMBoomSDKBase/JMBoomSDKBase.h>

#import "JMBoomRechargeBusiness.h"

#import "JMBoomSDKRequest+JMBoomRechargeBusiness.h"

@interface JMBoomIAPManager () <JMPaymentServerNoticeDelegate>

@property (nonatomic, assign) int retryCount;
@property (nonatomic, strong) JMBusinessCallback callback;

@end

@implementation JMBoomIAPManager

#pragma mark - shared

+ (instancetype)shared {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        JMLog(@"IAP 初始化");
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)initIAPManagerWithCallback:(JMBusinessCallback)callback {
    JMLog(@"IAP 初始化代理");
    self.callback = callback;
    [[JMPayment shared] startWithDelegate:self];
}

#pragma mark - recharge

- (void)rechargeWithOrderNo:(NSString *)orderNo
                  productId:(NSString *)productId
                    subject:(NSString *)subject
                       body:(NSString *)body
                     amount:(int32_t)amount
                   callback:(JMBusinessCallback)callback {
    [JMBoomSDKBusiness.event uploadEvent:[JMBoomSDKEventItem event:JMBoomSDKEventId_Order_Start]];
    
    self.callback = callback;
    
    JMLog(@"IAP 创建订单请求| 订单号:%@", orderNo);
    __weak typeof(self) weakSelf = self;
    [JMBoomSDKBusiness.request rechargeCreateWithOrderNo:orderNo
                                                   productId:productId
                                                     subject:subject
                                                        body:body
                                                      amount:amount
                                                    callback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (error) {
            JMLog(@"IAP 创建订单失败| 订单号:%@", orderNo);
            [JMBoomSDKBusiness.event uploadEvent:[JMBoomSDKEventItem event:JMBoomSDKEventId_Order_Failed
                                                       error:error]];
            
            if (strongSelf.callback) strongSelf.callback(responseObject, error);
            strongSelf.callback = nil;
        } else {
            JMLog(@"IAP 创建订单成功 | 订单号:%@", orderNo);
            [JMBoomSDKBusiness.event uploadEvent:[JMBoomSDKEventItem event:JMBoomSDKEventId_Order_Successed]];
            
            [[JMBoomSDKBusiness shared] localLatestOrderNumber:orderNo];
            [[JMPayment shared] addPayment:productId orderNumber:orderNo];
        }
    }];
}

#pragma mark - Protocol

#pragma mark JMPaymentServerNoticeDelegate

- (void)transactionDidCompleted:(NSString *)receiptString
            applicationUserName:(NSString *)applicationUserName
                  transactionId:(NSString *)transactionId
                     serverResp:(void(^)(id resp, NSError *error))resp {
    [JMBoomSDKBusiness.event uploadEvent:[JMBoomSDKEventItem event:JMBoomSDKEventId_Pay_Successed]];
    
    __weak typeof(self) weakSelf = self;
    ///验证凭证
    NSString *orderNo = applicationUserName ?: [[JMBoomSDKBusiness shared] localLatestOrderNumber];
    JMLog(@"IAP 订单校验发起 | 订单号:%@ 凭证：%@", orderNo, [receiptString substringToIndex:10]);
    if (orderNo.length == 0) return;
    [JMBoomSDKBusiness.request rechargeCheckWithOrderNo:orderNo
                                                    receipt:receiptString
                                                   callback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (strongSelf.callback) strongSelf.callback(responseObject, error);
        strongSelf.callback = nil;
        
        if (error) {
            resp(responseObject, error);
            
            if ((error.code < 0) && (self.retryCount < 10)) {
                CGFloat retryInterval = [self Fibonacci:self.retryCount];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(retryInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    JMLog(@"IAP - 订单校验重试:%d | 订单号:%@ 凭证：%@", self.retryCount, orderNo, [receiptString substringToIndex:10]);
                    [[JMPayment shared] contineuUnFinishedTransactions];
                    self.retryCount++;
                });
            } else if (error.code == 21001) {
                JMLog(@"IAP 该笔订单充值已经入账 | 订单号:%@ 凭证：%@", orderNo, [receiptString substringToIndex:10]);
            } else {
                JMLog(@"IAP 订单校验失败 | 订单号:%@ 凭证：%@", orderNo, [receiptString substringToIndex:10]);
            }
        } else {
            resp(responseObject, nil);
            
            JMLog(@"IAP 订单校验成功 | 订单号:%@ 凭证：%@", orderNo, [receiptString substringToIndex:10]);
        }
    }];
}

- (void)transactionDidFailed:(NSError *)error {
    NSError *localError = [error copy];
    if (localError.code == SKErrorPaymentCancelled) {
        localError = [NSError boom_recharge_cancel];
    }
    
    if (self.callback) self.callback(localError.responseValue, localError);
    [JMBoomSDKBusiness.event uploadEvent:[JMBoomSDKEventItem event:JMBoomSDKEventId_Pay_Failed
                                               error:localError]];
}

- (CGFloat)Fibonacci:(NSInteger)n {
    if (n == 0) {
        return 1.0;
    } else if (n == 1) {
        return 1.0;
    } else if (n > 1) {
        return ([self Fibonacci:(n-1)]+ [self Fibonacci:(n-2)]);
    }
    return 0;
}

@end
