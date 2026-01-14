//
//  JMValue.m
//  JMBoomSDK
//
//  Created by Thief Toki on 2020/6/22.
//

#import "JMValue.h"

#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>

@implementation JMValue

+ (NSString *)Timestamp {
    return [NSString stringWithFormat:@"%.0f", [NSDate date].timeIntervalSince1970];
}

+ (NSString *)TimestampMillisecond {
    return [NSString stringWithFormat:@"%.0f", [NSDate date].timeIntervalSince1970*1000];
}

+ (NSString *)Nonce {
    return [NSString stringWithFormat:@"%lld", arc4random()%INT64_MAX];
}

+ (NSString *)Random32 {
    char data[32];
    for (int x=0; x <32; data[x++] = (char)(33 + (arc4random_uniform(93))));
    return [[NSString alloc] initWithBytes:data length:32 encoding:NSASCIIStringEncoding];
}

+ (NSString *)MD5:(NSString *)ID {
    if (ID.length == 0) {
        return nil;
    }
    
    const char *cStr = [ID UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],result[12], result[13], result[14], result[15]];
}

+ (NSString *)HmacSha1:(NSString *)key data:(NSString *)data {
    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [data cStringUsingEncoding:NSUTF8StringEncoding];
    
    //sha1
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    NSString *hash = [HMAC base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    return hash;
}

+ (NSString*)URLEncode:(NSString*)string {
    
    NSString *result = nil;
    
    if (string && string.length > 0) {
        NSCharacterSet *characterSet = [[NSCharacterSet characterSetWithCharactersInString:@"!*'()^;:@&=+$,/?%#[]"] invertedSet];
        result = [string stringByAddingPercentEncodingWithAllowedCharacters:characterSet];
    }
    
    return result;
}

@end
