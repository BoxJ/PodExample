//
//  JMWebModalView.m
//  JMUIKit
//
//  Created by xianda.zheng on 02/22/2021.
//  Copyright (c) 2021 xianda.zheng. All rights reserved.
//

#import "JMWebModalView.h"

#import "JMGeneralVariable.h"

#import "JMWebTitleView.h"
#import "JMWebView.h"

#import "UIView+JMLayout.h"
#import "UIWindow+JMExtension.h"

#define kJMBridge_Params @"setWebRequestParams"
#define kJMBridge_Theme @"setWebResourceTheme"

@interface JMWebModalView () <JMWKNavigationDelegate>

@property (nonatomic, strong) NSURL *URL;

@property (nonatomic, strong) JMWebTitleView *titleView;
@property (nonatomic, strong) JMWebView *webView;

@end

@implementation JMWebModalView

#pragma mark - shared

+ (instancetype)shared {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)registerBaseURL:(NSString *)baseURL
              paramHook:(NSDictionary <NSString *, id>*(^)(void))paramHook
              themeHook:(NSDictionary <NSString *, id>*(^)(void))themeHook {
    self.baseURL = baseURL;
    self.paramHook = paramHook;
    self.themeHook = themeHook;
}

- (instancetype)webWithURL:(NSURL *)URL {
    self.URL = URL;
    self.hideKeyboardPreviewView = YES;
    
    [self setupUI];
    [self setupUIResponse];
    
    return self;
}

#pragma mark - setup UI

- (void)setupUI {
    [super setupUI];
    
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    [self.contentView addSubview:self.titleView];
    if (![self.webView.superview isEqual:self.contentView]) {
        [self.contentView addSubview:self.webView];
    }
    
    [self.titleView jm_layout:^(UIView * _Nonnull make) {
        make.topJM = 0;
        make.centerXJM = self.widthJM / 2;
    }];
    [self.webView jm_layout:^(UIView * _Nonnull make) {
        if (self.titleView.hidden) {
            make.sizeJM = CGSizeMake(self.widthJM, self.heightJM);
            make.topJM = self.titleView.topJM;
        } else {
            make.sizeJM = CGSizeMake(self.widthJM, self.heightJM - self.titleView.heightJM);
            make.topJM = self.titleView.bottomJM;
        }
    }];
}

#pragma mark - setup UI response

- (void)setupUIResponse {
    [super setupUIResponse];
    
    [self.titleView.goBackButton addTarget:self
                                    action:@selector(goBackButtonTapped)
                          forControlEvents:UIControlEventTouchUpInside];
}

- (void)goBackButtonTapped {
    if (self.webView.canGoBack) {
        [self.webView goBack];
    } else {
        [self dismissCancel];
    }
}

#pragma mark - action

- (void)registerHandler:(NSString *)handlerName handler:(JMWVJBHandler)handler {
    __weak typeof(self) weakSelf = self;
    [self.webView.bridge registerHandler:handlerName
                         handler:^(id data, WVJBResponseCallback responseCallback) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        BOOL isFriendly = [strongSelf.webView.currentURL.absoluteString hasPrefix:self.baseURL];
        NSDictionary *info = [NSDictionary dictionaryWithJsonString:data];
        isFriendly = YES;
        if (isFriendly && handler) {
            handler(info, responseCallback);
        }
    }];
}

- (void)setupBridge {
    __weak typeof(self) weakSelf = self;
    [self registerHandler:kJMBridge_Params
                  handler:^(NSDictionary * _Nonnull data,
                            void (^ _Nonnull responseCallback)(id _Nonnull)) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf paramsWithCallback:responseCallback];
    }];
    [self registerHandler:kJMBridge_Theme
                  handler:^(NSDictionary * _Nonnull data,
                            void (^ _Nonnull responseCallback)(id _Nonnull)) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf themeWithCallback:responseCallback];
    }];
}

- (void)releaseBridge {
    [self.webView.bridge clearHandler];
}

- (void)changeTitleViewStatus:(BOOL)isHidden {
    self.titleView.hidden = isHidden;
    [self setupUI];
}

- (void)show {
    if (!self.isShow) {
        self.isShow = YES;
        [self executeAllSelector:@selector(setupBridge)];
        [kMainWindow addSubview:self];
    }
}

- (void)loadFinish {
    self.titleView.titleLabel.text = self.webView.title;
    [self setupUI];
}

- (void)dismiss:(void(^)(void))completion {
    if (self.isShow) {
        [self endEditing:YES];
        
        self.isShow = NO;
        [self releaseBridge];
        [self removeFromSuperview];
        
        if (completion) completion();
    }
}

- (void)paramsWithCallback:(void (^)(id))responseCallback {
    if (responseCallback) {
        NSDictionary *param;
        if (self.paramHook) {
            param = self.paramHook() ?: @{};
        } else {
            param = @{};
        }
        responseCallback(param);
    }
}

- (void)themeWithCallback:(void (^)(id))responseCallback {
    if (responseCallback) {
        NSDictionary *theme;
        if (self.themeHook) {
            theme = self.themeHook() ?: @{};
        } else {
            theme = @{};
        }
        responseCallback(theme);
    }
}

#pragma mark - protocol

#pragma mark JMWKNavigationDelegate

- (void)webView:(JMWebView *)webView didFinish:(BOOL)finish {
    [self loadFinish];
}

- (void)webView:(JMWebView *)webView didDismiss:(BOOL)dismiss {
    [self dismissCancel];
}

#pragma mark - setter

#pragma mark - getter

- (JMWebTitleView *)titleView {
    if (!_titleView) {
        _titleView = [[JMWebTitleView alloc] init];
    }
    return _titleView;
}

- (JMWebView *)webView {
    if (!_webView) {
        _webView = [[JMWebView alloc] initWithFrame:CGRectZero
                                      configuration:[[WKWebViewConfiguration alloc] init]];
        _webView.delegate = self;
        if (@available(iOS 11.0, *)) {
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        NSURLRequest * request = [NSURLRequest requestWithURL:self.URL
                                                  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                              timeoutInterval:30];
        [_webView loadRequest:request];
    }
    return _webView;
}

@end
