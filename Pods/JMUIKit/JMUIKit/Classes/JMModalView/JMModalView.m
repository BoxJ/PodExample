//
//  JMModalView.m
//  JMUIKit
//
//  Created by Thief Toki on 2020/8/3.
//

#import "JMModalView.h"

#import "JMGeneralVariable.h"

#import "JMModalStack.h"
#import "JMModalTopView.h"
#import "JMTextField.h"
#import "JMKeyboardPreviewView.h"

#import "UIView+JMLayout.h"
#import "UIWindow+JMExtension.h"

@interface JMModalView ()

@property (nonatomic, strong) UITapGestureRecognizer *contentViewTapGestureRecognizer;

@end

@implementation JMModalView

#pragma mark - stack

- (instancetype)registerStack {
    self.stack = [JMModalStack stackWithRootModaView:self];
    return self;
}

- (void)mask {
    self.contentView.maskView = self.maskView;
}

- (void)unmask {
    self.contentView.maskView = nil;
}

#pragma mark - setup UI

- (void)setupUI {
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    if (! [self.contentView.superview isEqual:self]) {
        [self addSubview:self.contentView];
    }
    self.contentView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    [self.contentView addSubview:self.boardImageView];
    [self.contentView addSubview:self.topView];
    
    [self addSubview:self.keyboardPreviewView];
    [self.keyboardPreviewView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(kScreenWidth, 50);
        make.centerYJM = kScreenWidth/2;
    }];
}

#pragma mark - action

- (void)show {
    if (!self.isShow) {
        self.isShow = YES;
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        [kMainWindow addSubview:self];
        
        self.contentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
        [UIView animateWithDuration:0.15 animations:^{
            self.contentView.transform = CGAffineTransformMakeScale(1.03, 1.03);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.08 animations:^{
                self.contentView.transform = CGAffineTransformMakeScale(0.97, 0.97);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.07 animations:^{
                    self.contentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                } completion:^(BOOL finished) {
                    
                }];
            }];
        }];
    }
}

- (void)show:(JMResponder *)responder {
    self.responder = responder;
    
    [self show];
}

- (void)dismiss:(void(^)(void))completion {
    if (self.isShow) {
        [self endEditing:YES];
        
        [UIView animateWithDuration:0.1f animations:^{
            self.contentView.transform = CGAffineTransformMakeScale(1.04f, 1.04f);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2f animations:^{
                self.contentView.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
                self.alpha = 0;
            } completion:^(BOOL finished){
                [self removeFromSuperview];
                self.isShow = NO;
                self.alpha = 1;
                if (completion) completion();
            }];
        }];
    }
}

- (void)dismiss {
    if (self.stack) {
        [self.stack dismiss];
    } else {
        [self dismiss:^{
            
        }];
    }
}

- (void)dismissSuccess:(NSDictionary *)info {
    if (self.stack) {
        [self.stack dismissSuccess:info];
    } else {
        [self dismiss:^{
            self.responder.success(info);
        }];
    }
}

- (void)dismissFailed:(NSError *)error {
    if (self.stack) {
        [self.stack dismissFailed:error];
    } else {
        [self dismiss:^{
            self.responder.failed(error);
        }];
    }
}

- (void)dismissCancel {
    if (self.stack) {
        [self.stack dismissCancel];
    } else {
        [self dismiss:^{
            self.responder.cancel();
        }];
    }
}

#pragma mark - setup UI response

- (void)setupUIResponse {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangeStatusBarOrientation:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyBoardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyBoardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)didChangeStatusBarOrientation:(NSNotification *)notification{
    [self setupUI];
    
    if ([self.stack.rootModaView isEqual:self]) {
        for (NSInteger i = 1; i < self.stack.modaList.count; i++) {
            JMModalView *modaView = self.stack.modaList[i];
            [self.contentView bringSubviewToFront:modaView];
        }
    }
}

- (void)keyBoardDidShow:(NSNotification *)notification {
    if (!self.hideKeyboardPreviewView && self.keyboardPreviewView.previewTextField.delegate) {
        __block CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        [self.keyboardPreviewView jm_layout:^(UIView * _Nonnull make) {
            make.bottomJM = kScreenHeight - keyboardFrame.size.height;
        }];
        self.keyboardPreviewView.hidden = NO;
    } else {
        self.keyboardPreviewView.hidden = YES;
    }
    
    [self.contentView addGestureRecognizer:self.contentViewTapGestureRecognizer];
}

- (void)keyBoardWillHide:(NSNotification *)notification {
    if (!self.hideKeyboardPreviewView) {
        self.keyboardPreviewView.hidden = YES;
    }
    
    [self.contentView removeGestureRecognizer:self.contentViewTapGestureRecognizer];
}

- (void)contentViewTapped {
    [self endEditing:YES];
}

#pragma mark - protocol

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - setter

- (void)setIsShow:(BOOL)isShow {
    _isShow = isShow;
    
    if ([self.stack.rootModaView isEqual:self]) {
        [self.topView upadteType:JMModalTopType_Logo | JMModalTopType_Close];
    } else {
        [self.topView upadteType:JMModalTopType_GoBack];
    }
}

#pragma mark - getter

- (UITapGestureRecognizer *)contentViewTapGestureRecognizer {
    if (!_contentViewTapGestureRecognizer) {
        _contentViewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                   action:@selector(contentViewTapped)];
    }
    return _contentViewTapGestureRecognizer;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = [UIColor whiteColor];
        _maskView.layer.cornerRadius = self.boardImageView.layer.cornerRadius;
        _maskView.layer.masksToBounds = self.boardImageView.layer.masksToBounds;
    }
    _maskView.frame = self.boardImageView.frame;
    return _maskView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}

- (UIImageView *)boardImageView {
    if (!_boardImageView) {
        _boardImageView = [[UIImageView alloc] init];
        _boardImageView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
        _boardImageView.layer.cornerRadius = MIN(MIN(self.widthJM, self.heightJM)/2, [JMThemeFetchT(JMModalView, corner) floatValue]);
        _boardImageView.layer.masksToBounds = YES;
    }
    return _boardImageView;
}

- (JMModalTopView *)topView {
    if (!_topView) {
        _topView = [[JMModalTopView alloc] init];
        _topView.hidden = YES;
    }
    return _topView;
}

- (JMKeyboardPreviewView *)keyboardPreviewView {
    if (!_keyboardPreviewView) {
        _keyboardPreviewView = [JMKeyboardPreviewView shared];
        _keyboardPreviewView.hidden = YES;
    }
    return _keyboardPreviewView;
}

- (JMResponder *)responder {
    if (!_responder) {
        _responder = [JMResponder success:nil
                                       failed:nil
                                       cancel:nil];
    }
    return _responder;
}

@end
