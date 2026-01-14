//
//  JMPulse.m
//  TimerTest
//
//  Created by Thief Toki on 2021/2/2.
//

#import "JMPulse.h"

#import "NSObject+JMProxy.h"

@interface JMPulse ()

@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign) NSUInteger count;

@property (nonatomic, strong) JMPulseBeatResonance resonance;

@end

@implementation JMPulse

- (void)beatWithInterval:(NSUInteger)interval resonance:(JMPulseBeatResonance)resonance {
    self.count = 0;
    self.resonance = resonance;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:MAX(1, interval)
                                                  target:self.weakProxy
                                                selector:@selector(beatResonance)
                                                userInfo:nil
                                                 repeats:YES];
    
    [self.timer setFireDate:[NSDate distantPast]];
}

- (void)shock {
    if (self.timer) {
        [self.timer setFireDate:[NSDate distantFuture]];
    }
}

- (void)clear {
    self.count = 0;
}

- (void)beatResonance {
    self.count ++;
    
    if (self.resonance) {
        self.resonance(self.count);
    }
}

@end
