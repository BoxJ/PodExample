//
//  JMModalView.h
//  JMUIKit
//
//  Created by Thief Toki on 2020/8/3.
//

#import <UIKit/UIKit.h>

#import <JMTheme/JMTheme.h>
#import <JMUtils/JMUtils.h>

NS_ASSUME_NONNULL_BEGIN

JMThemeDeclare(JMModalView, corner);

@class JMModalStack;
@class JMModalTopView;
@class JMKeyboardPreviewView;
@interface JMModalView : UIView

@property (nonatomic, strong, nullable) JMModalStack *stack;
@property (nonatomic, strong) UIView *maskView;

- (instancetype)registerStack;
- (void)mask;
- (void)unmask;

@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, strong) JMResponder *responder;

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *boardImageView;
@property (nonatomic, strong) JMModalTopView *topView;

@property (nonatomic, assign) BOOL hideKeyboardPreviewView;
@property (nonatomic, strong) JMKeyboardPreviewView *keyboardPreviewView;

- (void)setupUI;
- (void)setupUIResponse;

- (void)show;
- (void)show:(JMResponder *)responder;
- (void)dismiss:(void(^)(void))completion;
- (void)dismiss;
- (void)dismissSuccess:(NSDictionary *)info;
- (void)dismissFailed:(NSError *)error;
- (void)dismissCancel;

@end

NS_ASSUME_NONNULL_END
