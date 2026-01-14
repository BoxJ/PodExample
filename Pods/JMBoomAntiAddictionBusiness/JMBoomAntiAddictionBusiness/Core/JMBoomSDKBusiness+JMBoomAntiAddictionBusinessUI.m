//
//  JMBoomSDKBusiness+JMBoomAntiAddictionBusinessUI.m
//  JMBoomSDK
//
//  Created by Thief Toki on 2021/2/5.
//

#import "JMBoomSDKBusiness+JMBoomAntiAddictionBusinessUI.h"

#import <JMRktCommon/JMRktCommon.h>

#import "JMBoomAntiAddictionBusiness.h"
#import "JMBoomAntiAddictionBusinessMock.h"

@interface JMBoomAntiAddictionBusinessUIProperty : NSObject

@property (nonatomic, strong) JMResponder *responder;
@property (nonatomic, strong) NSError *error;

@end

@implementation JMBoomAntiAddictionBusinessUIProperty

+ (instancetype)shared {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

@end

@implementation JMBoomSDKBusiness (JMBoomAntiAddictionBusinessUI)

- (void)checkAntiAddiction:(JMResponder *)responder {
    //执行防沉迷检查
    [[JMBoomSDKBusiness shared] antiAddictionRemainWithCallback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            if ([self errorIsAntiAddiction:error]) {
                //报错类型为防沉迷相关
                [JMBoomAntiAddictionBusinessUIProperty shared].responder = responder;
                [JMBoomAntiAddictionBusinessUIProperty shared].error = error;
                [self checkAntiAddiction_tips];
            } else {
                //其他报错
                responder.failed(error);
            }
        } else {
            //通过防沉迷检查
            responder.success(@{});
        }
    }];
}

- (void)checkAntiAddiction_tips {
//    40001        未实名用户的剩余时长提醒（登录）
//    40002        未实名用户的剩余时长结束提醒（登录）
//    40003        未实名用户的剩余时长结束提醒（游戏中）
//    40004        未满18岁用户的剩余时长提醒（登录）
//    40005        游戏时间在非宵禁时间提示（登录）
//    40006        工作日未满18岁时长结束提醒（登录）
//    40007        节假日未满18岁时长结束提醒（登录）
//    40015        游戏时间在非宵禁时间提示（游戏中）
//    40016        工作日未满18岁时长结束提醒（游戏中）
//    40017        节假日未满18岁时长结束提醒（游戏中）
    switch ([JMBoomAntiAddictionBusinessUIProperty shared].error.code) {
        case 40001: {
            [self checkAntiAddiction_notRealNameTimeTips];
        }
            break;
        case 40002:{
            [self checkAntiAddiction_notRealNameTimeOver];
        }
            break;
        case 40003:
        case 40015:
        case 40016:
        case 40017: {
            [self checkAntiAddiction_gamingTimeOver];
        }
            break;
        case 40004: {
            [self checkAntiAddiction_realNameTimeTips];
        }
            break;
        case 40005:
        case 40006:
        case 40007: {
            [self checkAntiAddiction_realNameTimeOver];
        }
        default: {
            
        }
            break;
    }
}

- (void)checkAntiAddiction_notRealNameTimeTips {
    //未实名用户，登录时提示防沉迷时间
    [self checkAntiAddiction_notRealNameWithResponder:[JMResponder cancel:^{
        //取消，未前往实名认证, 登录成功
        [JMBoomAntiAddictionBusinessUIProperty shared].responder.success(@{});
    }]];
}

- (void)checkAntiAddiction_notRealNameTimeOver {
    //未实名用户，登录时触发防沉迷限制
    [self checkAntiAddiction_notRealNameWithResponder:[JMResponder cancel:^{
        //实名认证取消,重新登录
        [JMBoomAntiAddictionBusinessUIProperty shared].responder.failed([JMBoomAntiAddictionBusinessUIProperty shared].error);
    }]];
}

- (void)checkAntiAddiction_notRealNameWithResponder:(JMResponder *)responder {
    //未实名用户，登录时触发防沉迷
    [JMRktDialog showError:[JMBoomAntiAddictionBusinessUIProperty shared].error responder:[JMResponder success:^(NSDictionary *info) {
        [[JMBoomSDKBusiness shared] checkRealNameOfLoginWithResponder:[JMResponder success:^(NSDictionary *info) {
            //实名认证成功再次检查游戏时间
            [self checkAntiAddiction:[JMBoomAntiAddictionBusinessUIProperty shared].responder];
        } cancel:^{
            //实名认证取消
            responder.cancel();
        }]];
    } cancel:^{
        //实名认证取消
        responder.cancel();
    }]];
}

- (void)checkAntiAddiction_gamingTimeOver {
    //游戏中，时间限制触发，点击确认后提示cp端退出游戏
    [JMRktDialog showError:[JMBoomAntiAddictionBusinessUIProperty shared].error responder:[JMResponder success:^(NSDictionary *info) {
        [[JMRktBroadcaster shared] sendError:[NSError boom_login_out]];
    }]];
}

- (void)checkAntiAddiction_realNameTimeTips {
    //实名用户，登录时提示剩余时间
    [JMRktDialog showError:[JMBoomAntiAddictionBusinessUIProperty shared].error responder:[JMResponder success:^(NSDictionary *info) {
        [JMBoomAntiAddictionBusinessUIProperty shared].responder.success(@{});
    }]];
}

- (void)checkAntiAddiction_realNameTimeOver {
    //实名用户，登录时触发防沉迷限制，登录终止
    [JMRktDialog showError:[JMBoomAntiAddictionBusinessUIProperty shared].error responder:[JMResponder success:^(NSDictionary *info) {
        [JMBoomAntiAddictionBusinessUIProperty shared].responder.failed([JMBoomAntiAddictionBusinessUIProperty shared].error);
    }]];
}


@end
