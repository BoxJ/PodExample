//
//  JMGifPreviewCollectionViewCell.m
//  JMAssetPicker
//
//  Created by ZhengXianda on 2022/9/27.
//

#import "JMGifPreviewCollectionViewCell.h"

#import "PHAsset+JMExtension.h"
#import "PHAsset+JMAssetPickerCore.h"

@implementation JMGifPreviewCollectionViewCellModel

- (instancetype)initWithAsset:(PHAsset *)asset {
    self = [super initWithAsset:asset];
    if (self) {
        self.cls = [JMGifPreviewCollectionViewCell class];
    }
    return self;
}

@end

@interface JMGifPreviewCollectionViewCell ()

@property (nonatomic, strong) JMGifPreviewCollectionViewCellModel *model;

@property (nonatomic, strong) JMAnimatedImageView *animatedImageView;

@end

@implementation JMGifPreviewCollectionViewCell

#pragma mark - init

#pragma mark - live cycle

#pragma mark - action

#pragma mark - setup UI

- (void)setupUI {
    [super setupUI];
    
    [self.contentView addSubview:self.animatedImageView];
    
    [self.animatedImageView jm_layout:^(UIView * _Nonnull make) {
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
    [self.model.asset jm_imageDataCompletion:^(NSData * _Nonnull imageData) {
        if ([weakSelf.model.asset.localIdentifier isEqualToString:identifier]) {
            weakSelf.animatedImageView.animatedImage = [JMAnimatedImage animatedImageWithGIFData:imageData];
        }
    }];
    
    [self setupUI];
}

#pragma mark - protocol

#pragma mark - setter

#pragma mark - getter

- (JMAnimatedImageView *)animatedImageView {
    if (!_animatedImageView) {
        _animatedImageView = [[JMAnimatedImageView alloc] init];
        _animatedImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _animatedImageView;
}

@end
