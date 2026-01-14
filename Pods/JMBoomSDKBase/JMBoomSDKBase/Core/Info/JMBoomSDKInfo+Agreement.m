//
//  JMBoomSDKInfo+Agreement.m
//  JMBoomSDK
//
//  Created by ZhengXianda on 11/2/22.
//

#import "JMBoomSDKInfo+Agreement.h"

#import <JMUtils/JMUtils.h>

#import "JMBoomSDKEvent.h"

#define kJMBoomSDKAgreementContentKey @"kJMBoomSDKAgreementContentKey"
#define kJMBoomSDKAgreementVersionKey @"kJMBoomSDKAgreementVersionKey"
#define kJMBoomSDKAgreementLinksKey @"kJMBoomSDKAgreementLinksKey"
#define kJMBoomSDKAgreementFinishedKey @"kJMBoomSDKAgreementFinishedKey"
#define kJMBoomSDKAgreementThroughKey @"kJMBoomSDKAgreementThroughKey"

@implementation JMBoomSDKInfo (Agreement)

#pragma mark - AgreementContent

- (void)localAgreementContent:(NSString *)content {
    [[NSUserDefaults standardUserDefaults] setObject:content forKey:kJMBoomSDKAgreementContentKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)localAgreementContent {
    NSString *agreementContent = [[NSUserDefaults standardUserDefaults] objectForKey:kJMBoomSDKAgreementContentKey] ?: @"";
    agreementContent = agreementContent.length > 0 ? agreementContent : @"\
<span style=\"color:#333333;font-size:14px;font-weight:lighter;margin:0px\">\
娱公互动非常重视您的隐私和个人信息的保护。在您使用应用前请先认真阅读\
<a style=\"color:#00BCFF;text-decoration:none\" href=\"https://caniculab.com/game/eula.html\">《服务协议》</a>及\
<a style=\"color:#00BCFF;text-decoration:none\" href=\"https://caniculab.com/game/privacy.html\">《隐私政策》</a>并同意全部条款。\
</span>";
    return agreementContent;
}

- (void)localAgreementVersion:(NSString *)version {
    [[NSUserDefaults standardUserDefaults] setObject:version forKey:kJMBoomSDKAgreementVersionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)localAgreementVersion {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kJMBoomSDKAgreementVersionKey] ?: @"";
}

- (void)localAgreementLinks:(NSArray *)links {
    [[NSUserDefaults standardUserDefaults] setObject:links forKey:kJMBoomSDKAgreementLinksKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray *)localAgreementLinks {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kJMBoomSDKAgreementLinksKey] ?: @[];
}

#pragma mark -

- (void)updateLocalAgreement:(NSString *)version content:(NSString *)content {
    //判断版本号，若存在记录的版本号且与服务器不同，则将协议确认标识位改为NO（将在下次启动App时弹出用户协议确认框）
    NSString *localVersion = [self localAgreementVersion];
    if (localVersion.length > 0 && ![localVersion isEqualToString:version]) {
        [self localAgreementUnFinished];
    }
    [self localAgreementVersion:version];
    [self localAgreementContent:content];
    [self parseAgreementContent:content];
}

- (void)parseAgreementContent:(NSString *)content {
    NSString *pattern = @"<a[\\s]+([^>]+)>((?:.(?!\\<\\/a\\>))*.)<\\/a>";
    NSError *error;
    NSRegularExpression *regular = [[NSRegularExpression alloc] initWithPattern:pattern
                                                                        options:NSRegularExpressionCaseInsensitive
                                                                          error:&error];
    if (error) {
        JMLog(@"协议链接解析失败");
    } else {
        NSArray <NSTextCheckingResult *>*results = [regular matchesInString:content
                                            options:NSMatchingReportProgress
                                              range:NSMakeRange(0, content.length)];
        JMLog(@"协议链接解析成功");
        NSMutableArray *links = [NSMutableArray array];
        for (NSTextCheckingResult *result in results) {
            [links addObject:[content substringWithRange:result.range]];
        }
        [self localAgreementLinks:[links copy]];
    }
}

#pragma mark - AgreementFinished

- (void)localAgreementUnFinished {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kJMBoomSDKAgreementFinishedKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)localAgreementFinished {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kJMBoomSDKAgreementFinishedKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isLocalAgreementFinished {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kJMBoomSDKAgreementFinishedKey];
}

#pragma mark - AgreementThrough

- (BOOL)localAgreementThrough:(BOOL)isThrough {
    BOOL isTroughing = ![self isLocalAgreementThrough] && isThrough;
    
    if (isTroughing) {
        [[JMBoomSDKEvent shared] uploadEvent:[JMBoomSDKEventItem event:JMBoomSDKEventId_Agreement_Through]];
    }
    [[NSUserDefaults standardUserDefaults] setBool:isThrough forKey:kJMBoomSDKAgreementThroughKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return isTroughing;
}

- (BOOL)isLocalAgreementThrough {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kJMBoomSDKAgreementThroughKey];
}


@end
