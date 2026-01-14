//
//  JMToastSuccessView.m
//  JMUIKit
//
//  Created by Thief Toki on 2020/8/4.
//

#import "JMToastSuccessView.h"

#import "UIView+JMLayout.h"

@implementation JMToastSuccessView

- (void)setupBoardView {
    [self.boardView addSubview:self.imageView];
    [self.boardView addSubview:self.messageLabel];
    
    [self.imageView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(46, 34);
    }];
    [self.messageLabel jm_layout:^(UIView * _Nonnull make) {
        [make sizeToFit];
    }];
    
    [self.boardView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(MAX(self.messageLabel.widthJM + 20 * 2, 148),
                                 self.messageLabel.heightJM + (26 + self.imageView.heightJM + 14) + 22);
        make.centerXJM = self.contentView.centerXJM;
        make.centerYJM = self.contentView.centerYJM;
    }];
    
    [self.imageView jm_layout:^(UIView * _Nonnull make) {
        make.topJM = 26;
        make.centerXJM = self.boardView.widthJM / 2;
    }];
    
    [self.messageLabel jm_layout:^(UIView * _Nonnull make) {
        make.bottomJM = self.boardView.heightJM - 22;
        make.centerXJM = self.boardView.widthJM / 2;
    }];
}

#pragma mark - getter

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = JMThemeFetchT(JMToastSuccessView, successImage);
    }
    return _imageView;
}

@end
