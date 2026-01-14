//
//  UIViewController+JMExtension.h
//  JMUIKit
//
//  Created by Thief Toki on 2021/3/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (JMExtension)

+ (UIViewController *)rootViewController;
- (UIViewController *)currentViewController;
- (UIAlertController *)showAlertWithTitle:(NSString *)title message:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
