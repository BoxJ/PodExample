//
//  NSDictionary+JMRktRequestSign.m
//  JMRktRequest
//
//  Created by Thief Toki on 2021/1/27.
//

#import "NSDictionary+JMRktRequestSign.h"

#import "NSMutableString+JMRktRequestSign.h"

#import <JMUtils/JMUtils.h>

@implementation NSDictionary (JMRktRequestSign)

- (NSString *)secretWithKey:(NSString *)secretKey andOrder:(NSArray <NSString *>*)order {
    //初始化数据
    NSMutableString *secretData = [NSMutableString string];
    //添加验签相关参数
    for (NSString *key in order) {
        NSString *value = [NSString stringWithFormat:@"%@", self[key]?:@""];
        if (value.length > 0) {
            [secretData insertSecretPair:key value:value];
        }
    }
    //计算密钥
    NSString *HmacSha1 = [JMValue HmacSha1:secretKey?:@"" data:secretData];
    NSString *signature = [JMValue URLEncode:HmacSha1];
    return signature;
}

@end
