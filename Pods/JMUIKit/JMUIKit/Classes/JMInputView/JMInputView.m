//
//  JMInputView.m
//  JMUIKit
//
//  Created by Thief Toki on 2020/8/3.
//

#import "JMInputView.h"

#import "UIView+JMLayout.h"

@implementation JMInputView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUI];
        [self setupUIResponse];
    }
    return self;
}

#pragma mark - setup UI

- (void)setupUI {
    self.backgroundColor = [UIColor colorWithRed:241/255.0 green:242/255.0 blue:246/255.0 alpha:1];
    self.layer.borderColor = [UIColor clearColor].CGColor;
    self.layer.borderWidth = 1;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = MIN(MIN(self.widthJM, self.heightJM)/2, [JMThemeFetchT(JMInputView, corner) floatValue]);
    
    [self addSubview:self.iconImageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.inputTextField];
    
    CGFloat inputOffset;
    if (self.iconImageView.image) {
        inputOffset = 45;
        self.iconImageView.hidden = NO;
        [self.iconImageView jm_layout:^(UIView * _Nonnull make) {
            make.sizeJM = CGSizeMake(44, 44);
            make.leftJM = 0;
            make.centerYJM = self.heightJM/2;
        }];
    } else if (self.titleLabel.text) {
        inputOffset = 80;
        self.titleLabel.hidden = NO;
        [self.titleLabel jm_layout:^(UIView * _Nonnull make) {
            [make sizeToFit];
            make.leftJM = 12;
            make.centerYJM = self.heightJM/2;
        }];
    } else {
        inputOffset = 0;
        self.iconImageView.hidden = YES;
        self.titleLabel.hidden = YES;
    }
    
    [self.inputTextField jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(self.widthJM - inputOffset, 40);
        make.leftJM = inputOffset;
        make.centerYJM = self.heightJM/2;
    }];
}

#pragma mark - setup UI response

- (void)setupUIResponse {
    
}

#pragma mark - protocol

- (void)keyboardPreviewLinkTextFieldBecomeFirstResponder:(JMKeyboardPreviewLinkTextField *)keyboardPreviewLinkTextField {
    self.layer.borderColor = [UIColor colorWithRed:96/255.0 green:116/255.0 blue:255/255.0 alpha:1].CGColor;
}

- (void)keyboardPreviewLinkTextFieldResignFirstResponder:(JMKeyboardPreviewLinkTextField *)keyboardPreviewLinkTextField {
    self.layer.borderColor = [UIColor clearColor].CGColor;
}

#pragma mark - setter

#pragma mark - getter

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeCenter;
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithRed:62/255.0 green:64/255.0 blue:70/255.0 alpha:1.0];
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}

- (JMKeyboardPreviewLinkTextField *)inputTextField {
    if (!_inputTextField) {
        _inputTextField = [[JMKeyboardPreviewLinkTextField alloc] init];
        _inputTextField.textColor = [UIColor colorWithRed:62/255.0 green:64/255.0 blue:70/255.0 alpha:1.0];
        _inputTextField.font = [UIFont systemFontOfSize:14];
        _inputTextField.respondDelegate = self;
    }
    return _inputTextField;
}

- (NSString *)value {
    return self.inputTextField.text;
}

@end
