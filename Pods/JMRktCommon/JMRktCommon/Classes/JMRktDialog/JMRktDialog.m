//
//  JMRktDialog.m
//  JMRktCommon
//
//  Created by Thief Toki on 2020/10/9.
//

#import "JMRktDialog.h"

#import <JMUIKit/JMUIKit.h>

#import "NSError+JMRktExtension.h"

@implementation JMRktDialog

#pragma mark - shared

+ (instancetype)shared {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JMRktDialog alloc] init];
    });
    return instance;
}

#pragma mark - Error

+ (void)showError:(NSError *)error responder:(JMResponder *)responder {
    NSString *message = error.htmlMessage.length > 0 ? error.htmlMessage : error.message;
    NSDictionary *messageStyle = error.messageStyle;
    
    NSString *buttonName = messageStyle[@"buttonName"];
    NSString *messageTitle = messageStyle[@"messageTitle"];
    JMRktErrorMessageStyleType messageType = (JMRktErrorMessageStyleType)[messageStyle[@"messageType"] integerValue];
    
    [JMToast dismissToast];
    switch (messageType) {
        case JMRktErrorMessageStyleType_None: {
            [JMToast showToast:message duartion:3.5];
        }
            break;
        case JMRktErrorMessageStyleType_Short: {
            [JMToast showToast:message duartion:2];
        }
            break;
        case JMRktErrorMessageStyleType_Long: {
            
        }
            break;
        case JMRktErrorMessageStyleType_Alert: {
            [[[JMTipsModalView alloc] initWithTitle:@""
                                           message:message
                                      confirmTitle:buttonName]
             show:responder];
        }
            break;
        case JMRktErrorMessageStyleType_AlertTitle: {
            [[[JMTipsModalView alloc] initWithTitle:messageTitle
                                           message:message
                                      confirmTitle:buttonName]
             show:responder];
        }
            break;
        case JMRktErrorMessageStyleType_AlertTitleChoice: {
            [[[JMTipsModalView alloc] initWithTitle:messageTitle
                                           message:message
                                      confirmTitle:buttonName
                                       cancelTitle:@"取消"]
             show:responder];
        }
            break;
    }

}

+ (void)showError:(NSError *)error {
    NSDictionary *messageStyle = error.messageStyle;
    
    NSString *page = messageStyle[@"page"];
    
    JMResponder *responder = [JMResponder success:^(NSDictionary *info) {
        if (page.length > 0) {
            [[[[JMWebModalView alloc] init] webWithURL:[NSURL URLWithString:page]] show];
        }
    }];
    
    [JMRktDialog showError:error responder:responder];
}

@end
