//
//  NSObject+JMProxy.h
//  TimerTest
//
//  Created by Thief Toki on 2021/2/3.
//

#import <Foundation/Foundation.h>

#import <JMUtils/JMWeakProxy.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (JMProxy)

- (JMWeakProxy *)weakProxy;

@end

NS_ASSUME_NONNULL_END
