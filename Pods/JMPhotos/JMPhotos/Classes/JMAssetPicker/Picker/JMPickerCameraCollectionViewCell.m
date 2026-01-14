//
//  JMPickerCameraCollectionViewCell.m
//  JMAssetPicker
//
//  Created by ZhengXianda on 2022/6/23.
//

#import "JMPickerCameraCollectionViewCell.h"

@implementation JMPickerCameraCollectionViewCellModel

- (instancetype)initWithCore:(JMAssetPickerCore *)core {
    self = [super init];
    if (self) {
        self.cls = [JMPickerCameraCollectionViewCell class];
        
        self.core = core;
    }
    return self;
}

@end

@interface JMPickerCameraCollectionViewCell ()

@property (nonatomic, strong) JMPickerCameraCollectionViewCellModel *model;

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation JMPickerCameraCollectionViewCell

#pragma mark - setup UI

- (void)setupUI {
    [self.contentView addSubview:self.imageView];
    
    [self.imageView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = self.contentView.sizeJM;
        make.centerXJM = self.contentView.centerXJM;
        make.centerYJM = self.contentView.centerYJM;
    }];
}

#pragma mark - setup UI response

- (void)setupUIResponse {
    
}

#pragma mark - bind model

- (void)bindModel {
    self.imageView.image = self.model.core.cameraImage;
    
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

@end
