//
//  JMWebModalView.h
//  JMUIKit
//
//  Created by xianda.zheng on 02/22/2021.
//  Copyright (c) 2021 xianda.zheng. All rights reserved.
//

#import <JMUIKit/JMModalView.h>

@class JMWebTitleView;
@class JMWebView;

NS_ASSUME_NONNULL_BEGIN

typedef void (^JMWVJBHandler)(NSDictionary *data,
                                  void(^responseCallback)(id responseData));

@interface JMWebModalView : JMModalView

@property (nonatomic, strong) NSString *baseURL;
@property (nonatomic, strong) NSDictionary <NSString *, id>*(^paramHook)(void);
@property (nonatomic, strong) NSDictionary <NSString *, id>*(^themeHook)(void);

#pragma mark - shared

+ (instancetype)shared;

- (void)registerBaseURL:(NSString *)baseURL
              paramHook:(NSDictionary <NSString *, id>*(^)(void))paramHook
              themeHook:(NSDictionary <NSString *, id>*(^)(void))themeHook;

- (instancetype)webWithURL:(NSURL *)URL;

- (void)setupBridge;
- (void)releaseBridge;
- (void)changeTitleViewStatus:(BOOL)isHidden;

- (void)registerHandler:(NSString *)handlerName handler:(JMWVJBHandler)handler;

@end

NS_ASSUME_NONNULL_END
