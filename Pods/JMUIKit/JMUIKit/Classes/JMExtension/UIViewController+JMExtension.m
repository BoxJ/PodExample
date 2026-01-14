//
//  UIViewController+JMExtension.m
//  JMUIKit
//
//  Created by Thief Toki on 2021/3/16.
//

#import "UIViewController+JMExtension.h"

#import "UIWindow+JMExtension.h"

@implementation UIViewController (JMExtension)

+ (UIViewController *)rootViewController {
    return [UIWindow mainWindow].rootViewController;
}

- (UIViewController *)currentViewController {
    UIViewController *root = self;
    
    while (root.presentedViewController) {
        root = root.presentedViewController;
    }
    
    UIViewController *current;
    if ([root isKindOfClass:[UITabBarController class]]) {
        current = [[(UITabBarController *)root selectedViewController] currentViewController];
    } else if ([root isKindOfClass:[UINavigationController class]]) {
        current = [[(UINavigationController *)root visibleViewController] currentViewController];
    } else {
        current = root;
    }
    
    return current;
}

- (UIAlertController *)showAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *acceptAction = [UIAlertAction actionWithTitle:@"确定"
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil];
    [alertController addAction:acceptAction];
    [self presentViewController:alertController animated:YES completion:nil];
    return alertController;
}

@end
