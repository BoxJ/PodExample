//
//  JMWebView.m
//  JMUIKit
//
//  Created by Thief Toki on 2020/9/16.
//

#import "JMWebView.h"

@implementation JMWebView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.UIDelegate = self;
        self.navigationDelegate = self;
    }
    return self;
}

#pragma mark - overrid

- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^)(id, NSError *))completionHandler {
    if ([UIDevice currentDevice].systemVersion.doubleValue == 8) {
        id strongSelf = self;
        
        [super evaluateJavaScript:javaScriptString
                completionHandler:^(id r, NSError *e) {
            [strongSelf title];
            
            if (completionHandler) {
                completionHandler(r,
                                  e);
            }
        }];
    } else {
        [super evaluateJavaScript:javaScriptString
                completionHandler:completionHandler];
    }
}

#pragma mark - protocol

#pragma mark WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURL    *url       = navigationAction.request.URL;
    NSString *urlString = (url) ? url.absoluteString : @"";
    
    if ([urlString hasPrefix:@"https://itunes.apple.com/"] ||
        [urlString hasPrefix:@"itms:"] ||
        [urlString hasPrefix:@"itms-apps:"]) {
        if ([[UIApplication sharedApplication] canOpenURL:navigationAction.request.URL]) {
            if (@available(iOS 10.0, *)) {
                [UIApplication.sharedApplication openURL:navigationAction.request.URL
                                                 options:@{ }
                                       completionHandler:NULL];
            } else {
                [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
            }
        }
        if ([self canGoBack]) {
        } else {
            if ([self.delegate respondsToSelector:@selector(webView:didDismiss:)]) {
                [self.delegate webView:self didDismiss:YES];
            }
        }
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        self.currentURL = [NSURL URLWithString:urlString];
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if ([self.delegate respondsToSelector:@selector(webView:didFinish:)]) {
        [self.delegate webView:self didFinish:YES];
    }
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    [self reload];
}

#pragma mark - setter

#pragma mark - getter

- (JMWKWebViewJavascriptBridge *)bridge {
    if (!_bridge) {
        _bridge = [JMWKWebViewJavascriptBridge bridgeForJMWebView:self];
        [_bridge setJMWebViewDelegate:self];
    }
    return _bridge;
}

@end
