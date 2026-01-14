//
//  JMBoomSubmitDetailPlayerItemCell.m
//  JMBoomSubmitBusiness
//
//  Created by Thief Toki on 2021/3/17.
//

#import "JMBoomSubmitDetailPlayerItemCell.h"

#import <JMUIKit/JMUIKit.h>
#import <JMBoomSDKBase/JMBoomSDKBase.h>

@implementation JMBoomSubmitDetailPlayerItemCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self setupUI];
        [self setupUIResponse];
        [self bindModel];
    }
    return self;
}

#pragma mark - bind model

- (void)bindModel {
    
}

#pragma mark - setup UI

- (void)setupUI {
    [self.contentView addSubview:self.imageView];
    [self.imageView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = self.contentView.sizeJM;
        make.center = self.contentView.center;
    }];
}

#pragma mark - setup UI response

- (void)setupUIResponse {
    
}

#pragma mark - protocol

#pragma mark - setter

#pragma mark - getter

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
        _imageView.layer.cornerRadius = [[[JMBoomSDKResource shared] resourceWithName:JMBRNCorner] floatValue];
        _imageView.layer.masksToBounds = YES;
    }
    return _imageView;
}

@end
