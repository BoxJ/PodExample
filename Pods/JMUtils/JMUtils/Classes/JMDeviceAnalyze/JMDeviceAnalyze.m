//
//  JMDeviceAnalyze.m
//  JMBoomSDK
//
//  Created by Thief Toki on 2020/6/22.
//

#import "JMDeviceAnalyze.h"

#import "JMValue.h"

#import "JMKeychain.h"

#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

#import <sys/sysctl.h>

#import <AdSupport/ASIdentifierManager.h>

@implementation JMDeviceAnalyze

#pragma mark - shared

+ (NSString *)IMSI {
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];

    NSString *mcc = [carrier mobileCountryCode];
    NSString *mnc = [carrier mobileNetworkCode];

    NSString *imsi = [NSString stringWithFormat:@"%@%@", mcc?:@"", mnc?:@""];

    return imsi;
}

+ (NSString *)BundleId {
    NSBundle * bundle=[NSBundle mainBundle];
    return bundle.bundleIdentifier;
}

+ (NSString *)AppVersion {
    NSBundle * bundle=[NSBundle mainBundle];
    return [bundle.infoDictionary objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)Platform {
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *value = (char *) malloc(size);
    if (value == NULL) {
        return nil;
    }
    sysctlbyname("hw.machine", value, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:value encoding:NSUTF8StringEncoding];
    free(value);

    return platform ?: [UIDevice currentDevice].model;
}

+ (NSString *)SystemName {
    return [UIDevice currentDevice].systemName;
}

+ (NSString *)SystemVersion {
    return [UIDevice currentDevice].systemVersion;
}

+ (NSString *)SystemBuildVersion {
    size_t size = 0;
    sysctlbyname("kern.osversion", NULL, &size, NULL, 0);
    char *value = (char *) malloc(size);
    if (value == NULL) {
        return nil;
    }
    sysctlbyname("kern.osversion", value, &size, NULL, 0);
    NSString *version = [NSString stringWithCString:value encoding:NSUTF8StringEncoding];
    free(value);
    
    return version;
}

+ (NSString *)SystemFullVersion {
    return [NSString stringWithFormat:@"%@ %@ (%@)",
            [self SystemName],
            [self SystemVersion],
            [self SystemBuildVersion]];
}

+ (NSString *)Resolution {
    CGSize size = [[UIScreen mainScreen] bounds].size;
    NSString *resolution = [NSString stringWithFormat:@"%.0fx%.0f", size.width, size.height];
    return resolution;
}

+ (NSString *)IDFA {
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString] ?: @"";
}

+ (NSString *)UUID {
    return [[NSUUID UUID] UUIDString];
}

+ (NSString *)UID {
    NSString *service = @"JMBoomSDK";
    NSString *account = @"UID";
    NSString *UID = [JMKeychain readKeychainWithService:service account:account];
    if (UID.length == 0) {
        UID = [self UUID];
        [JMKeychain addKeychainWithService:service account:account value:UID];
    }
    if ([UID isEqualToString:@"00000000000000000000000000000000"]) {
        UID = [self UUID];
        [JMKeychain updateKeychainWithService:service account:account value:UID];
    }
    return [[UID stringByReplacingOccurrencesOfString:@"-" withString:@""] lowercaseString];
}

+ (NSString *)UniqueId {
    NSString *service = @"JMBoomSDK";
    NSString *account = @"UniqueId";
    NSString *UID = [JMKeychain readKeychainWithService:service account:account];
    if (UID.length == 0) {
        UID = [self UID];
        UID = [UID stringByAppendingString:[JMValue Random32]];
        UID = [JMValue MD5:UID];
        [JMKeychain addKeychainWithService:service account:account value:UID];
    }
    return UID;
}

+ (NSString *)UniqueIdNewOne {
    NSString *service = @"JMBoomSDK";
    NSString *account = @"UniqueId";
    NSString *UID;
    UID = [self UID];
    UID = [UID stringByAppendingString:[JMValue Random32]];
    UID = [JMValue MD5:UID];
    [JMKeychain updateKeychainWithService:service account:account value:UID];
    return UID;
}

+ (NSString *)UIDLocal {
    NSString *UID = [NSUserDefaults localUID];
    if (UID.length == 0) {
        UID = [self UUID];
        [NSUserDefaults localUID:UID];
    }
    if ([UID isEqualToString:@"00000000000000000000000000000000"]) {
        UID = [self UUID];
        [NSUserDefaults localUID:UID];
    }
    return [[UID stringByReplacingOccurrencesOfString:@"-" withString:@""] lowercaseString];
}

+ (NSString *)UniqueIdLocal {
    NSString *UID = [NSUserDefaults localUniqueId];
    if (UID.length == 0) {
        UID = [self UID];
        UID = [UID stringByAppendingString:[JMValue Random32]];
        UID = [JMValue MD5:UID];
        [NSUserDefaults localUniqueId:UID];
    }
    return UID;
}

+ (NSString *)UniqueIdNewOneLocal {
    NSString *UID;
    UID = [self UID];
    UID = [UID stringByAppendingString:[JMValue Random32]];
    UID = [JMValue MD5:UID];
    [NSUserDefaults localUniqueId:UID];
    return UID;
}

+ (BOOL)isLandscape {
    switch ([UIApplication sharedApplication].statusBarOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            return YES;
            break;
        default:
            return NO;
            break;
    }
}

+ (BOOL)isNotchScreen {
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            return NO;
        }
        
        CGSize size = [UIScreen mainScreen].bounds.size;
        NSInteger notchValue = size.width / size.height * 100;
        
        if (216 == notchValue || 46 == notchValue) {
            return YES;
        }
        
        return NO;
}

+ (NSString *)language {
    return [NSLocale preferredLanguages].firstObject ?: @"zh";
}

@end
