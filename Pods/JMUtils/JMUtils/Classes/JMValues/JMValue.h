//
//  JMValue.h
//  JMBoomSDK
//
//  Created by Thief Toki on 2020/6/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMValue : NSObject

+ (NSString *)Timestamp;

+ (NSString *)TimestampMillisecond;

+ (NSString *)Nonce;

+ (NSString *)Random32;

+ (NSString *)MD5:(NSString *)ID;

+ (NSString *)HmacSha1:(NSString *)key data:(NSString *)data;

+ (NSString*)URLEncode:(NSString*)string;

@end

NS_ASSUME_NONNULL_END
