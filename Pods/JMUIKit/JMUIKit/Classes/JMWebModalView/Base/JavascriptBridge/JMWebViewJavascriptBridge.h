//
//  JMWebViewJavascriptBridge.h
//  JMUIKit
//
//  Created by Marcus Westin on 6/14/13.
//  Copyright (c) 2013 Marcus Westin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JMUIKit/JMWebViewJavascriptBridgeBase.h>

#if (__MAC_OS_X_VERSION_MAX_ALLOWED > __MAC_10_9 || __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_7_1)
#define supportsJMWKWebView
#endif

#if defined supportsJMWKWebView
#import <WebKit/WebKit.h>
#endif

#ifndef supportsJMWKWebView //不支持WKWebView才会使用

#if defined __MAC_OS_X_VERSION_MAX_ALLOWED
    #define WVJB_PLATFORM_OSX
    #define WVJB_WEBVIEW_TYPE JMWebView
    #define WVJB_WEBVIEW_DELEGATE_TYPE NSObject<JMWebViewJavascriptBridgeBaseDelegate>
    #define WVJB_WEBVIEW_DELEGATE_INTERFACE NSObject<JMWebViewJavascriptBridgeBaseDelegate, WebPolicyDelegate>
#elif defined __IPHONE_OS_VERSION_MAX_ALLOWED
    #import <UIKit/UIJMWebView.h>
    #define WVJB_PLATFORM_IOS
    #define WVJB_WEBVIEW_TYPE UIJMWebView
    #define WVJB_WEBVIEW_DELEGATE_TYPE NSObject<UIJMWebViewDelegate>
    #define WVJB_WEBVIEW_DELEGATE_INTERFACE NSObject<UIJMWebViewDelegate, JMWebViewJavascriptBridgeBaseDelegate>
#endif

@interface JMWebViewJavascriptBridge : WVJB_WEBVIEW_DELEGATE_INTERFACE


+ (instancetype)bridgeForJMWebView:(id)webView;
+ (instancetype)bridge:(id)webView;

+ (void)enableLogging;
+ (void)setLogMaxLength:(int)length;

- (void)registerHandler:(NSString*)handlerName handler:(WVJBHandler)handler;
- (void)removeHandler:(NSString*)handlerName;
- (void)callHandler:(NSString*)handlerName;
- (void)callHandler:(NSString*)handlerName data:(id)data;
- (void)callHandler:(NSString*)handlerName data:(id)data responseCallback:(WVJBResponseCallback)responseCallback;
- (void)setJMWebViewDelegate:(id)webViewDelegate;
- (void)disableJavscriptAlertBoxSafetyTimeout;

@end

#endif
