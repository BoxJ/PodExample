//
//  JMRktResponse.h
//  JMRktCommon
//
//  Created by Thief Toki on 2021/1/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMRktResponse : NSObject

#pragma mark - success

+ (NSDictionary *)success;

+ (NSDictionary *)successWithResult:(NSObject *)result;

#pragma mark - error

+ (NSError *)errorWithCode:(NSInteger)code
                      message:(NSString *)message;

+ (NSError *)errorWithCode:(NSInteger)code
                      message:(NSString *)message
                     userInfo:(NSDictionary *)userInfo;

+ (NSError *)errorWithCode:(NSInteger)code
                   message:(NSString *)message
                  userInfo:(NSDictionary *)userInfo
              messageStyle:(NSDictionary *)messageStyle
                   traceId:(NSString *)traceId;

@end

NS_ASSUME_NONNULL_END
