//
//  JMKeychain.m
//  JMBoomSDK
//
//  Created by Thief Toki on 2020/7/6.
//

#import "JMKeychain.h"

#import <objc/runtime.h>

@implementation JMKeychain

+ (OSStatus)addKeychainWithService:(NSString *)service account:(NSString *)account value:(NSString *)value {
    NSData *valueData = [value dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *query = @{
        (__bridge id)kSecAttrAccessible : (__bridge id)kSecAttrAccessibleAlwaysThisDeviceOnly,
        (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecValueData : valueData,
        (__bridge id)kSecAttrAccount : account,
        (__bridge id)kSecAttrService : service,
    };
    
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)query, nil);
    
    return status;
}

+ (OSStatus)updateKeychainWithService:(NSString *)service account:(NSString *)account value:(NSString *)value {
    NSData *valueData = [value dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *query = @{(__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecAttrAccount : account,
                            (__bridge id)kSecAttrService : service,
                            };
    NSDictionary *update = @{
                             (__bridge id)kSecValueData : valueData,
                             };
    
    OSStatus status = SecItemUpdate((__bridge CFDictionaryRef)query, (__bridge CFDictionaryRef)update);
    
    return status;
}

+ (NSString *)readKeychainWithService:(NSString *)service account:(NSString *)account {
    NSDictionary *query = @{(__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecReturnData : @YES,
                            (__bridge id)kSecMatchLimit : (__bridge id)kSecMatchLimitOne,
                            (__bridge id)kSecAttrAccount : account,
                            (__bridge id)kSecAttrService : service,
                            };
    
    CFTypeRef dataTypeRef = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &dataTypeRef);
    
    NSString *keychain;
    if (status == noErr) {
        keychain = [[NSString alloc] initWithData:(__bridge NSData * _Nonnull)(dataTypeRef)
                                         encoding:NSUTF8StringEncoding];
        CFRelease(dataTypeRef);
    }
    
    return keychain;
}

@end
