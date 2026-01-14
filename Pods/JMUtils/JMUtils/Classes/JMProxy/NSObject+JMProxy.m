//
//  NSObject+JMProxy.m
//  TimerTest
//
//  Created by Thief Toki on 2021/2/3.
//

#import "NSObject+JMProxy.h"

@implementation NSObject (JMProxy)

- (JMWeakProxy *)weakProxy {
    return [JMWeakProxy proxyWithTarget:self];
}

@end
