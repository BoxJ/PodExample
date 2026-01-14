//
//  JMBoomInitializeBusinessMock.h
//  JMBoomInitializeBusiness
//
//  Created by ZhengXianda on 11/2/22.
//

#import "JMBoomSDKBusiness.h"

NS_ASSUME_NONNULL_BEGIN

@protocol JMBoomInitializeBusinessMock <NSObject>

@optional

- (void)antiAddictionCountingPause;
- (void)registerCLManagerWithCallback:(JMBusinessCallback)callback;
- (void)registerIAPManagerWithCallback:(JMBusinessCallback)callback;

@end

@interface JMBoomSDKBusiness (JMBoomInitializeBusinessMock) <JMBoomInitializeBusinessMock>

@end

NS_ASSUME_NONNULL_END
