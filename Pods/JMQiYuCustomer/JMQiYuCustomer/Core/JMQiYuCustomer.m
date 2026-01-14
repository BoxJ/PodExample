//
//  JMQiYuCustomer.m
//  PodExample
//
//  Created by 井良 on 2025/12/3.
//

#import "JMQiYuCustomer.h"

@interface JMQiYuCustomer ()
@property(nonatomic,assign)BOOL didInit;
@property(nonatomic,strong)UIViewController *viewController;

@property(nonatomic,copy)NSString *appName;
@property(nonatomic,copy)NSString *userId;
@property(nonatomic,copy)NSString *accountId;

@property(nonatomic,copy)NSString *groupId;
@property(nonatomic,copy)NSString *staffId;

@end

@implementation JMQiYuCustomer

+(instancetype)shared
{
    static JMQiYuCustomer *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(void)initWithAppKey:(NSString *)appKey appName:(NSString *)appName groupId:(nullable NSString *)groupId staffId:(nullable NSString *)staffId completion:(QYResultCompletionBlock)completion
{
    if (self.didInit) {
        completion(YES,
                   [NSError
                        errorWithDomain:NSStringFromClass([JMQiYuCustomer class])
                        code:-1
                        userInfo:@{
                           NSLocalizedDescriptionKey: @"客服系统已经初始化"
                        }
                    ]
                   );
        return;
    }
    self.appName = appName.length ? [appName copy] : @"";
    self.groupId = groupId.length ? [groupId copy] : @"";
    self.staffId = staffId.length ? [staffId copy] : @"";
    __weak typeof(self) weakSelf = self;
    QYSDKOption *option = [[QYSDKOption alloc] init];
    option.appKey = appKey;
    option.appName = appName ?: @"";
    [[QYSDK sharedSDK] registerWithOption:option completion:^(BOOL success, NSError *error) {
        if (success) {
            weakSelf.didInit = YES;
        }
        if (completion) {
            completion(success,error);
        }
    }];
}

-(void)setUserId:(NSString *)userId
{
    _userId = [userId copy];
}

-(void)setAccountId:(NSString *)accountId avatar:(nullable NSString *)avatarUrl completion:(QYResultCompletionBlock)completion
{
    if (!self.didInit) {
        completion(NO,
                   [NSError
                        errorWithDomain:NSStringFromClass([JMQiYuCustomer class])
                        code:-1
                        userInfo:@{
                           NSLocalizedDescriptionKey: @"客服系统还未初始化"
                        }
                    ]
                   );
        return;
    }
    NSString *currentUserId = [[QYSDK sharedSDK] currentUserID];
    if (currentUserId.length && self.userId.length && ![currentUserId isEqualToString:self.userId]) {
        __weak typeof(self) weakSelf = self;
        [[QYSDK sharedSDK] logout:^(BOOL success) {
            [weakSelf setUserInfoWithAccountId:accountId avatar:avatarUrl completion:completion];
        }];
    }
    else {
        [self setUserInfoWithAccountId:accountId avatar:avatarUrl completion:completion];
    }
}

-(void)setUserInfoWithAccountId:(NSString *)accountId avatar:(nullable NSString *)avatarUrl completion:(QYResultCompletionBlock)completion
{
    if (self.userId.length) {
        QYUserInfo *userInfo = [[QYUserInfo alloc] init];
        userInfo.userId = self.userId;
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
        if (accountId.length) {
            NSMutableDictionary *tempDict = [NSMutableDictionary new];
            [tempDict setObject:@"account" forKey:@"key"];
            [tempDict setObject:accountId forKey:@"value"];
            [tempDict setObject:@"账号" forKey:@"label"];
            [array addObject:tempDict];
        }
        
        if (avatarUrl.length) {
            NSMutableDictionary *tempDict = [NSMutableDictionary new];
            [tempDict setObject:@"avatar" forKey:@"key"];
            [tempDict setObject:avatarUrl forKey:@"value"];
            [tempDict setObject:@"头像" forKey:@"label"];
            [array addObject:tempDict];
        }
        
        if (self.appName.length) {
            NSMutableDictionary *tempDict = [NSMutableDictionary new];
            [tempDict setObject:@"appName" forKey:@"key"];
            [tempDict setObject:self.appName forKey:@"value"];
            [tempDict setObject:@"游戏名称" forKey:@"label"];
            [array addObject:tempDict];
        }
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:array
                                                       options:0
                                                         error:nil];
        if (data) {
            userInfo.data = [[NSString alloc] initWithData:data
                                                  encoding:NSUTF8StringEncoding];
        }
        
        [[QYSDK sharedSDK] setUserInfo:userInfo userInfoResultBlock:^(BOOL success, NSError *error) {
            if (completion) {
                completion(success,error);
            }
        }];
    } else {
        if (completion) {
            NSString *errorString = [NSString stringWithFormat:@"OpenID:%@,AccountID:%@",self.userId.length?@"有值":@"无值",accountId.length?@"有值":@"无值"];
            completion(NO,
                       [NSError
                            errorWithDomain:NSStringFromClass([JMQiYuCustomer class])
                            code:-1
                            userInfo:@{
                               NSLocalizedDescriptionKey: errorString
                            }
                        ]
                       );
        }
    }
}
-(void)checkUserID
{
    NSString *currentUserId = [[QYSDK sharedSDK] currentUserID];
    if (!currentUserId.length && self.userId.length) {
        QYUserInfo *userInfo = [[QYUserInfo alloc] init];
        userInfo.userId = self.userId;
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
        
        if (self.appName.length) {
            NSMutableDictionary *tempDict = [NSMutableDictionary new];
            [tempDict setObject:@"appName" forKey:@"key"];
            [tempDict setObject:self.appName forKey:@"value"];
            [tempDict setObject:@"游戏名称" forKey:@"label"];
            [array addObject:tempDict];
        }
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:array
                                                       options:0
                                                         error:nil];
        if (data) {
            userInfo.data = [[NSString alloc] initWithData:data
                                                  encoding:NSUTF8StringEncoding];
            NSLog(@"设置的信息：%@",userInfo.data);
        }
        
        [[QYSDK sharedSDK] setUserInfo:userInfo userInfoResultBlock:^(BOOL success, NSError *error) {
            
        }];
    }
}
-(void)openCustomerSessionWithCompletion:(QYResultCompletionBlock)completion
{
    if (!self.didInit) {
        if (completion) {
            completion(NO,
                       [NSError
                            errorWithDomain:NSStringFromClass([JMQiYuCustomer class])
                            code:-1
                            userInfo:@{
                               NSLocalizedDescriptionKey: @"客服系统还未初始化"
                            }
                        ]
                       );
        }
        return;
    }
    [self checkUserID];
    self.viewController = [self currentViewController];
    if (!self.viewController || ![self.viewController isKindOfClass:[UIViewController class]]) {
        if (completion) {
            completion(NO,
                       [NSError
                            errorWithDomain:NSStringFromClass([JMQiYuCustomer class])
                            code:-1
                            userInfo:@{
                               NSLocalizedDescriptionKey: @"未找到当前视图"
                            }
                        ]
                       );
        }
        return;
    }
    
//    QYSource *source = [[QYSource alloc] init];
//    source.title = @"七鱼客服";
//    source.urlString = @"https://qiyukf.com/";
    
    QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
    sessionViewController.sessionTitle = @"在线客服";

    if (self.groupId.length) {
//        NSLog(@" - 设置组：%@",self.groupId);
        sessionViewController.groupId = [self.groupId longLongValue];
    }
    if (self.staffId.length) {
//        NSLog(@" - 设置客服：%@",self.staffId);
        sessionViewController.staffId = [self.staffId longLongValue];
    }
    sessionViewController.openRobotInShuntMode = NO;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"chevron.backward"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    sessionViewController.navigationItem.leftBarButtonItem = leftItem;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:sessionViewController];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.viewController presentViewController:nav animated:YES completion:nil];
    
    if (completion) {
        completion(YES, nil);
    }
    
}

-(void)openCustomerSessionWithAccountID:(nullable NSString *)accountId avatar:(nullable NSString *)avatarUrl ompletion:(QYResultCompletionBlock)completion
{
    if (!self.didInit) {
        if (completion) {
            completion(NO,
                       [NSError
                            errorWithDomain:NSStringFromClass([JMQiYuCustomer class])
                            code:-1
                            userInfo:@{
                               NSLocalizedDescriptionKey: @"客服系统还未初始化"
                            }
                        ]
                       );
        }
        return;
    }
    
    NSString *currentUserId = [[QYSDK sharedSDK] currentUserID];
    __weak typeof(self) weakSelf = self;
    if (currentUserId.length && self.userId.length && ![currentUserId isEqualToString:self.userId]) {
        [[QYSDK sharedSDK] logout:^(BOOL success) {
            [weakSelf setUserInfoWithAccountId:accountId avatar:avatarUrl completion:^(BOOL success, NSError *error) {
                if (success) {
                    [weakSelf openCustomerVCWithCompletion:completion];
                }
                else if (completion) {
                    completion(success,error);
                }
            }];
        }];
    }
    else if (self.userId.length) {
        [self setUserInfoWithAccountId:accountId avatar:avatarUrl completion:^(BOOL success, NSError *error) {
            if (success) {
                [weakSelf openCustomerVCWithCompletion:completion];
            }
            else if (completion) {
                completion(success,error);
            }
        }];
    }
    else {
        [self openCustomerVCWithCompletion:completion];
    }
}

-(void)openCustomerVCWithCompletion:(QYResultCompletionBlock)completion
{
    self.viewController = [self currentViewController];
    if (!self.viewController || ![self.viewController isKindOfClass:[UIViewController class]]) {
        if (completion) {
            completion(NO,
                       [NSError
                            errorWithDomain:NSStringFromClass([JMQiYuCustomer class])
                            code:-1
                            userInfo:@{
                               NSLocalizedDescriptionKey: @"未找到当前视图"
                            }
                        ]
                       );
        }
        return;
    }
    
//    QYSource *source = [[QYSource alloc] init];
//    source.title = @"七鱼客服";
//    source.urlString = @"https://qiyukf.com/";
    
    QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
    sessionViewController.sessionTitle = @"在线客服";

    if (self.groupId.length) {
//        NSLog(@" - 设置组：%@",self.groupId);
        sessionViewController.groupId = [self.groupId longLongValue];
    }
    if (self.staffId.length) {
//        NSLog(@" - 设置客服：%@",self.staffId);
        sessionViewController.staffId = [self.staffId longLongValue];
    }
    sessionViewController.openRobotInShuntMode = NO;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"chevron.backward"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    sessionViewController.navigationItem.leftBarButtonItem = leftItem;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:sessionViewController];
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.viewController presentViewController:nav animated:YES completion:nil];
    
    if (completion) {
        completion(YES, nil);
    }
}

-(void)logOut
{
    if (!self.didInit) {
        return;
    }
    NSString *currentUserId = [[QYSDK sharedSDK] currentUserID];
    if (!currentUserId.length) {
        return;
    }
    [[QYSDK sharedSDK] logout:^(BOOL success) {
        
    }];
}

- (void)onBack:(id)sender {
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}


-(UIWindow *)currentWindow {
    for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
        if (scene.activationState == UISceneActivationStateForegroundActive) {
            for (UIWindow *window in scene.windows) {
                if (window.isKeyWindow) {
                    return window;
                }
            }
        }
    }
    return [UIApplication sharedApplication].keyWindow;
}

-(UIViewController *)currentViewController {
    UIWindow *window = [self currentWindow];
    return [self topViewController:window.rootViewController];
}

-(UIViewController *)topViewController {
    return [self topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

-(UIViewController *)topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self topViewController:[(UINavigationController *)vc visibleViewController]];
    }
    if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self topViewController:[(UITabBarController *)vc selectedViewController]];
    }
    if (vc.presentedViewController) {
        return [self topViewController:vc.presentedViewController];
    }
    return vc;
}
@end
