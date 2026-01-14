//
//  JMInputView.h
//  JMUIKit
//
//  Created by Thief Toki on 2020/8/3.
//

#import <UIKit/UIKit.h>

#import <JMTheme/JMTheme.h>
#import <JMUIKit/JMKeyboardPreviewLinkTextField.h>

NS_ASSUME_NONNULL_BEGIN

JMThemeDeclare(JMInputView, corner);

@interface JMInputView : UIView <JMKeyboardPreviewLinkTextFieldDelegate>

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) JMKeyboardPreviewLinkTextField *inputTextField;

- (NSString *)value;

@end

NS_ASSUME_NONNULL_END
