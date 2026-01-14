//
//  JMBoomAccountBusinessMock.h
//  JMBoomAccountBusiness
//
//  Created by ZhengXianda on 11/02/2022.
//  Copyright (c) 2022 ZhengXianda. All rights reserved.
//

#import "JMBoomSDKBusiness.h"

NS_ASSUME_NONNULL_BEGIN

@protocol JMBoomAccountBusinessMock <NSObject>

@optional

- (void)checkRealNameStatusWithResponder:(JMResponder *)responder;
- (void)checkRealNameOfLoginWithResponder:(JMResponder *)responder;
- (void)checkRealNameStatusConfirmWithResponder:(JMResponder *)responder;
- (void)checkAntiAddiction:(JMResponder *)responder;
- (void)showRealNameAuthenticationViewWithLock:(BOOL)isLock responder:(JMResponder *)responder;
- (void)antiAddictionRemainWithCallback:(JMBusinessCallback)callback;
- (void)antiAddictionCountingWithCallback:(JMBusinessCallback)callback;
- (void)antiAddictionCountingPause;
- (BOOL)errorIsAntiAddiction:(NSError *)error;

@end

@interface JMBoomSDKBusiness (JMBoomAccountBusinessMock) <JMBoomAccountBusinessMock>

@end

NS_ASSUME_NONNULL_END
