//
//  JMBoomRechargeBusinessMock.h
//  JMBoomRechargeBusiness
//
//  Created by ZhengXianda on 11/02/2022.
//  Copyright (c) 2022 ZhengXianda. All rights reserved.
//

#import "JMBoomSDKBusiness.h"

NS_ASSUME_NONNULL_BEGIN

@protocol JMBoomRechargeBusinessMock <NSObject>

@optional

- (void)checkRealNameStatusWithResponder:(JMResponder *)responder;
- (void)showRealNameAuthenticationViewWithLock:(BOOL)isLock responder:(JMResponder *)responder;
- (void)showBoundTipsModalViewWithResponder:(JMResponder *)responder;
- (void)showRechargeBoundModalViewWithLock:(BOOL)isLock
                             hasRegisterCL:(BOOL)hasRegisterCL
                                 responder:(JMResponder *)responder;

@end

@interface JMBoomSDKBusiness (JMBoomRechargeBusinessMock) <JMBoomRechargeBusinessMock>

@end

NS_ASSUME_NONNULL_END
