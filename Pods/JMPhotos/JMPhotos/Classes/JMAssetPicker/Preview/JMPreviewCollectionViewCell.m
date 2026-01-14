//
//  JMPreviewCollectionViewCell.m
//  JMAssetPicker
//
//  Created by ZhengXianda on 2022/9/22.
//

#import "JMPreviewCollectionViewCell.h"

#import "PHAsset+JMAssetPicker.h"
#import "PHAsset+JMAssetPickerCore.h"

#import <MediaPlayer/MediaPlayer.h>

@interface JMPreviewCollectionViewCellModel ()

@property (nonatomic, weak) JMCollectionViewCell *collectionViewCell;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation JMPreviewCollectionViewCellModel

- (instancetype)initWithAsset:(PHAsset *)asset {
    self = [super init];
    if (self) {
        self.cls = [JMPreviewCollectionViewCell class];
        
        self.asset = asset;
        
        __weak typeof(self) weakSelf = self;
        self.reload = ^(NSIndexPath * _Nonnull indexPath) {
            [weakSelf.collectionViewCell bindModel];
        };
    }
    return self;
}

- (JMCollectionViewCellEvent)tapAction {
    if (!_tapAction) {
        _tapAction = ^(NSIndexPath * indexPath) { };
    }
    return _tapAction;
}

- (JMCollectionViewCellEvent)unfoldAction {
    if (!_unfoldAction) {
        _unfoldAction = ^(NSIndexPath * indexPath) { };
    }
    return _unfoldAction;
}

- (JMCollectionViewCellEvent)foldAction {
    if (!_foldAction) {
        _foldAction = ^(NSIndexPath * indexPath) { };
    }
    return _foldAction;
}

@end

@interface JMPreviewCollectionViewCell () <UIScrollViewDelegate>

@property (nonatomic, strong) JMPreviewCollectionViewCellModel *model;

@end

@implementation JMPreviewCollectionViewCell

- (void)tapAction {
    if (self.model.tapAction) {
        self.model.tapAction(self.model.indexPath);
    }
}

- (void)unfoldAction {
    if (self.model.unfoldAction) {
        self.model.unfoldAction(self.model.indexPath);
    }
}

- (void)foldAction {
    if (self.model.foldAction) {
        self.model.foldAction(self.model.indexPath);
    }
}

#pragma mark - setup UI

- (void)setupUI {
    self.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:self.zoomView];
    
    [self.zoomView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = self.sizeJM;
        make.centerXJM = self.contentView.centerXJM;
        make.centerYJM = self.contentView.centerYJM;
    }];
}

#pragma mark - setup UI response

- (void)setupUIResponse {
    UITapGestureRecognizer *singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    [doubleTapGesture setNumberOfTapsRequired:2];
    
    [singleTapGesture requireGestureRecognizerToFail:doubleTapGesture];
    [self addGestureRecognizer:singleTapGesture];
    [self addGestureRecognizer:doubleTapGesture];
}

- (void)singleTap:(UIGestureRecognizer *)gesture {
    
}

- (void)doubleTap:(UIGestureRecognizer *)gesture {
    if (fabs(self.zoomView.scale - self.zoomView.defaultScale) > 0.01) {
        [self.zoomView resetScale];
    } else {
        [self.zoomView zoomToScale:1.5 withPoint:[gesture locationInView:self.zoomView.contentView]];
    }
}

#pragma mark - bind model

- (void)bindModel {
    [self.zoomView resetScale];
}

#pragma mark - protocol

#pragma mark - setter

#pragma mark - getter

- (JMZoomView *)zoomView {
    if (!_zoomView) {
        _zoomView = [[JMZoomView alloc] initWithDefaultScale:1 minScale:0.5 maxScale:3.0];
    }
    return _zoomView;
}

@end
