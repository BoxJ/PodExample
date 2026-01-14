//
//  JMBoomSDKInfo.m
//  JMBoomSDK
//
//  Created by ZhengXianda on 10/31/2022.
//  Copyright (c) 2022 ZhengXianda. All rights reserved.
//

#import "JMBoomSDKInfo.h"

#define kJMBoomSDKInfoTokenKey @"kJMBoomSDKInfoTokenKey"
#define kJMBoomSDKInfoNicknameKey @"kJMBoomSDKInfoNicknameKey"

@implementation JMBoomSDKInfo

@synthesize token = _token;
@synthesize nickname = _nickname;

#pragma mark - 扩展数据 App Extend Info

- (void)loadExtendInfo {
    self.token = self.token ?: @"";
    self.nickname = self.nickname ?: @"";
}

- (void)clearExtendInfo {
    self.token = @"";
    self.nickname = @"";
}

- (void)resetLoginInfo {
    self.openId = @"";
    self.isRegister = NO;
}

#pragma mark - extract

- (void)extractLoginResponseObject:(NSDictionary *)responseObject {
    NSDictionary *result = responseObject[@"result"];
    if ([result isKindOfClass:[NSDictionary class]]) {
        self.token = result[@"token"]?:@"";
        self.openId = result[@"openId"]?:@"";
        self.isRegister = [result[@"register"]?:@(NO) boolValue];
        self.cancelClosing = [result[@"cancelLogout"]?:@(NO) boolValue];
    }
}

- (void)extractUniqueIdCheckResponseObject:(NSDictionary *)responseObject {
    if ([responseObject[@"result"]?:@(NO) boolValue]) {
        
    } else {
        [[JMBoomSDKInfo shared] CreateNewUniqueId];
    }
}

- (void)extractUserInfoResponseObject:(NSDictionary *)responseObject {
    NSDictionary *result = responseObject[@"result"];
    if ([result isKindOfClass:[NSDictionary class]]) {
        self.nickname = result[@"nickName"]?:@"";
        self.registerType = (JMBoomRegisterType)[result[@"registerType"]?:@(JMBoomRegisterType_Phone) integerValue];
    }
}

#pragma mark setter

- (void)setToken:(NSString *)token {
    _token = token;
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:kJMBoomSDKInfoTokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setNickname:(NSString *)nickname {
    _nickname = nickname;
    [[NSUserDefaults standardUserDefaults] setObject:nickname forKey:kJMBoomSDKInfoNicknameKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark getter

- (NSString *)token {
    if (!_token) {
        _token = [[NSUserDefaults standardUserDefaults] objectForKey:kJMBoomSDKInfoTokenKey];
    }
    return _token;
}

- (NSString *)nickname {
    if (!_nickname) {
        _nickname = [[NSUserDefaults standardUserDefaults] objectForKey:kJMBoomSDKInfoNicknameKey];
    }
    return _nickname;
}

@end
