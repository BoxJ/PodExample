//
//  JMBoomSDKBusiness+JMBoomAntiAddictionBusiness.m
//  JMBoomSDK
//
//  Created by Thief Toki on 2021/2/4.
//

#import "JMBoomSDKBusiness+JMBoomAntiAddictionBusiness.h"

#import "JMBoomAntiAddictionPulse.h"

#import "JMBoomSDKRequest+JMBoomAntiAddictionBusiness.h"

@implementation JMBoomSDKBusiness (JMBoomAntiAddictionBusiness)

- (void)antiAddictionRemainWithCallback:(JMBusinessCallback)callback {
    [JMBoomSDKBusiness.request antiAddictionRemainWithCallback:callback];
}

- (void)antiAddictionCountingWithCallback:(JMBusinessCallback)callback {
    [[JMBoomAntiAddictionPulse shared] beatWithCallback:callback];
}

- (void)antiAddictionCountingPause {
    [[JMBoomAntiAddictionPulse shared] shock];
}

@end
