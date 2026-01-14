//
//  NSThread+JMExtension.h
//  JMUtils
//
//  Created by ZhengXianda on 2021/12/21.
//

#import <Foundation/Foundation.h>

#import <JMUtils/JMThreadInfo.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSThread (JMExtension)

- (JMThreadInfo *)info;

@end

NS_ASSUME_NONNULL_END
