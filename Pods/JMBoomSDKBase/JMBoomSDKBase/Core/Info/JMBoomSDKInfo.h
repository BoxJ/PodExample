//
//  JMBoomSDKInfo.h
//  JMBoomSDK
//
//  Created by ZhengXianda on 10/31/2022.
//  Copyright (c) 2022 ZhengXianda. All rights reserved.
//

#import <JMRktInfo/JMRktInfo.h>

typedef NS_ENUM(NSUInteger, JMBoomRegisterType) {
    JMBoomRegisterType_Phone,
    JMBoomRegisterType_Guest,
};

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomSDKInfo: JMRktInfo

///登录token
@property (nonatomic, strong) NSString *token;
///用户识别Id
@property (nonatomic, strong) NSString *openId;
///用户是否刚刚注册
@property (nonatomic, assign) BOOL isRegister;
///用户昵称
@property (nonatomic, strong) NSString *nickname;
///用户注册类型
@property (nonatomic, assign) JMBoomRegisterType registerType;
///用户通过登录行为取消注销流程
@property (nonatomic, assign) BOOL cancelClosing;

- (void)resetLoginInfo;

#pragma mark - extract

- (void)extractLoginResponseObject:(NSDictionary *)responseObject;

- (void)extractUniqueIdCheckResponseObject:(NSDictionary *)responseObject;

- (void)extractUserInfoResponseObject:(NSDictionary *)responseObject;

@end

NS_ASSUME_NONNULL_END
