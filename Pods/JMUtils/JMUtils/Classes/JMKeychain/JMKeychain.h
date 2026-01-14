//
//  JMKeychain.h
//  JMBoomSDK
//
//  Created by Thief Toki on 2020/7/6.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMKeychain : NSObject

+ (OSStatus)addKeychainWithService:(NSString *)service account:(NSString *)account value:(NSString *)value;

+ (OSStatus)updateKeychainWithService:(NSString *)service account:(NSString *)account value:(NSString *)value;

+ (NSString *)readKeychainWithService:(NSString *)service account:(NSString *)account;
    
@end

NS_ASSUME_NONNULL_END
