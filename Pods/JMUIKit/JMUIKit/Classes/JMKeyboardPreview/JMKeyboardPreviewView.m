//
//  JMKeyboardPreviewView.m
//  JMUIKit
//
//  Created by Thief Toki on 2020/8/9.
//

#import "JMKeyboardPreviewView.h"

#import "JMGeneralVariable.h"

#import "JMTextField.h"
#import "JMCommonButton.h"

#import "UIView+JMLayout.h"

@interface JMKeyboardPreviewView ()

@property (nonatomic, strong) JMCommonButton *defaultConfirmButton;

@end

@implementation JMKeyboardPreviewView

#pragma mark - shared

+ (instancetype)shared {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark init

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
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor colorWithRed:241/255.0 green:242/255.0 blue:246/255.0 alpha:1].CGColor;
    
    [self addSubview:self.previewTextField];
    [self addSubview:self.confirmButton];
    
    CGFloat confirmButtonWidth = self.confirmButton.widthJM;
    CGFloat confirmButtonSpaceWidth = confirmButtonWidth > 0 ? (12+confirmButtonWidth+12) : 20;
    CGFloat confirmButtonRightMargin = confirmButtonWidth > 0 ? 12 : 20;
    
    [self.previewTextField jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(self.widthJM - 20 - confirmButtonSpaceWidth, 50);
        make.leftJM = 20 + ((kIsSpecialScreen && kIsRightLandscape) ? 44 : 0);
        make.centerYJM = self.heightJM/2;
    }];
    [self.confirmButton jm_layout:^(UIView * _Nonnull make) {
        make.rightJM = self.widthJM - confirmButtonRightMargin - ((kIsSpecialScreen && kIsLeftLandscape) ? 44 : 0);
        make.centerYJM = self.heightJM/2;
    }];
}

#pragma mark - setup UI response

- (void)setupUIResponse {
    if (![self.previewTextField.allTargets containsObject:self]) {
        [self.previewTextField addTarget:self
                                  action:@selector(previewTextFieldEditingChanged)
                        forControlEvents:UIControlEventEditingChanged];
    }
    if (![self.confirmButton.allTargets containsObject:self]) {
        [self.confirmButton addTarget:self
                               action:@selector(confirmButtonTapped)
                     forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)previewTextFieldEditingChanged {
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyboardPreviewView:editingChanged:)]) {
        [self.delegate keyboardPreviewView:self editingChanged:self.previewTextField.text];
    }
}

- (void)confirmButtonTapped {
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyboardPreviewView:confirmButtonTapped:)]) {
        [self.delegate keyboardPreviewView:self confirmButtonTapped:self.confirmButton];
    } else {
        [self endEditing:YES];
    }
}

#pragma mark - protocol

#pragma mark - setter

- (void)setDelegate:(id<JMKeyboardPreviewViewDelegate>)delegate {
    _delegate = delegate;
    
    [self.confirmButton removeFromSuperview];
    if ([delegate respondsToSelector:@selector(confirmButtonForkeyboardPreviewView:)]) {
        self.confirmButton = [delegate confirmButtonForkeyboardPreviewView:self];
        if (!self.confirmButton) {
            self.confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        }
    } else {
        self.confirmButton = self.defaultConfirmButton;
    }
    
    [self setupUI];
    [self setupUIResponse];
}

#pragma mark - getter

- (JMTextField *)previewTextField {
    if (!_previewTextField) {
        _previewTextField = [[JMTextField alloc] init];
        _previewTextField.textColor = [UIColor colorWithWhite:51/255.0 alpha:1];
        _previewTextField.font = [UIFont systemFontOfSize:16];
    }
    return _previewTextField;
}

- (JMCommonButton *)defaultConfirmButton {
    if (!_defaultConfirmButton) {
        _defaultConfirmButton = [JMCommonButton buttonWithType:UIButtonTypeCustom];
        _defaultConfirmButton.sizeJM = CGSizeMake(80, 36);
        _defaultConfirmButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_defaultConfirmButton setTitle:@"下一步" forState:UIControlStateNormal];
    }
    return _defaultConfirmButton;
}

@end
