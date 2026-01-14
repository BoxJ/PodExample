//
//  NSDate+JMExtension.h
//  JMBoomSDK
//
//  Created by Thief Toki on 2020/8/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (JMExtension)

+ (NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format;

- (NSDate *)weeDate;

- (NSString *)stringValue;
- (NSString *)stringValueWithFormat:(NSString *)format;

@end

NS_ASSUME_NONNULL_END
