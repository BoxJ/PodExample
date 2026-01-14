//
//  JMKeyboardPreviewView.h
//  JMUIKit
//
//  Created by Thief Toki on 2020/8/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JMKeyboardPreviewView;
@protocol JMKeyboardPreviewViewDelegate <NSObject>

@optional
- (UIButton *)confirmButtonForkeyboardPreviewView:(JMKeyboardPreviewView *)keyboardPreviewView;

- (void)keyboardPreviewView:(JMKeyboardPreviewView *)keyboardPreviewView editingChanged:(NSString *)string;
- (void)keyboardPreviewView:(JMKeyboardPreviewView *)keyboardPreviewView confirmButtonTapped:(UIButton *)confirmButton;

@end

@class JMTextField;
@interface JMKeyboardPreviewView : UIView

+ (instancetype)shared;

@property (nonatomic, weak) id<JMKeyboardPreviewViewDelegate> delegate;

@property (nonatomic, strong) JMTextField *previewTextField;
@property (nonatomic, strong) UIButton *confirmButton;

@end

NS_ASSUME_NONNULL_END
