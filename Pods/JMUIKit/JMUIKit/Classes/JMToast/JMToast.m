//
//  JMToast.m
//  JMUIKit
//
//  Created by ZhengXianda on 10/19/22.
//

#import "JMToast.h"

#import "JMToastView.h"
#import "JMToastLoadingView.h"
#import "JMToastSuccessView.h"

@interface JMToast ()

@property (nonatomic, strong) JMToastView *toast;

@end

@implementation JMToast

#pragma mark - shared

+ (instancetype)shared {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - Toast

+ (void)showToast:(NSString *)message {
    [JMToast showToast:message duartion:1];
}

+ (void)showToast:(NSString *)message duartion:(NSTimeInterval)time {
    [JMToast dismissToast];
    [JMToast shared].toast = [[JMToastView alloc] init];
    [[JMToast shared].toast showToast:message];
    [[JMToast shared].toast dismissDelay:time];
}

+ (void)showToastSuccess:(NSString *)message {
    [JMToast showToastSuccess:message duartion:1];
}

+ (void)showToastSuccess:(NSString *)message duartion:(NSTimeInterval)time {
    [JMToast dismissToast];
    [JMToast shared].toast = [[JMToastSuccessView alloc] init];
    [[JMToast shared].toast showToast:message];
    [[JMToast shared].toast dismissDelay:time];
}

+ (void)showToastLoading {
    [JMToast dismissToast];
    [JMToast shared].toast = [[JMToastLoadingView alloc] init];
    [[JMToast shared].toast showToast:@""];
}

+ (void)showToastLoadingDuartion:(NSTimeInterval)time {
    [self showToastLoading];
    [[JMToast shared].toast dismissDelay:time];
}

+ (void)dismissToast {
    if ([JMToast shared].toast) {
        [[JMToast shared].toast dismiss];
    }
}

+ (void)dismissToastDelay:(NSTimeInterval)time {
    if ([JMToast shared].toast) {
        [[JMToast shared].toast dismissDelay:time];
    }
}


@end
