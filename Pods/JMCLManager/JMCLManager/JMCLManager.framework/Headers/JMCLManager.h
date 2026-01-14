//
//  JMCLManager.h
//  JMBoomSDK
//
//  Created by Thief Toki on 2020/8/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^JMCLCallback)(NSDictionary * _Nonnull info, NSError * _Nullable error);

@interface JMCLManager : NSObject

@property (nonatomic, strong, nullable) NSString *protocolName;
@property (nonatomic, strong, nullable) NSString *telecom;
@property (nonatomic, strong, nullable) NSString *protocolUrl;
@property (nonatomic, strong, nullable) NSString *number;
@property (nonatomic, strong, nullable) NSString *operatorName;

@property (nonatomic, strong, nullable) NSString *token;

+ (instancetype)shared;

- (void)registerAppId:(NSString *)appId;
- (void)awakeWithCallback:(JMCLCallback)callback;
- (void)getPhoneNumberWithCallback:(JMCLCallback)callback;
- (void)loginAuthWithCallback:(JMCLCallback)callback;

@end

NS_ASSUME_NONNULL_END
