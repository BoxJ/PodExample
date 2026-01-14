//
//  JMWeakProxy.m
//  TimerTest
//
//  Created by Thief Toki on 2021/2/2.
//

#import "JMWeakProxy.h"

@implementation JMWeakProxy

+ (instancetype)proxyWithTarget:(id)target {
    return [[self alloc] initWithTarget:target];
}

- (instancetype)initWithTarget:(id)target {
    _target = target;
    return self;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    NSAssert(self.target, @"当前对象已失效");
    return [self.target methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    if([self.target respondsToSelector:[invocation selector]]){
        [invocation invokeWithTarget:self.target];
    }
}

@end
