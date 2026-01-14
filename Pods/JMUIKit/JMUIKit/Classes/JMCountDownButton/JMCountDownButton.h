//
//  JMCountDownButton.h
//  JMUIKit
//
//  Created by Thief Toki on 2020/8/8.
//

#import <JMUIKit/JMCrispButton.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMCountDownButton : JMCrispButton

@property (nonatomic, assign) NSInteger time;

@property (nonatomic, strong) NSString *staticTitle;
@property (nonatomic, strong) NSString *countDownTitle;

- (void)countDownBegin;
- (void)countDownEnd;

@end

NS_ASSUME_NONNULL_END
