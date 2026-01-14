//
//  JMBoomSDKBusiness.m
//  JMBoomSDK
//
//  Created by ZhengXianda on 10/31/2022.
//  Copyright (c) 2022 ZhengXianda. All rights reserved.
//

#import "JMBoomSDKBusiness.h"

@implementation JMBoomSDKBusiness

#pragma mark - shared

+ (JMBoomSDKBusiness *)shared {
    static JMBoomSDKBusiness * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+ (JMBoomSDKConfig *)config{
    return [JMBoomSDKConfig shared];
}

+ (JMBoomSDKInfo *)info{
    return [JMBoomSDKInfo shared];
}

+ (JMBoomSDKRequest *)request {
    return [JMBoomSDKRequest shared];
}

+ (JMBoomSDKWeb *)web {
    return [[JMBoomSDKWeb alloc] init];
}

+ (JMBoomSDKQiniu *)qiniu {
    return [[JMBoomSDKQiniu alloc] init];
}

+ (JMBoomSDKEvent *)event{
    return [JMBoomSDKEvent shared];
}

+ (JMQiYuCustomer *)qiYuCustomer
{
    return [JMQiYuCustomer shared];
}
+ (JMBoomSDKRisk *)risk {
    return [JMBoomSDKRisk shared];
}
@end
