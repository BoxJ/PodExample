//
//  JMBoomAntiAddictionBusinessMock.h
//  JMBoomAntiAddictionBusiness
//
//  Created by ZhengXianda on 11/02/2022.
//  Copyright (c) 2022 ZhengXianda. All rights reserved.
//

#import "JMBoomSDKBusiness.h"

NS_ASSUME_NONNULL_BEGIN

@protocol JMBoomAntiAddictionBusinessMock <NSObject>

@optional

- (void)checkRealNameOfLoginWithResponder:(JMResponder *)responder;
- (NSError *)errorWithloginOut;

@end

@interface JMBoomSDKBusiness (JMBoomAntiAddictionBusinessMock) <JMBoomAntiAddictionBusinessMock>

@end

NS_ASSUME_NONNULL_END
