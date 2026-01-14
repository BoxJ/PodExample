//
//  JMRktRequestConfig.m
//  JMRktRequest
//
//  Created by Thief Toki on 2021/4/12.
//

#import "JMRktRequestConfig.h"

#import "NSDictionary+JMRktRequestSign.h"

@implementation JMRktRequestConfig

+ (instancetype)configWithInfoHook:(NSDictionary <NSString *, id>*(^)(void))infoHook
                       signKeyHook:(NSString *(^)(void))signKeyHook
                     signOrderHook:(NSArray <NSString *>*(^)(void))signOrderHook {
    JMRktRequestConfig *config = [[self alloc] init];
    if (config) {
        config.infoHook = infoHook;
        config.signKeyHook = signKeyHook;
        config.signOrderHook = signOrderHook;
    }
    return config;
}

- (NSDictionary<NSString *,id> *)infoByAppendingInfo:(NSDictionary *)info
                                             signKey:(NSString *)signKey
                                           signOrder:(NSArray<NSString *> *)signOrder
                                           secretKey:(NSString *)secretKey {
    NSMutableDictionary *mutableInfo = [self.infoHook() mutableCopy];
    [mutableInfo addEntriesFromDictionary:info];
    //判断是否进行本地加密
    if (signKey.length > 0 && signOrder.count > 0) {
        mutableInfo[signKey] = [mutableInfo secretWithKey:secretKey andOrder:signOrder];
        return [mutableInfo copy];
    }
    //判断是否进行默认加密
    NSString *defaultSignKey = self.signKeyHook();
    NSArray <NSString *>*defaultSignOrder = self.signOrderHook();
    if (defaultSignKey.length > 0 && defaultSignOrder.count > 0) {
        mutableInfo[defaultSignKey] = [mutableInfo secretWithKey:secretKey andOrder:defaultSignOrder];
        return [mutableInfo copy];
    }
    //未经过加密
    return [mutableInfo copy];
}

#pragma mark - getter

- (NSDictionary<NSString *,id> * _Nonnull (^)(void))infoHook {
    if (!_infoHook) {
        _infoHook = ^NSDictionary<NSString *,id> * _Nonnull {
            return @{};
        };
    }
    return _infoHook;
}

- (NSString * _Nonnull (^)(void))signKeyHook {
    if (!_signKeyHook) {
        _signKeyHook = ^NSString * _Nonnull {
            return @"";
        };
    }
    return _signKeyHook;
}

- (NSArray<NSString *> * _Nonnull (^)(void))signOrderHook {
    if (!_signOrderHook) {
        _signOrderHook = ^NSArray<NSString *> * _Nonnull {
            return @[];
        };
    }
    return _signOrderHook;
}

@end
