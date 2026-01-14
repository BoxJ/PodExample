//
//  NSString+JMExtension.m
//  JMBoomSDK
//
//  Created by Thief Toki on 2020/9/14.
//

#import "NSString+JMExtension.h"

@implementation NSString (JMExtension)

- (NSString *)domain {
    NSString *host = [NSURL URLWithString:self].host;
    NSArray *paths = [[[host componentsSeparatedByString:@"."] reverseObjectEnumerator] allObjects];
    if (paths.count >= 2) {
        return [NSString stringWithFormat:@"%@.%@", paths[1], paths.firstObject];
    }
    return @"";
}

- (NSRange)HTMLTag {
    NSRange range = [self rangeOfString:@"<(\\S*?)[^>]*>.*?|<.*? />" options:NSRegularExpressionSearch];
    return range;
}

- (BOOL)hasHTMLTag {
    return [self HTMLTag].location != NSNotFound;
}

- (NSString *)stringWithoutHTMLTags {
    NSString *result = self;
    while ([result hasHTMLTag]) {
        result = [result stringByReplacingCharactersInRange:[result HTMLTag] withString:@""];
    }
    return result;
}

- (BOOL)isPhoneNumber {
    //手机号码格式正则表达式
    NSString *phoneRegex = @"^1\\d{10}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:self];
}

+ (NSString *)random:(NSInteger)length {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];

    for (int i = 0; i < length; i++) {
        [randomString appendFormat:@"%C", [letters characterAtIndex:arc4random() % [letters length]]];
    }

    return randomString;
}

+ (NSString *)bytesSize:(NSUInteger )size {
    double displaySize = (double)size;
    
    int level = 0;
    int limit = 4;
    while (level <= limit) {
        if (displaySize >= 1024) {
            displaySize /= 1024.0;
            level ++;
        } else {
            break;
        }
    }
    
    NSString *suffix = @"";
    switch (level) {
        case 0: suffix = @"B"; break;
        case 1: suffix = @"KB"; break;
        case 2: suffix = @"MB"; break;
        case 3: suffix = @"GB"; break;
        case 4: suffix = @"TB"; break;
        default:suffix = @"TB"; break;
    }
    
    return [NSString stringWithFormat:@"%.2f%@", displaySize, suffix];
}

- (BOOL)isHTTPLink {
    NSError *error = nil;
    NSString *pattern = @"http(s)?://[A-Za-z0-9._%+-]+(/[A-Za-z0-9._%+-]*\\S*)?";
    NSRegularExpression *regex = 
    [NSRegularExpression regularExpressionWithPattern:pattern
                                              options:NSRegularExpressionCaseInsensitive
                                                error:&error];
    if (error) return false;
    
    NSArray *matches = [regex matchesInString:self
                                      options:0
                                        range:NSMakeRange(0, [self length])];
    if (matches.count == 0) return false;
    
    return true;
}

@end
