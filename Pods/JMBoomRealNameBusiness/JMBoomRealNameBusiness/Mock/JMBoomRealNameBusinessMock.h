//
//  JMBoomRealNameBusinessMock.h
//  JMBoomRealNameBusiness
//
//  Created by ZhengXianda on 11/02/2022.
//  Copyright (c) 2022 ZhengXianda. All rights reserved.
//

#import "JMBoomSDKBusiness.h"

NS_ASSUME_NONNULL_BEGIN

@protocol JMBoomRealNameBusinessMock <NSObject>

@optional

- (void)showLoginBoundModalViewWithLock:(BOOL)isLock
                          hasRegisterCL:(BOOL)hasRegisterCL
                              responder:(JMResponder *)responder;
- (void)showBoundTipsModalViewWithLock:(BOOL)isLock responder:(JMResponder *)responder;

@end

@interface JMBoomSDKBusiness (JMBoomRealNameBusinessMock) <JMBoomRealNameBusinessMock>

@end

NS_ASSUME_NONNULL_END
