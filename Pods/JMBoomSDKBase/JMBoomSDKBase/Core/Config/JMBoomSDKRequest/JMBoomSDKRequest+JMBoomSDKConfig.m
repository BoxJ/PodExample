//
//  JMBoomSDKRequest+JMBoomSDKConfig.m
//  JMBoomSDK
//
//  Created by Thief Toki on 2021/1/20.
//

#import "JMBoomSDKRequest+JMBoomSDKConfig.h"

@implementation JMBoomSDKRequest (JMBoomSDKConfig)

- (void)fetchConfigWithCallback:(JMRequestCallback)callback {
    NSString *path = @"/client/init/config";
    NSDictionary *parameters = @{
    
    };
    
    [self requestDataWithMethod:JMRequestMethodType_GET
                           path:path
                     parameters:parameters
                       callback:callback];
}

@end
