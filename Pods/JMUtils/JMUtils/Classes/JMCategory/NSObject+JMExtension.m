//
//  NSObject+JMExtension.m
//  JMBoomSDK
//
//  Created by Thief Toki on 2021/1/28.
//

#import "NSObject+JMExtension.h"

#import <objc/runtime.h>

@implementation NSObject (JMExtension)

- (void)executeAllSelector:(SEL)targetSelector {
    unsigned int count;
    Method *methods = class_copyMethodList(self.class, &count);
    
    for (int i = 0; i < count; i++) {
        Method method = methods[i];
        SEL selector = method_getName(method);
        if ([NSStringFromSelector(selector) containsString:NSStringFromSelector(targetSelector)]) {
            IMP imp = method_getImplementation(method);
            void (*func)(id, SEL) = (void *)imp;
            func(self, selector);
        }
    }
}

@end
