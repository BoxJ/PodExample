//
//  JMBoomSDKBusiness+AccountUILocalLogin.h
//  JMBoomAccountBusiness
//
//  Created by Thief Toki on 2021/3/30.
//

#import <JMBoomSDKBase/JMBoomSDKBase.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomSDKBusiness (AccountUILocalLogin)

- (void)showLocalLoginViewWithCallback:(JMBusinessCallback)callback;

@end

NS_ASSUME_NONNULL_END
