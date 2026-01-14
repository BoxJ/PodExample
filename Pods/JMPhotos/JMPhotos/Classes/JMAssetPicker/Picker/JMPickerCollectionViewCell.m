//
//  JMPickerCollectionViewCell.m
//  JMAssetPicker
//
//  Created by ZhengXianda on 2022/6/15.
//

#import "JMPickerCollectionViewCell.h"

#import <JMUIKit/JMUIKit.h>

#import "JMPhotosTimeView.h"
#import "JMAssetPickerCore.h"

#import "PHAsset+JMAssetPicker.h"
#import "PHAsset+JMAssetPickerCore.h"

@interface JMPickerCollectionViewCellModel ()

@property (nonatomic, weak) JMCollectionViewCell *collectionViewCell;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation JMPickerCollectionViewCellModel

- (instancetype)initWithAsset:(PHAsset *)asset {
    self = [super init];
    if (self) {
        self.cls = [JMPickerCollectionViewCell class];
        
        self.asset = asset;
        
        __weak typeof(self) weakSelf = self;
        self.reload = ^(NSIndexPath * _Nonnull indexPath) {
            [weakSelf.collectionViewCell bindModel];
        };
    }
    return self;
}

- (JMCollectionViewCellEvent)selectedAction {
    if (!_selectedAction) {
        _selectedAction = ^(NSIndexPath * indexPath) { };
    }
    return _selectedAction;
}

@end

@interface JMPickerCollectionViewCell ()

@property (nonatomic, strong) JMPickerCollectionViewCellModel *model;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) JMDotView *dotView;
@property (nonatomic, strong) UIButton *selectButton;
@property (nonatomic, strong) JMPhotosTimeView *timeView;
@property (nonatomic, strong) UIView *freezeView;
@property (nonatomic, strong) UILabel *tagLabel;

@end

@implementation JMPickerCollectionViewCell

- (void)selectedAction {
    if (self.model.selectedAction) {
        self.model.selectedAction(self.model.indexPath);
    }
}

#pragma mark - setup UI

- (void)setupUI {
    self.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.dotView];
    [self.contentView addSubview:self.selectButton];
    [self.contentView addSubview:self.timeView];
    [self.contentView addSubview:self.freezeView];
    [self.contentView addSubview:self.tagLabel];
    
    [self.imageView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = self.contentView.sizeJM;
        make.centerXJM = self.contentView.centerXJM;
        make.centerYJM = self.contentView.centerYJM;
    }];
    [self.dotView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(self.contentView.widthJM * 0.25, self.contentView.heightJM * 0.25);
        make.topJM = self.contentView.topJM + self.sizeJM.height * 0.05;
        make.rightJM = self.contentView.rightJM - self.sizeJM.width * 0.05;
    }];
    [self.selectButton jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(self.contentView.widthJM * 0.5, self.contentView.heightJM * 0.5);
        make.topJM = self.contentView.topJM;
        make.rightJM = self.contentView.rightJM;
    }];
    [self.timeView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(self.contentView.widthJM, self.contentView.heightJM * 0.2);
        make.centerXJM = self.contentView.centerXJM;
        make.bottomJM = self.contentView.bottomJM;
    }];
    [self.freezeView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = self.contentView.sizeJM;
        make.centerXJM = self.contentView.centerXJM;
        make.centerYJM = self.contentView.centerYJM;
    }];
    [self.tagLabel jm_layout:^(UIView * _Nonnull make) {
        [make sizeToFit];
        make.leftJM = 0;
        make.bottomJM = self.contentView.bottomJM;
    }];
}

#pragma mark - setup UI response

- (void)setupUIResponse {
    [self.selectButton addTarget:self
                          action:@selector(selectButtonTapped)
                forControlEvents:UIControlEventTouchUpInside];
}

- (void)selectButtonTapped {
    [self selectedAction];
}

#pragma mark - bind model

- (void)bindModel {
    if (self.model.asset.jmipposter) {
        self.imageView.image = self.model.asset.jmipposter;
    } else {
        __weak typeof(self) weakSelf = self;
        __block NSString *identifier = self.model.asset.localIdentifier;
        [self.model.asset jmip_posterCompletion:^(UIImage * _Nonnull image) {
            if ([weakSelf.model.asset.localIdentifier isEqualToString:identifier]) {
                weakSelf.imageView.image = image;
            }
        }];
    }
    
    self.dotView.idleImageView.image = self.model.asset.jmipcore.pickerUnselectedImage;
    self.dotView.activeImageView.image = self.model.asset.jmipcore.pickerSelectedImage;
    self.dotView.index = self.model.asset.selectedIndex;
    
    self.timeView.iconImageView.image = self.model.asset.jmipcore.pickerVideoImage;
    self.timeView.time = self.model.asset.duration;
    
    if (self.model.asset.selectingCeiling || self.model.asset.selectingIncompatible) {
        self.freezeView.hidden = NO;
    } else {
        self.freezeView.hidden = YES;
    }
    
    self.tagLabel.hidden = YES;
    switch (self.model.asset.mediaType) {
        case PHAssetMediaTypeImage: {
            switch (self.model.asset.imageType) {
                case PHAssetImageTypeGif: {
                    self.tagLabel.hidden = NO;
                    self.tagLabel.text = @"GIF";
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    
    [self setupUI];
}

#pragma mark - protocol

#pragma mark - setter

#pragma mark - getter

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (JMDotView *)dotView {
    if (!_dotView) {
        _dotView = [[JMDotView alloc] init];
    }
    return _dotView;
}

- (UIButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _selectButton;
}

- (JMPhotosTimeView *)timeView {
    if (!_timeView) {
        _timeView = [[JMPhotosTimeView alloc] init];
    }
    return _timeView;
}

- (UIView *)freezeView {
    if (!_freezeView) {
        _freezeView = [[UIView alloc] init];
        _freezeView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
        _freezeView.hidden = YES;
    }
    return _freezeView;
}

- (UILabel *)tagLabel {
    if (!_tagLabel) {
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];
        _tagLabel.textColor = [UIColor colorWithHexString:@"#FFFFFFFF"];
        _tagLabel.backgroundColor = [UIColor colorWithHexString:@"#B0000000"];
    }
    return _tagLabel;
}

@end
