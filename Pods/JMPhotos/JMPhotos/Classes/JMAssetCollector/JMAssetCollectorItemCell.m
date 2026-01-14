//
//  JMAssetCollectorItemCell.m
//  JMImagePickerController_Example
//
//  Created by ZhengXianda on 2022/9/27.
//  Copyright © 2022 ZhengXianda. All rights reserved.
//

#import "JMAssetCollectorItemCell.h"

#import "JMAssetCollectorCore.h"

#import "PHAsset+JMExtension.h"
#import "PHAsset+JMAssetCollectorCore.h"

@interface JMAssetCollectorItemCellModel ()

@property (nonatomic, weak) JMCollectionViewCell *collectionViewCell;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation JMAssetCollectorItemCellModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.cls = [JMAssetCollectorItemCell class];
        
        __weak typeof(self) weakSelf = self;
        self.reload = ^(NSIndexPath * _Nonnull indexPath) {
            [weakSelf.collectionViewCell bindModel];
        };
    }
    return self;
}

- (instancetype)initWithAsset:(PHAsset *)asset {
    self = [self init];
    if (self) {
        self.asset = asset;
    }
    return self;
}

- (JMCollectionViewCellEvent)deleteAction {
    if (!_deleteAction) {
        _deleteAction = ^(NSIndexPath * indexPath) { };
    }
    return _deleteAction;
}

@end

@interface JMAssetCollectorItemCell ()

@property (nonatomic, strong) JMAssetCollectorItemCellModel *model;

@property (nonatomic, strong) UIImageView *posterView;
@property (nonatomic, strong) UIButton *deleteButton;

@property (nonatomic, strong) UIImageView *videoPlayImageView;

@end

@implementation JMAssetCollectorItemCell

#pragma mark - init

#pragma mark - live cycle

#pragma mark - action

- (UIView *)snapshotView {
    UIView *snapshotView = nil;
    
    if ([self respondsToSelector:@selector(snapshotViewAfterScreenUpdates:)]) {
        snapshotView = [self snapshotViewAfterScreenUpdates:NO];
    } else {
        UIImage * cellSnapshotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsBeginImageContextWithOptions(self.sizeJM, self.opaque, 0);
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIGraphicsEndImageContext();
        snapshotView = [[UIImageView alloc] initWithImage:cellSnapshotImage];
    }
    
    snapshotView.frame = self.contentView.bounds;
    
    return snapshotView;
}

- (void)deleteAction {
    if (self.model.deleteAction) {
        self.model.deleteAction(self.model.indexPath);
    }
}

#pragma mark - setup UI

- (void)setupUI {
    [self.contentView addSubview:self.posterView];
    [self.contentView addSubview:self.deleteButton];
    [self.contentView addSubview:self.videoPlayImageView];
    
    UIEdgeInsets assetInsets = self.model.asset.jmiscore.assetInsets;
    [self.posterView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(self.widthJM - assetInsets.left - assetInsets.right,
                                 self.heightJM - assetInsets.top - assetInsets.bottom);
        make.leftJM = assetInsets.left;
        make.topJM = assetInsets.top;
    }];
    [self.deleteButton jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(self.contentView.widthJM / 3.0, self.contentView.heightJM / 3.0);
        make.centerXJM = self.posterView.rightJM;
        make.centerYJM = self.posterView.topJM;
    }];
    [self.videoPlayImageView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(self.contentView.widthJM / 3.0, self.contentView.heightJM / 3.0);
        make.centerXJM = self.posterView.centerXJM;
        make.centerYJM = self.posterView.centerYJM;
    }];
}

#pragma mark - setup UI response

- (void)setupUIResponse {
    [self.deleteButton addTarget:self
                       action:@selector(deleteButtonTapped)
             forControlEvents:UIControlEventTouchUpInside];
}

- (void)deleteButtonTapped {
    [self deleteAction];
}

#pragma mark - bind model

- (void)bindModel {
    __weak typeof(self) weakSelf = self;
    __block NSString *identifier = self.model.asset.localIdentifier;
    if (self.model.asset.mediaType == PHAssetMediaTypeUnknown) {
        self.posterView.image = self.model.asset.jmiscore.addImage;
        self.deleteButton.hidden = YES;
        self.videoPlayImageView.hidden = YES;
    } else {
        self.posterView.image = nil;
        [self.model.asset jm_imageDataCompletion:^(NSData * _Nonnull imageData) {
            if ([weakSelf.model.asset.localIdentifier isEqualToString:identifier]) {
                weakSelf.posterView.image = [UIImage imageWithData:imageData];
            }
        }];
        
        self.deleteButton.hidden = NO;
        [self.deleteButton setImage:self.model.asset.jmiscore.deleteImage forState:UIControlStateNormal];
        
        self.videoPlayImageView.hidden = self.model.asset.mediaType != PHAssetMediaTypeVideo;
        self.videoPlayImageView.image = self.model.asset.jmiscore.videoPlayImage;
    }
    
    [self setupUI];
}

#pragma mark - protocol

#pragma mark - setter

#pragma mark - getter

- (UIImageView *)posterView {
    if (!_posterView) {
        _posterView = [[UIImageView alloc] init];
        _posterView.contentMode = UIViewContentModeScaleAspectFill;
        _posterView.clipsToBounds = YES;
        _posterView.layer.cornerRadius = 8;
    }
    return _posterView;
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _deleteButton;
}

- (UIImageView *)videoPlayImageView {
    if (!_videoPlayImageView) {
        _videoPlayImageView = [[UIImageView alloc] init];
    }
    return _videoPlayImageView;
}

@end
