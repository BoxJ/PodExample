//
//  JMKeyboardPreviewLinkTextField.m
//  JMUIKit
//
//  Created by Thief Toki on 2020/8/9.
//

#import "JMKeyboardPreviewLinkTextField.h"

#import "JMTextField.h"

@protocol JMKeyboardPreviewViewPropertyInterfaceProtocol <NSObject>

- (JMKeyboardPreviewView *)keyboardPreviewView;

@end

@implementation JMKeyboardPreviewLinkTextField 

- (BOOL)becomeFirstResponder {
    JMTextField *previewTextField = [JMKeyboardPreviewView shared].previewTextField;
     
    @try {
        if (previewTextField.delegate
            && ![previewTextField.delegate isEqual:self]
            && [previewTextField.delegate respondsToSelector:@selector(resignFirstResponder)]) {
            [previewTextField.delegate performSelector:@selector(resignFirstResponder)];
        }
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
    previewTextField.text = self.text;
    previewTextField.placeholder = self.placeholder;
    previewTextField.attributedPlaceholder = self.attributedPlaceholder;
    previewTextField.delegate = self;
    previewTextField.keyboardType = self.keyboardType;
    if (@available(iOS 10.0, *)) {
        previewTextField.textContentType = self.textContentType;
    }
    previewTextField.clearButtonMode = self.clearButtonMode;
    [previewTextField becomeFirstResponder];
    
    UIView *superView = self.superview;
    while (superView) {
        if ([superView conformsToProtocol:@protocol(JMKeyboardPreviewViewDelegate)]) {
            [JMKeyboardPreviewView shared].delegate = (id<JMKeyboardPreviewViewDelegate>)superView;
            break;
        } else {
            superView = superView.superview;
        }
    }
    
    superView = self.superview;
    while (superView) {
        if ([superView respondsToSelector:@selector(keyboardPreviewView)]) {
            [superView addSubview:[JMKeyboardPreviewView shared]];
            break;
        } else {
            superView = superView.superview;
        }
    }
    
    if (self.respondDelegate && [self.respondDelegate respondsToSelector:@selector(keyboardPreviewLinkTextFieldBecomeFirstResponder:)]) {
        [self.respondDelegate keyboardPreviewLinkTextFieldBecomeFirstResponder:self];
    }
    return false;
}

- (BOOL)resignFirstResponder {
    JMTextField *previewTextField = [JMKeyboardPreviewView shared].previewTextField;
    
    previewTextField.text = nil;
    previewTextField.placeholder = nil;
    previewTextField.attributedPlaceholder = nil;
    previewTextField.delegate = nil;
    previewTextField.keyboardType = UIKeyboardTypeDefault;
    previewTextField.clearButtonMode = UITextFieldViewModeNever;
    [previewTextField resignFirstResponder];
    
    if (self.respondDelegate && [self.respondDelegate respondsToSelector:@selector(keyboardPreviewLinkTextFieldResignFirstResponder:)]) {
        [self.respondDelegate keyboardPreviewLinkTextFieldResignFirstResponder:self];
    }
    return false;
}

#pragma mark - protocol

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldShouldClear:)]) {
        BOOL isShould = [self.delegate textFieldShouldClear:textField];
        if (isShould) {
            self.text = @"";
        }
        return isShould;
    } else {
        self.text = @"";
        return YES;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (self.delegate && [self.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        BOOL isShould = [self.delegate textField:self shouldChangeCharactersInRange:range replacementString:string];
        if (isShould) {
            NSString *inputString = [textField.text stringByReplacingCharactersInRange:range withString:string];
            self.text = inputString;
        }
        return isShould;
    } else {
        NSString *inputString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        self.text = inputString;
        return YES;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [self.delegate textFieldDidEndEditing:textField];
    }
    [self resignFirstResponder];
}

@end
