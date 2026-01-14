//
//  JMBoomSDKEventItem.h
//  JMBoomSDK
//
//  Created by Thief Toki on 2021/1/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomSDKEventItem : NSObject

+ (instancetype)event:(NSInteger)eventId;
+ (instancetype)event:(NSInteger)eventId
               exStrs:(NSArray *)exStrs;

+ (instancetype)event:(NSInteger)eventId
                error:(NSError * _Nullable)error;
+ (instancetype)event:(NSInteger)eventId
               exStrs:(NSArray *)exStrs
                error:(NSError * _Nullable)error;

+ (instancetype)event:(NSInteger)eventId
            errorCode:(NSInteger)errorCode
         errorMessage:(NSString *)errorMessage;
+ (instancetype)event:(NSInteger)eventId
               exStrs:(NSArray *)exStrs
            errorCode:(NSInteger)errorCode
         errorMessage:(NSString *)errorMessage;

+ (instancetype)eventWithDict:(NSDictionary *)dict;

- (NSDictionary *)jsonValue;

@end

NS_ASSUME_NONNULL_END
