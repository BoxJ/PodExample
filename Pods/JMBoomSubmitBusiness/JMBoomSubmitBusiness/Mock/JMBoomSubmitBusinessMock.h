//
//  JMBoomSubmitBusinessMock.h
//  JMBoomSubmitBusiness
//
//  Created by ZhengXianda on 11/02/2022.
//  Copyright (c) 2022 ZhengXianda. All rights reserved.
//

#import "JMBoomSDKBusiness.h"

NS_ASSUME_NONNULL_BEGIN

@protocol JMBoomSubmitBusinessMock <NSObject>

@optional

@end

@interface JMBoomSDKBusiness (JMBoomSubmitBusinessMock) <JMBoomSubmitBusinessMock>

@end

NS_ASSUME_NONNULL_END
