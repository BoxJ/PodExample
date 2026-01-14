//
//  JMBoomCLManager.h
//  JMBoomSDK
//
//  Created by Thief Toki on 2020/8/6.
//

#import <JMCLManager/JMCLManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomCLManager : JMCLManager

- (void)awakeWithEventCallback:(JMCLCallback)callback;
- (void)getPhoneNumberWithEventCallback:(JMCLCallback)callback;
- (void)loginAuthWithEventCallback:(JMCLCallback)callback;

@end

NS_ASSUME_NONNULL_END
