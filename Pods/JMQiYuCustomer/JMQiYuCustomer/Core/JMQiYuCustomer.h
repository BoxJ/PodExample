//
//  JMQiYuCustomer.h
//  PodExample
//
//  Created by 井良 on 2025/12/3.
//

#import <Foundation/Foundation.h>
#import <QYSDK/QYSDK.h>
NS_ASSUME_NONNULL_BEGIN

@interface JMQiYuCustomer : NSObject
+(instancetype)shared;
-(void)initWithAppKey:(NSString *)appKey appName:(NSString *)appName groupId:(nullable NSString *)groupId staffId:(nullable NSString *)staffId completion:(QYResultCompletionBlock)completion;

-(void)setUserId:(NSString *)userId;

-(void)setAccountId:(NSString *)accountId avatar:(nullable NSString *)avatarUrl completion:(QYResultCompletionBlock)completion;

-(void)openCustomerSessionWithCompletion:(QYResultCompletionBlock)completion;

-(void)openCustomerSessionWithAccountID:(nullable NSString *)accountId avatar:(nullable NSString *)avatarUrl ompletion:(QYResultCompletionBlock)completion;

-(void)logOut;
@end

NS_ASSUME_NONNULL_END
