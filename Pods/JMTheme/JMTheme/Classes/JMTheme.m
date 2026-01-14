//
//  JMTheme.m
//  JMTheme
//
//  Created by ZhengXianda on 10/20/2022.
//  Copyright (c) 2022 ZhengXianda. All rights reserved.
//

#import "JMTheme.h"

@interface JMTheme ()

@property (nonatomic, strong) NSMutableDictionary <NSString *, id>*themeMap;

@end

@implementation JMTheme

#pragma mark - shared

+ (instancetype)shared {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - theme

+ (void)regist:(Class)itemClass theme:(id)theme {
    [JMTheme shared].themeMap[NSStringFromClass(itemClass)] = theme;
}

+ (id)fetch:(Class)itemClass {
    return [JMTheme shared].themeMap[NSStringFromClass(itemClass)];
}

#pragma mark - getter

- (NSMutableDictionary<NSString *,id> *)themeMap {
    if (!_themeMap) {
        _themeMap = [NSMutableDictionary dictionary];
    }
    return _themeMap;
}

@end
