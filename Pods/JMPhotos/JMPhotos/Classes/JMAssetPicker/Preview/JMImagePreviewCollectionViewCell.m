//
//  JMImagePreviewCollectionViewCell.m
//  JMAssetPicker
//
//  Created by ZhengXianda on 2022/9/26.
//

#import "JMImagePreviewCollectionViewCell.h"

#import "PHAsset+JMAssetPickerCore.h"

@implementation JMImagePreviewCollectionViewCellModel

- (instancetype)initWithAsset:(PHAsset *)asset {
    self = [super initWithAsset:asset];
    if (self) {
        self.cls = [JMImagePreviewCollectionViewCell class];
    }
    return self;
}

@end

@interface JMImagePreviewCollectionViewCell ()

@property (nonatomic, strong) JMImagePreviewCollectionViewCellModel *model;

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation JMImagePreviewCollectionViewCell

#pragma mark - init

#pragma mark - live cycle

#pragma mark - action

#pragma mark - setup UI

- (void)setupUI {
    [super setupUI];
    
    [self.zoomView.contentView addSubview:self.imageView];
    
    [self.imageView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = self.zoomView.contentView.sizeJM;
        make.centerXJM = self.zoomView.contentView.centerXJM;
        make.centerYJM = self.zoomView.contentView.centerYJM;
    }];
}

#pragma mark - setup UI response

- (void)setupUIResponse {
    [super setupUIResponse];
}

- (void)singleTap:(UIGestureRecognizer *)gesture {
    [self tapAction];
}

#pragma mark - bind model

- (void)bindModel {
    [super bindModel];
    
    __weak typeof(self) weakSelf = self;
    __block NSString *identifier = self.model.asset.localIdentifier;
    [self.model.asset jmip_imageCompletion:^(UIImage * _Nonnull image) {
        if ([weakSelf.model.asset.localIdentifier isEqualToString:identifier]) {
            weakSelf.imageView.image = image;
        }
    }];
    
    [self setupUI];
}

#pragma mark - protocol

#pragma mark - setter

#pragma mark - getter

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

@end
