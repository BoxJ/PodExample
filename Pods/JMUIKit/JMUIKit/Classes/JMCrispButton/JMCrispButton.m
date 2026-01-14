//
//  JMCrispButton.m
//  JMUIKit
//
//  Created by Thief Toki on 2021/2/8.
//

#import "JMCrispButton.h"

@interface JMCrispButton ()

@property (nonatomic, assign) NSTimeInterval crispTime;

@end

@implementation JMCrispButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.repairTimeInterval = 0.5;
    }
    return self;
}

- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if ([NSDate date].timeIntervalSince1970 - self.crispTime > self.repairTimeInterval) {
        self.crispTime = [NSDate date].timeIntervalSince1970;
        
        [super sendAction:action to:target forEvent:event];
    }
}

@end
