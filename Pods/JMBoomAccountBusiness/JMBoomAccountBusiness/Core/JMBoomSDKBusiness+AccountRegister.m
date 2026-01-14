//
//  JMBoomSDKBusiness+AccountRegister.m
//  JMBoomSDK
//
//  Created by Thief Toki on 2021/2/4.
//

#import "JMBoomSDKBusiness+AccountRegister.h"

#import "JMBoomCLManager.h"

@implementation JMBoomSDKBusiness (AccountRegister)

- (void)registerCLManagerWithCallback:(JMBusinessCallback)callback {
    [[JMBoomCLManager shared] awakeWithEventCallback:callback];
}

@end
