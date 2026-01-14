//
//  JMPulse.h
//  TimerTest
//
//  Created by Thief Toki on 2021/2/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^JMPulseBeatResonance)(NSUInteger beatCount);

@interface JMPulse : NSObject

/// 启动，跳动
/// @param interval 间隔 单位为秒，最小为1秒
/// @param resonance 事件
- (void)beatWithInterval:(NSUInteger)interval resonance:(JMPulseBeatResonance)resonance;

/// 暂停，休克
- (void)shock;

/// 清空脉搏计数
- (void)clear;

@end

NS_ASSUME_NONNULL_END
