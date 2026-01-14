//
//  JMKeyboardPreviewLinkTextField.h
//  JMUIKit
//
//  Created by Thief Toki on 2020/8/9.
//

#import <UIKit/UIKit.h>

#import <JMUIKit/JMKeyboardPreviewView.h>

@class JMKeyboardPreviewLinkTextField;

NS_ASSUME_NONNULL_BEGIN

@protocol JMKeyboardPreviewLinkTextFieldDelegate <NSObject>

- (void)keyboardPreviewLinkTextFieldBecomeFirstResponder:(JMKeyboardPreviewLinkTextField *)keyboardPreviewLinkTextField;
- (void)keyboardPreviewLinkTextFieldResignFirstResponder:(JMKeyboardPreviewLinkTextField *)keyboardPreviewLinkTextField;

@end

@interface JMKeyboardPreviewLinkTextField : UITextField <UITextFieldDelegate>

@property (nonatomic, weak) id<JMKeyboardPreviewLinkTextFieldDelegate> respondDelegate;

@end

NS_ASSUME_NONNULL_END
