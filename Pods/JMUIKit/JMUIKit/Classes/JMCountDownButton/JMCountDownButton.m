//
//  JMCountDownButton.m
//  JMUIKit
//
//  Created by Thief Toki on 2020/8/8.
//

#import "JMCountDownButton.h"

@interface JMCountDownButton ()

@property (nonatomic, assign) NSInteger currentTime;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation JMCountDownButton

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupUI];
        [self setupUIResponse];
    }
    return self;
}

#pragma mark - setup UI

- (void)setupUI {
    
}

#pragma mark - setup UI response

- (void)setupUIResponse {
    
}

#pragma mark - action

- (void)countDownBegin {
    self.currentTime = self.time;
    [self createTimer];
}

- (void)countDown {
    self.currentTime--;
    if (self.currentTime <= 0) {
        [self countDownEnd];
    }
}

- (void)countDownEnd {
    self.currentTime = -1;
    [self resetTimer];
}

#pragma mark - timer

- (void)createTimer {
    [self resetTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(countDown)
                                                userInfo:nil
                                                 repeats:YES];
    [self.timer fire];
}

- (void)resetTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark - protocol

- (void)removeFromSuperview {
    [super removeFromSuperview];
    [self countDownEnd];
}

#pragma mark - setter

- (void)setCurrentTime:(NSInteger)currentTime {
    if (_currentTime == currentTime) return;
    
    _currentTime = currentTime;
    
    if (_currentTime > 0) {
        self.userInteractionEnabled = NO;
        [self setTitle:[self.countDownTitle stringByAppendingFormat:@"(%zd)", _currentTime]
              forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1]
                   forState:UIControlStateNormal];
    } else {
        self.userInteractionEnabled = YES;
        [self setTitle:self.staticTitle
              forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithRed:96/255.0 green:116/255.0 blue:255/255.0 alpha:1]
                   forState:UIControlStateNormal];
    }
}

#pragma mark - getter

@end
