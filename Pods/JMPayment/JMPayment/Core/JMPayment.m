//
//  JMPayment.m
//  JMPayment
//
//  Created by xianda.zheng on 02/18/2021.
//  Copyright (c) 2021 xianda.zheng. All rights reserved.
//

#import "JMPayment.h"

#import <JMUtils/JMLogger.h>

@interface JMPayment () <SKPaymentTransactionObserver, SKProductsRequestDelegate>

@property (nonatomic, strong) NSMutableDictionary<NSString *, JMPaymentProductsCallback> *productsCallbackMap;

@end

@implementation JMPayment

#pragma mark - shared

+ (instancetype)shared {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.completeTrans = [[NSMutableArray alloc] init];
        self.failedTrans = [[NSMutableArray alloc] init];
        self.restoreTrans = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)startWithDelegate:(id<JMPaymentServerNoticeDelegate>)delegate {
    self.delegate = delegate;
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

- (void)queryProductInfo:(NSString *)productIdentifier callback:(JMPaymentProductsCallback)callback {
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithArray:@[productIdentifier]]];
    
    NSString *identifer = [NSString stringWithFormat:@"%@", productsRequest];
    self.productsCallbackMap[identifer] = callback;
    
    productsRequest.delegate = self;
    [productsRequest start];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.queryProductInfoTimeout * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self productsRequest:productsRequest didReceiveResponse:[[SKProductsResponse alloc] init]];
    });
}

- (void)addPayment:(NSString *)productIdentifier orderNumber:(NSString *)orderNumber {
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
    SKMutablePayment *payment = [SKMutablePayment paymentWithProductIdentifier:productIdentifier];
    #pragma clang diagnostic pop
    payment.applicationUsername = orderNumber;
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma mark - NSNotificationCenter Methods

- (void)contineuUnFinishedTransactions {
    for (SKPaymentTransaction *transaction in [[SKPaymentQueue defaultQueue] transactions]) {
        NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
        if (receiptURL && [[NSFileManager defaultManager] fileExistsAtPath:[receiptURL path]]) {
            [self _notiServerWithCompleteTransaction:transaction restore:NO];
        }
    }
}

- (void)_notiServerWithCompleteTransaction:(SKPaymentTransaction *)trans restore:(BOOL)isRestore {
    NSString *proIdentifier = trans.payment.productIdentifier;
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    NSString *receiptString = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    if (!proIdentifier || [proIdentifier isEqual:@""] || !(receiptString && receiptString.length != 0)) {
        if (!isRestore) [[SKPaymentQueue defaultQueue] finishTransaction:trans];
    } else {
        NSAssert(self.delegate, @"serverNoticeDelegate 不可为空");
        [self.delegate transactionDidCompleted:receiptString
                           applicationUserName:trans.payment.applicationUsername
                                 transactionId:trans.transactionIdentifier
                                    serverResp:^(id resp, NSError *error) {
            if (!error) {
                if (!isRestore) [[SKPaymentQueue defaultQueue] finishTransaction: trans];
            } else {
                if (!isRestore && error.code >= 0) [[SKPaymentQueue defaultQueue] finishTransaction: trans];
            }
        }];
    }
}

- (void)_notiServerWithFailedTransaction:(SKPaymentTransaction *)trans {
    NSError *error = trans.error;
    NSAssert(self.delegate, @"serverNoticeDelegate 不可为空");
    [self.delegate transactionDidFailed:error];
    [[SKPaymentQueue defaultQueue] finishTransaction:trans];
}

#pragma mark - Protocol

#pragma mark SKPaymentTransactionObserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchasing: {
                JMLog(@"IAP 正在采购 | 商品Id:%@, 订单号:%@",transaction.payment.productIdentifier,transaction.payment.applicationUsername);
            }
                break;
            case SKPaymentTransactionStatePurchased: {
                JMLog(@"IAP 充值成功 | 商品Id:%@, 订单号:%@",transaction.payment.productIdentifier,transaction.payment.applicationUsername);
                [self completeTransaction:transaction];
            }
                break;
            case SKPaymentTransactionStateFailed: {
                JMLog(@"IAP 充值失败");
                [self failedTransaction:transaction];
            }
                break;
            case SKPaymentTransactionStateRestored: {
                JMLog(@"IAP 恢复内购");
                [self restoreTransaction:transaction];
            }
                break;
            case SKPaymentTransactionStateDeferred: {
                JMLog(@"IAP 采购延时");
            }
                break;
            default:
                break;
        }
    }
}

- (void)completeTransaction: (SKPaymentTransaction *)transaction {
    [self.completeTrans addObject:transaction];
    
    [self _notiServerWithCompleteTransaction:transaction restore:NO];
}

- (void)restoreTransaction: (SKPaymentTransaction *)transaction {
    [self.restoreTrans addObject:transaction];
    
    [self _notiServerWithCompleteTransaction:transaction restore:YES];
}

- (void)failedTransaction: (SKPaymentTransaction *)transaction {
    [self.failedTrans addObject:transaction];
    
    [self _notiServerWithFailedTransaction:transaction];
}

#pragma mark SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest*)request didReceiveResponse:(SKProductsResponse*)response {
    NSString *identifer = [NSString stringWithFormat:@"%@", request];
    JMPaymentProductsCallback callback;
    if ((callback = self.productsCallbackMap[identifer])) {
        callback(response);
        [self.productsCallbackMap removeObjectForKey:identifer];
    }
}

#pragma mark - getter

- (NSTimeInterval)queryProductInfoTimeout {
    if (_queryProductInfoTimeout <= 1) {
        _queryProductInfoTimeout = 20;
    }
    return _queryProductInfoTimeout;
}

- (NSMutableDictionary<NSString *,JMPaymentProductsCallback> *)productsCallbackMap {
    if (!_productsCallbackMap) {
        _productsCallbackMap = [NSMutableDictionary dictionary];
    }
    return _productsCallbackMap;
}

@end
