//
//  JMBoomSDKRequest+JMBoomInitializeBusiness.m
//  JMBoomInitializeBusiness
//
//  Created by Thief Toki on 2021/1/20.
//

#import "JMBoomSDKRequest+JMBoomInitializeBusiness.h"

@implementation JMBoomSDKRequest (JMBoomInitializeBusiness)

- (void)initSDKWithCallback:(JMRequestCallback)callback {
    NSString *path = @"/client/init/ios";
    NSDictionary *parameters = @{
        
    };
    
    [self requestDataWithMethod:JMRequestMethodType_GET
                           path:path
                     parameters:parameters
                       callback:callback];
}

- (void)activateWithToken:(NSString *)token
                   adData:(NSString *)adData
                 callback:(JMRequestCallback)callback {
    NSString *path = @"/client/security/activate";
    NSDictionary *parameters = @{
        @"channel": @"appstore",
        @"adToken": token?:@"",
        @"adData": adData?:@"",
    };

    [self requestDataWithMethod:JMRequestMethodType_GET
                           path:path
                     parameters:parameters
                       callback:callback];
}

@end
