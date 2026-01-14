//
//  JMBoomSDKBusiness+AccountLogin.m
//  JMBoomSDK
//
//  Created by Thief Toki on 2021/2/5.
//

#import "JMBoomSDKBusiness+AccountLogin.h"

#import "JMBoomAccountBusiness.h"
#import "JMBoomAccountBusinessMock.h"

@interface JMBoomSDKBusinessAccountLoginProperty : NSObject

@property (nonatomic, strong) JMBusinessCallback callback;

@end

@implementation JMBoomSDKBusinessAccountLoginProperty

#pragma mark - shared

+ (instancetype)shared {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

@end

@implementation JMBoomSDKBusiness (AccountLogin)

- (void)guestLoginWithAntiAddictionCallback:(JMBusinessCallback)callback {
    [JMBoomSDKBusinessAccountLoginProperty shared].callback = callback;
    __weak typeof(self) weakSelf = self;
    [[JMBoomSDKBusiness shared] guestLoginWithCallback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        [weakSelf loginCompleted:responseObject error:error];
    }];
}

- (void)quickLoginWithAntiAddictionCallback:(JMBusinessCallback)callback {
    [JMBoomSDKBusinessAccountLoginProperty shared].callback = callback;
    __weak typeof(self) weakSelf = self;
    [[JMBoomSDKBusiness shared] quickLoginWithCallback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        [weakSelf loginCompleted:responseObject error:error];
    }];
}

- (void)loginWithAntiAddictionCallback:(JMBusinessCallback)callback {
    [JMBoomSDKBusinessAccountLoginProperty shared].callback = callback;
    __weak typeof(self) weakSelf = self;
    [[JMBoomSDKBusiness shared] loginWithCallback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        [weakSelf loginCompleted:responseObject error:error];
    }];
}

- (void)phoneLoginWithPhoneNumber:(NSString *)phoneNumber
                 verificationCode:(NSString *)verificationCode
            antiAddictionCallback:(JMBusinessCallback)callback {
    [JMBoomSDKBusinessAccountLoginProperty shared].callback = callback;
    __weak typeof(self) weakSelf = self;
    [[JMBoomSDKBusiness shared] phoneLoginWithPhoneNumber:phoneNumber
                                         verificationCode:verificationCode
                                                 callback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        [weakSelf loginCompleted:responseObject error:error];
    }];
}

#pragma mark - util

- (void)loginCompleted:(NSDictionary *)response error:(NSError *)error {
    if ([JMBoomSDKBusinessAccountLoginProperty shared].callback) {
        if (error) {
            //登录报错，返回错误内容
            [JMBoomSDKBusinessAccountLoginProperty shared].callback(error.responseValue, error);
        } else {
            __weak typeof(self) weakSelf = self;
            //登录成功，请求防沉迷剩余时间
            [[JMBoomSDKBusiness shared] antiAddictionRemainWithCallback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
                if (error && ![weakSelf errorIsAntiAddiction:error]) {
                    //请求防沉迷剩余时间报错，返回错误内容
                    [JMBoomSDKBusinessAccountLoginProperty shared].callback(error.responseValue, error);
                } else {
                    //请求防沉迷剩余时间成功，返回登录信息
                    [JMBoomSDKBusinessAccountLoginProperty shared].callback(response, nil);
                }
            }];
        }
    }
}


@end
