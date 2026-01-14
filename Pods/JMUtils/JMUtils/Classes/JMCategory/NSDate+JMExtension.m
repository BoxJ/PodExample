//
//  NSDate+JMExtension.m
//  JMBoomSDK
//
//  Created by Thief Toki on 2020/8/13.
//

#import "NSDate+JMExtension.h"

@implementation NSDate (JMExtension)

+ (NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    return [formatter dateFromString:dateString];
}

- (NSDate *)weeDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay
                                                   fromDate:self];
    NSDate *weeDate = [calendar dateFromComponents:dateComponents];
    return weeDate;
}

- (NSString *)stringValue {
    return [self stringValueWithFormat:@"yyyyMMdd_HHmmss_SSS"];
}

- (NSString *)stringValueWithFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    return [formatter stringFromDate:self];
}

@end
