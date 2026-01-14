//
//  JMBoomSDKBusiness+JMBoomSubmitBusinessUI.h
//  JMBoomSubmitBusiness
//
//  Created by ZhengXianda on 11/02/2022.
//  Copyright (c) 2022 ZhengXianda. All rights reserved.
//

#import <JMBoomSDKBase/JMBoomSDKBase.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomSDKBusiness (JMBoomSubmitBusinessUI)

- (void)showSubmitWithHistoryStatus:(BOOL)hasHistory callback:(JMBusinessCallback)callback;

@end

NS_ASSUME_NONNULL_END
