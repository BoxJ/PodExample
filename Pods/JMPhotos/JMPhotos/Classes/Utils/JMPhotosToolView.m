//
//  JMPhotosToolView.m
//  JMAssetPicker
//
//  Created by ZhengXianda on 2022/7/4.
//

#import "JMPhotosToolView.h"

#import <JMUIKit/JMUIKit.h>

@implementation JMPhotosToolView

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
    self.widthJM = kScreenWidth;
    self.heightJM = kSafeAreaBottomHeight + kFunctionBarHeight;
    
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.previewTitleLabel];
    [self.contentView addSubview:self.previewButton];
    [self.contentView addSubview:self.originalStatusDotView];
    [self.contentView addSubview:self.originalTitleLabel];
    [self.contentView addSubview:self.originalSizeLabel];
    [self.contentView addSubview:self.originalButton];
    [self.contentView addSubview:self.finishTitleLabel];
    [self.contentView addSubview:self.finishButton];
    [self.contentView addSubview:self.selectedCountDotView];
    
    [self.contentView jm_layout:^(UIView * _Nonnull make) {
        make.widthJM = self.widthJM;
        make.heightJM = kFunctionBarHeight;
        make.topJM = 0;
        make.centerXJM = self.centerXJM;
    }];
    [self.previewTitleLabel jm_layout:^(UIView * _Nonnull make) {
        [make sizeToFit];
        make.leftJM = 10;
        make.centerYJM = self.contentView.centerYJM;
    }];
    [self.previewButton jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(self.previewTitleLabel.widthJM, self.contentView.heightJM);
        make.leftJM = self.previewTitleLabel.leftJM;
        make.centerYJM = self.previewTitleLabel.centerYJM;
    }];
    [self.originalStatusDotView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(24, 24);
        make.leftJM = self.previewButton.rightJM + 10;
        make.centerYJM = self.contentView.centerYJM;
    }];
    [self.originalTitleLabel jm_layout:^(UIView * _Nonnull make) {
        [make sizeToFit];
        make.leftJM = self.originalStatusDotView.rightJM + 5;
        make.centerYJM = self.originalStatusDotView.centerYJM;
    }];
    [self.originalSizeLabel jm_layout:^(UIView * _Nonnull make) {
        [make sizeToFit];
        make.leftJM = self.originalTitleLabel.rightJM + 5;
        make.centerYJM = self.originalTitleLabel.centerYJM;
    }];
    [self.originalButton jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(self.originalTitleLabel.rightJM - self.originalStatusDotView.leftJM, self.contentView.heightJM);
        make.leftJM = self.originalStatusDotView.leftJM;
        make.centerYJM = self.originalStatusDotView.centerYJM;
    }];
    [self.finishTitleLabel jm_layout:^(UIView * _Nonnull make) {
        [make sizeToFit];
        make.rightJM = self.contentView.rightJM - 10;
        make.centerYJM = self.contentView.centerYJM;
    }];
    [self.finishButton jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(self.finishTitleLabel.widthJM, self.contentView.heightJM);
        make.leftJM = self.finishTitleLabel.leftJM;
        make.centerYJM = self.finishTitleLabel.centerYJM;
    }];
    [self.selectedCountDotView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(24, 24);
        make.rightJM = self.finishTitleLabel.leftJM - 5;
        make.centerYJM = self.finishTitleLabel.centerYJM;
    }];
}

#pragma mark - setup UI response

- (void)setupUIResponse {
    
}

#pragma mark - bind model

- (void)bindModel {
    self.originalStatusDotView.hidden = !self.isAllowOriginal;
    self.originalTitleLabel.hidden = !self.isAllowOriginal;
    self.originalSizeLabel.hidden = !self.isAllowOriginal || self.originalSize.length <= 0;
    self.originalSizeLabel.text = [NSString stringWithFormat:@"(%@)", self.originalSize];
    self.originalButton.hidden = !self.isAllowOriginal;
    
    self.selectedCountDotView.index = self.selectedCount;
    self.finishButton.enabled = self.selectedCount >= 0;
    
    [self setupUI];
}

#pragma mark - protocol

#pragma mark - setter

- (void)setIsAllowOriginal:(BOOL)isAllowOriginal {
    _isAllowOriginal = isAllowOriginal;
    
    [self bindModel];
}

- (void)setOriginalSize:(NSString *)originalSize {
    _originalSize = originalSize;
    
    [self bindModel];
}

- (void)setSelectedCount:(NSUInteger)selectedCount {
    _selectedCount = selectedCount;
    
    [self bindModel];
}

#pragma mark - getter

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}

- (UILabel *)previewTitleLabel {
    if (!_previewTitleLabel) {
        _previewTitleLabel = [[UILabel alloc] init];
        _previewTitleLabel.text = @"预览";
        _previewTitleLabel.textColor = UIColor.blackColor;
        _previewTitleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    }
    return _previewTitleLabel;
}

- (UIButton *)previewButton {
    if (!_previewButton) {
        _previewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _previewButton;
}

- (JMDotView *)originalStatusDotView {
    if (!_originalStatusDotView) {
        _originalStatusDotView = [[JMDotView alloc] init];
    }
    return _originalStatusDotView;
}

- (UIButton *)originalButton {
    if (!_originalButton) {
        _originalButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _originalButton;
}

- (UILabel *)originalTitleLabel {
    if (!_originalTitleLabel) {
        _originalTitleLabel = [[UILabel alloc] init];
        _originalTitleLabel.textColor = UIColor.blackColor;
        _originalTitleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
        _originalTitleLabel.text = @"原图";
    }
    return _originalTitleLabel;
}

- (UILabel *)originalSizeLabel {
    if (!_originalSizeLabel) {
        _originalSizeLabel = [[UILabel alloc] init];
        _originalSizeLabel.textColor = UIColor.blackColor;
        _originalSizeLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    }
    return _originalSizeLabel;
}

- (UILabel *)finishTitleLabel {
    if (!_finishTitleLabel) {
        _finishTitleLabel = [[UILabel alloc] init];
        _finishTitleLabel.text = @"完成";
        _finishTitleLabel.textColor = UIColor.blackColor;
        _finishTitleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    }
    return _finishTitleLabel;
}

- (UIButton *)finishButton {
    if (!_finishButton) {
        _finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _finishButton;
}

- (JMDotView *)selectedCountDotView {
    if (!_selectedCountDotView) {
        _selectedCountDotView = [[JMDotView alloc] init];
    }
    return _selectedCountDotView;
}

@end
