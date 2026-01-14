//
//  JMNetworkConsuming.h
//  JMNetworking
//
//  Created by ZhengXianda on 4/1/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMNetworkConsuming : NSObject

+ (NSTimeInterval)check4:(NSString *)ip;
+ (NSTimeInterval)check6:(NSString *)ip;

@end

NS_ASSUME_NONNULL_END
