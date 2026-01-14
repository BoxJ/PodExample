//
//  JMWebView.h
//  JMUIKit
//
//  Created by Thief Toki on 2020/9/16.
//

#import <WebKit/WebKit.h>

#import "JMWKWebViewJavascriptBridge.h"

NS_ASSUME_NONNULL_BEGIN

@class JMWebView;

@protocol JMWKNavigationDelegate <WKNavigationDelegate>

@required

- (void)webView:(JMWebView *)webView didFinish:(BOOL)finish;
- (void)webView:(JMWebView *)webView didDismiss:(BOOL)dismiss;

@end

@interface JMWebView : WKWebView <WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, weak) id<JMWKNavigationDelegate> delegate;

@property (nonatomic, strong) JMWKWebViewJavascriptBridge *bridge;

@property (nonatomic, strong) NSURL *currentURL;

@end

NS_ASSUME_NONNULL_END
