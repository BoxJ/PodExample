//
//  JMToastLoadingView.m
//  JMUIKit
//
//  Created by Thief Toki on 2020/8/4.
//

#import "JMToastLoadingView.h"

#import "UIView+JMLayout.h"

@implementation JMToastLoadingView

- (void)setupBoardView {
    [self.boardView addSubview:self.imageView];
    
    self.boardView.backgroundColor = [UIColor clearColor];
    [self.boardView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(80, 80);
        make.centerXJM = self.contentView.centerXJM;
        make.centerYJM = self.contentView.centerYJM;
    }];
    
    [self.imageView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(80, 80);
        make.centerXJM = self.boardView.widthJM / 2;
        make.centerYJM = self.boardView.heightJM / 2;
    }];
}

#pragma mark - override

- (void)showToast:(NSString *)message {
    [super showToast:message];
    
    if (self.imageView.animationImages.count > 1) {
        [self.imageView startAnimating];
    }
}

- (void)dismiss {
    [self.imageView stopAnimating];
    
    [super dismiss];
}

#pragma mark - getter

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.animationImages = JMThemeFetchT(JMToastLoadingView, loadingAnimationImages);
        _imageView.animationDuration = [JMThemeFetchT(JMToastLoadingView, loadingAnimationDuration) doubleValue];
    }
    return _imageView;
}


@end
