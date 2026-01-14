//
//  JMBusiness.m
//  JMBusiness
//
//  Created by ZhengXianda on 11/03/2022.
//  Copyright (c) 2022 ZhengXianda. All rights reserved.
//

#import "JMBusiness.h"

#import <objc/runtime.h>

@implementation JMBusiness

#pragma mark - shared

+ (JMBusiness *)shared {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - Unrecognized

- (NSMethodSignature*)methodSignatureForSelector:(SEL)selector {
    return [super methodSignatureForSelector:selector] ?: self.voidSignature;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    if (![invocation.methodSignature isEqual:self.voidSignature]) {
        [super forwardInvocation:invocation];
    }
}

#pragma mark - util

- (NSMethodSignature *)voidSignature {
    return [self methodSignatureForSelector:@selector(unrecognizedSelectorBackUp)];
}

- (void)unrecognizedSelectorBackUp {
    
}

@end
