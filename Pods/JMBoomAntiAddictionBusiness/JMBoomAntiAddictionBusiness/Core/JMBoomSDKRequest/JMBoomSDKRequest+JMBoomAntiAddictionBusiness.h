//
//  JMBoomSDKRequest+JMBoomAntiAddictionBusiness.h
//  JMBoomAntiAddictionBusiness
//
//  Created by ZhengXianda on 11/02/2022.
//  Copyright (c) 2022 ZhengXianda. All rights reserved.
//

#import <JMBoomSDKBase/JMBoomSDKBase.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomSDKRequest (JMBoomAntiAddictionBusiness)

- (void)antiAddictionActiveWithCount:(NSInteger)count
                            interval:(NSTimeInterval)interval
                            callback:(JMBusinessCallback)callback;

- (void)antiAddictionRemainWithCallback:(JMBusinessCallback)callback;

@end

NS_ASSUME_NONNULL_END
