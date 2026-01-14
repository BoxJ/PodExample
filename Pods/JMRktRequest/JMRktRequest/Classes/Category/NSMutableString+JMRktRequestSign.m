//
//  NSMutableString+JMRktRequestSign.m
//  JMRktRequest
//
//  Created by Thief Toki on 2021/1/27.
//

#import "NSMutableString+JMRktRequestSign.h"

@implementation NSMutableString (JMRktRequestSign)

- (void)insertSecretPair:(NSString *)key value:(NSString *)value {
    if (value.length > 0) {
        if (self.length > 0) {
            [self appendString:@"&"];
        }
        [self appendFormat:@"%@=%@", key, value];
    }
}

@end
