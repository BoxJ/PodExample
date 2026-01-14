//
//  JMCompositeTitleView.m
//  JMUIKit
//
//  Created by Thief Toki on 2020/8/7.
//

#import "JMCompositeTitleView.h"

#import "UIView+JMLayout.h"

@interface JMCompositeTitleView ()

@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGSize textSize;

@end

@implementation JMCompositeTitleView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

#pragma mark - setup UI

- (void)setupUI {
    [self addSubview:self.titleLabel];
    [self addSubview:self.subtitleLabel];
    
    [self.titleLabel jm_layout:^(UIView * _Nonnull make) {
        [make sizeToFit];
        make.topJM = 0;
        make.centerXJM = self.widthJM/2;
    }];
    [self.subtitleLabel jm_layout:^(UIView * _Nonnull make) {
        [make sizeToFit];
        make.topJM = self.titleLabel.bottomJM + self.space;
        make.centerXJM = self.widthJM/2;
    }];
}

- (void)sizeToFit {
    self.size = self.sizeJM;
    self.titleLabel.sizeJM = self.size;
    self.subtitleLabel.sizeJM = self.size;
    
    [self.titleLabel sizeToFit];
    [self.subtitleLabel sizeToFit];
    
    self.textSize = CGSizeMake(MAX(self.titleLabel.widthJM, self.subtitleLabel.widthJM),
                               self.titleLabel.heightJM + self.space + self.subtitleLabel.heightJM);
    
    self.widthJM = self.size.width;
    self.heightJM = self.textSize.height;
}

#pragma mark - protocol

#pragma mark - setter

#pragma mark - getter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor colorWithWhite:51/255.0 alpha:1];
        _titleLabel.font = JMThemeFetchT(JMCompositeTitleView, titleFont);
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel {
    if (!_subtitleLabel) {
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.numberOfLines = 0;
        _subtitleLabel.textAlignment = NSTextAlignmentCenter;
        _subtitleLabel.textColor = [UIColor colorWithWhite:102/255.0 alpha:1];
        _subtitleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _subtitleLabel;
}

@end
