//
//  JMDeviceAnalyze.h
//  JMBoomSDK
//
//  Created by Thief Toki on 2020/6/22.
//

#import <Foundation/Foundation.h>

#import "NSUserDefaults+DeviceAnalyze.h"

NS_ASSUME_NONNULL_BEGIN

@interface JMDeviceAnalyze : NSObject

+ (NSString *)IMSI;

+ (NSString *)BundleId;

+ (NSString *)AppVersion;

+ (NSString *)Platform;

+ (NSString *)SystemName;
+ (NSString *)SystemVersion;
+ (NSString *)SystemBuildVersion;
+ (NSString *)SystemFullVersion;

+ (NSString *)Resolution;

+ (NSString *)IDFA;

+ (NSString *)UUID;
+ (NSString *)UID;
+ (NSString *)UniqueId;
+ (NSString *)UniqueIdNewOne;
+ (NSString *)UIDLocal;
+ (NSString *)UniqueIdLocal;
+ (NSString *)UniqueIdNewOneLocal;

+ (BOOL)isLandscape;

+ (BOOL)isNotchScreen;

+ (NSString *)language;

@end

NS_ASSUME_NONNULL_END
