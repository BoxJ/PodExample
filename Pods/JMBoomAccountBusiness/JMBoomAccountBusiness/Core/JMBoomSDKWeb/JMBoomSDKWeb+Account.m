//
//  JMBoomSDKWeb+Account.m
//  JMBoomSDK
//
//  Created by Thief Toki on 2021/2/4.
//

#import "JMBoomSDKWeb+Account.h"

#define kJMBoomBridge_ChangePhone @"phoneChangeSuccess"
#define kJMBoomBridge_ChangeAccount @"accountChangeSuccess"
#define kJMBoomBridge_AccountClosing @"accuntClosingSuccess"
#define kJMBoomBridge_CloseWebPage @"closeWebPage"

@implementation JMBoomSDKWeb (Account)

- (instancetype)initChangePhoneWithVerifyCodeLength:(NSInteger)codeLength {
    NSString *page = [NSString stringWithFormat:@"%@/phoneChange1.html?len=%zd",
                      JMBoomSDKConfig.webBaseURL, codeLength];
    return [self webWithURL:[NSURL URLWithString:page]];
}

- (instancetype)initChangeAccountWithVerifyCodeLength:(NSInteger)codeLength {
    NSString *page = [NSString stringWithFormat:@"%@/accountChange1.html?len=%zd",
                      JMBoomSDKConfig.webBaseURL, codeLength];
    return [self webWithURL:[NSURL URLWithString:page]];
}

- (instancetype)initAccountClosingWithVerifyCodeLength:(NSInteger)codeLength waitingDays:(NSUInteger)waitingDays {
    NSString *page = [NSString stringWithFormat:@"%@/agreement.html?len=%zd&waitingDays=%zu",
                      JMBoomSDKConfig.webBaseURL, codeLength, waitingDays];
    return [self webWithURL:[NSURL URLWithString:page]];
}

- (void)setupBridge_Account {
    __weak typeof(self) weakSelf = self;
    [self registerHandler:kJMBoomBridge_ChangePhone
                  handler:^(NSDictionary * _Nonnull data,
                            void (^ _Nonnull responseCallback)(id _Nonnull)) {
        [weakSelf changePhoneSuccessed:data];
    }];
    [self registerHandler:kJMBoomBridge_ChangeAccount
                  handler:^(NSDictionary * _Nonnull data,
                            void (^ _Nonnull responseCallback)(id _Nonnull)) {
        [weakSelf changePhoneSuccessed:data];
    }];
    [self registerHandler:kJMBoomBridge_AccountClosing
                  handler:^(NSDictionary * _Nonnull data,
                            void (^ _Nonnull responseCallback)(id _Nonnull)) {
        [weakSelf accountClosingSuccessed:data];
    }];
    [self registerHandler:kJMBoomBridge_CloseWebPage
                  handler:^(NSDictionary * _Nonnull data,
                            void (^ _Nonnull responseCallback)(id _Nonnull)) {
        [weakSelf closeWebPage];
    }];
}

- (void)changePhoneSuccessed:(NSDictionary *)data {
    [self dismissSuccess:data];
}

- (void)accountClosingSuccessed:(NSDictionary *)data {
    [self dismissSuccess:data];
}

- (void)closeWebPage {
    [self dismissCancel];
}

@end
