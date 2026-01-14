//
//  JMBoomSDKRequest+JMBoomRealNameBusiness.h
//  JMBoomRealNameBusiness
//
//  Created by ZhengXianda on 11/02/2022.
//  Copyright (c) 2022 ZhengXianda. All rights reserved.
//

#import <JMBoomSDKBase/JMBoomSDKBase.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomSDKRequest (JMBoomRealNameBusiness)

- (void)identityStatusWithCallback:(JMBusinessCallback)callback;

- (void)identityVerifyWithIdCardNumber:(NSString *)idCardNumber
                              realName:(NSString *)realName
                              callback:(JMBusinessCallback)callback;

@end

NS_ASSUME_NONNULL_END
