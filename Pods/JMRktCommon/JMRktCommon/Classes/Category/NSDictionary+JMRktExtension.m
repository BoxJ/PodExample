//
//  NSDictionary+JMRktExtension.m
//  JMRktCommon
//
//  Created by ZhengXianda on 3/3/23.
//

#import "NSDictionary+JMRktExtension.h"

@implementation NSDictionary (JMRktExtension)

- (NSDictionary *)result {
    NSDictionary *result = self[@"result"];
    if ([result isKindOfClass:NSDictionary.class]) {
        return result;
    } else {
        return @{};
    }
}

@end
