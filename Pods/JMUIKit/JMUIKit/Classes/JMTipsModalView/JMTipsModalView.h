//
//  JMTipsModalView.h
//  JMUIKit
//
//  Created by Thief Toki on 2020/8/12.
//

#import <JMUIKit/JMModalView.h>

#import <JMTheme/JMTheme.h>

NS_ASSUME_NONNULL_BEGIN

JMThemeDeclare(JMTipsModalView, cancelButtonTitleColor);

@interface JMTipsModalView : JMModalView <UITextViewDelegate>

/// 生成一个提示框
/// @param title 标题
/// @param message 内容
/// @param confirmTitle 确认按钮标题
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                 confirmTitle:(NSString *)confirmTitle;

/// 生成一个提示框
/// @param title 标题
/// @param message 内容
/// @param confirmTitle 确认按钮标题
/// @param cancelTitle 取消按钮标题
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                 confirmTitle:(NSString *)confirmTitle
                  cancelTitle:(NSString *)cancelTitle;

/// 生成一个提示框
/// @param title 标题
/// @param titleImage 图片标题， 赋值后会覆盖title
/// @param message 内容
/// @param attributedMessage 富文本内容， 赋值后会覆盖message
/// @param confirmTitle 确认按钮标题
/// @param cancelTitle 取消按钮标题
- (instancetype)initWithTitle:(NSString * _Nullable)title
                   titleImage:(UIImage * _Nullable)titleImage
                      message:(NSString * _Nullable)message
            attributedMessage:(NSAttributedString * _Nullable)attributedMessage
                 confirmTitle:(NSString * _Nullable)confirmTitle
                  cancelTitle:(NSString * _Nullable)cancelTitle;

- (instancetype)cancelEnableDelay:(NSTimeInterval)cancelEnableDelay;

@end

NS_ASSUME_NONNULL_END
