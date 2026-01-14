//
//  JMRktRequestConfig.h
//  JMRktRequest
//
//  Created by Thief Toki on 2021/4/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMRktRequestConfig : NSObject

@property (nonatomic, strong) NSDictionary <NSString *, id>*(^infoHook)(void);

@property (nonatomic, strong) NSString *(^signKeyHook)(void);
@property (nonatomic, strong) NSArray <NSString *>*(^signOrderHook)(void);

+ (instancetype)configWithInfoHook:(NSDictionary <NSString *, id>*(^)(void))infoHook
                       signKeyHook:(NSString *(^)(void))signKeyHook
                     signOrderHook:(NSArray <NSString *>*(^)(void))signOrderHook;

- (NSDictionary <NSString *, id>*)infoByAppendingInfo:(NSDictionary *)info
                                              signKey:(NSString *)signKey
                                            signOrder:(NSArray <NSString *>*)signOrder
                                            secretKey:(NSString *)secretKey;

@end

NS_ASSUME_NONNULL_END
