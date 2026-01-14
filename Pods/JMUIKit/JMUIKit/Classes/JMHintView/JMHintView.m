//
//  JMHintView.m
//  JMUIKit
//
//  Created by Thief Toki on 2020/8/8.
//

#import "JMHintView.h"

#import "JMGeneralVariable.h"

#import "UIView+JMLayout.h"
#import "UIWindow+JMExtension.h"

@implementation JMHintView

#pragma mark - setup UI

- (void)setupUI {
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    [self addSubview:self.contentView];
    [self.contentView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(self.widthJM, 55 + ((kIsSpecialScreen && !kIsLandscape) ? 34 : 0));
        make.centerXJM = self.widthJM/2;
        make.bottomJM = self.heightJM;
    }];
}

#pragma mark - setup UI response

- (void)setupUIResponse {
    
}

#pragma mark - action

- (void)show {
    if (!self.isShow) {
        self.isShow = YES;
        [kMainWindow addSubview:self];
    }
}

- (void)show:(JMResponder *)responder {
    self.responder = responder;
    
    [self show];
}

- (void)dismiss:(void(^)(void))completion {
    if (self.isShow) {
        [UIView animateWithDuration:0.5 animations:^{
            self.contentView.bottomJM += self.contentView.heightJM;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            self.isShow = NO;
            if (completion) completion();
        }];
    }
}

- (void)dismiss {
    [self dismiss:nil];
}

- (void)dismissSuccess:(NSDictionary *)info {
    [self dismiss:^{
        self.responder.success(info);
    }];
}

- (void)dismissFailed:(NSError *)error {
    [self dismiss:^{
        self.responder.failed(error);
    }];
}

- (void)dismissCancel {
    [self dismiss:^{
        self.responder.cancel();
    }];
}

#pragma mark - protocol

#pragma mark - setter

#pragma mark - getter

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

@end
