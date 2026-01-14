//
//  JMDotView.m
//  JMUIKit
//
//  Created by ZhengXianda on 2022/6/27.
//

#import "JMDotView.h"

#import "UIView+JMLayout.h"

@implementation JMDotView

#pragma mark - init

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupUI];
        [self setupUIResponse];
        [self bindModel];
    }
    return self;
}

#pragma mark - live cycle

#pragma mark - action

#pragma mark - setup UI

- (void)setupUI {
    [self addSubview:self.idleImageView];
    [self addSubview:self.activeImageView];
    [self addSubview:self.indexLabel];
    
    [self.idleImageView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = self.sizeJM;
        make.topJM = 0;
        make.leftJM = 0;
    }];
    [self.activeImageView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = self.sizeJM;
        make.topJM = 0;
        make.leftJM = 0;
    }];
    [self.indexLabel jm_layout:^(UIView * _Nonnull make) {
        [make sizeToFit];
        make.centerXJM = self.centerXJM - self.leftJM;
        make.centerYJM = self.centerYJM - self.topJM;
    }];
}

#pragma mark - setup UI response

- (void)setupUIResponse {
    
}

#pragma mark - bind model

- (void)bindModel {
    self.idleImageView.hidden = self.isActive;
    self.activeImageView.hidden = !self.isActive;
    self.indexLabel.text = [NSString stringWithFormat:@"%@", self.index > 0 ? @(self.index) : @""];
    
    [self setupUI];
}

#pragma mark - protocol

#pragma mark - setter

- (void)setActive:(BOOL)active {
    _active = active;
    
    [self bindModel];
}

- (void)setIndex:(NSUInteger)index {
    _index = index;
    _active = _index > 0;
    
    [self bindModel];
}

#pragma mark - getter

- (UIImageView *)idleImageView {
    if (!_idleImageView) {
        _idleImageView = [[UIImageView alloc] init];
        _idleImageView.contentMode = UIViewContentModeScaleAspectFill;
        _idleImageView.clipsToBounds = YES;
    }
    return _idleImageView;
}

- (UIImageView *)activeImageView {
    if (!_activeImageView) {
        _activeImageView = [[UIImageView alloc] init];
        _activeImageView.contentMode = UIViewContentModeScaleAspectFill;
        _activeImageView.clipsToBounds = YES;
    }
    return _activeImageView;
}

- (UILabel *)indexLabel {
    if (!_indexLabel) {
        _indexLabel = [[UILabel alloc] init];
        _indexLabel.font = [UIFont systemFontOfSize:14];
        _indexLabel.adjustsFontSizeToFitWidth = YES;
        _indexLabel.textColor = [UIColor whiteColor];
        _indexLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _indexLabel;
}

@end
