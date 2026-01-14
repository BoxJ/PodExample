//
//  NSObject+JMExtension.h
//  JMBoomSDK
//
//  Created by Thief Toki on 2021/1/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (JMExtension)

/// 同步调用所有同名方法
/// @param targetSelector 欲调用的方法
- (void)executeAllSelector:(SEL)targetSelector;

@end

NS_ASSUME_NONNULL_END
