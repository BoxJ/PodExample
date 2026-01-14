//
//  NSDictionary+JMExtension.m
//  JMBoomSDK
//
//  Created by Thief Toki on 2020/9/16.
//

#import "NSDictionary+JMExtension.h"

@implementation NSDictionary (JMExtension)

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil || ![jsonString isKindOfClass:[NSString class]]) {
        return @{};
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        return @{};
    }
    return dic;
}

@end
