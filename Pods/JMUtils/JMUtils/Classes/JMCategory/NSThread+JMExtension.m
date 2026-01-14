//
//  NSThread+JMExtension.m
//  JMUtils
//
//  Created by ZhengXianda on 2021/12/21.
//

#import "NSThread+JMExtension.h"

@implementation NSThread (JMExtension)

- (JMThreadInfo *)info {
    NSString *description = [[NSThread currentThread] description];
    NSRange beginRange = [description rangeOfString:@"{"];
    NSRange endRange = [description rangeOfString:@"}"];
    
    if (beginRange.location == NSNotFound || endRange.location == NSNotFound) {
        return nil;
    }
    
    NSInteger length = endRange.location - beginRange.location - 1;
    if (length < 1) {
        return nil;
    }
    
    NSRange keyRange = NSMakeRange(beginRange.location + 1, length);
    
    if (keyRange.location == NSNotFound) {
        return nil;
    }
    
    JMThreadInfo *info = [[JMThreadInfo alloc] init];
    
    if (description.length > (keyRange.location + keyRange.length)) {
        NSString *keyPairs = [description substringWithRange:keyRange];
        NSArray *keyValuePairs = [keyPairs componentsSeparatedByString:@","];
        for (NSString *keyValuePair in keyValuePairs) {
            NSArray *components = [keyValuePair componentsSeparatedByString:@"="];
            if (components.count) {
                NSString *key = components[0];
                key = [key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                if (([key isEqualToString:@"num"] || [key isEqualToString:@"number"]) && components.count > 1) {
                    info.number = [components[1] stringByReplacingOccurrencesOfString:@" " withString:@""];
                }
                if ([key isEqualToString:@"name"] && components.count > 1) {
                    info.name = [components[1] stringByReplacingOccurrencesOfString:@" " withString:@""];
                }
            }
        }
    }
    return info;
}

@end
