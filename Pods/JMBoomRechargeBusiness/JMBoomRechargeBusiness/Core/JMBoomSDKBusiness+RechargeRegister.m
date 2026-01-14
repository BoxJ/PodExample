//
//  JMBoomSDKBusiness+RechargeRegister.m
//  JMBoomSDK
//
//  Created by Thief Toki on 2021/2/4.
//

#import "JMBoomSDKBusiness+RechargeRegister.h"

#import "JMBoomIAPManager.h"

@implementation JMBoomSDKBusiness (RechargeRegister)

- (void)registerIAPManagerWithCallback:(JMBusinessCallback)callback {
    [[JMBoomIAPManager shared] initIAPManagerWithCallback:callback];
}

@end
