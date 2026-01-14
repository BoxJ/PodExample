//
//  JMBoomSDKRequest+Data.m
//  JMBoomInitializeBusiness
//
//  Created by ZhengXianda on 2022/7/5.
//

#import "JMBoomSDKRequest+Data.h"

@implementation JMBoomSDKRequest (Data)

- (void)uploadChapter:(NSString *)chapter
            guildName:(NSString *)guildName
          roleBalance:(NSString *)roleBalance
               roleId:(NSString *)roleId
               roleLv:(NSString *)roleLv
             roleName:(NSString *)roleName
            rolePower:(NSString *)rolePower
            serviceId:(NSString *)serviceId
          serviceName:(NSString *)serviceName
                vipLv:(NSString *)vipLv
                  ext:(NSDictionary *)ext
             callback:(JMRequestCallback)callback {
    NSString *path = @"/client/data/roleInfo";
    NSDictionary *parameters = @{
        @"chapter": chapter?:@"",
        @"guildName": guildName?:@"",
        @"roleBalance": roleBalance?:@"",
        @"roleId": roleId?:@"",
        @"roleLv": roleLv?:@"",
        @"roleName": roleName?:@"",
        @"rolePower": rolePower?:@"",
        @"serviceId": serviceId?:@"",
        @"serviceName": serviceName?:@"",
        @"vipLv": vipLv?:@"",
        @"ext": ext?:@{},
    };
    
    [self requestDataWithMethod:JMRequestMethodType_POST_JSON
                           path:path
                     parameters:parameters
                       callback:callback];
}

@end
