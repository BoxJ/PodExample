//
//  ViewController.m
//  PodExample
//
//  Created by 井良 on 2025/11/19.
//

#import "ViewController.h"
#import <JMBoomSDK/JMBoomSDK.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [[JMBoomSDKI shared] openCustomerSessionWithAccountID:nil avatar:nil callback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
//        NSLog(@"=== %@",error?error.localizedDescription:@"");
//    }];
    
    [[JMBoomSDKI shared] getToken:@"" completeHandler:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"获取Token %@",responseObject?:error);
    }];
    
    [[JMBoomSDKI shared] roleLogin:@"" roleId:@"" roleName:@"" roleAccount:@"" roleServer:@"" serverId:3 gameJson:@"" callback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"设置用户信息 %@",responseObject?:error);
    }];
    
}


@end
