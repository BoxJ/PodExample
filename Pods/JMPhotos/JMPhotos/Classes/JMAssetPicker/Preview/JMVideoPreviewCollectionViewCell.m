//
//  JMVideoPreviewCollectionViewCell.m
//  JMAssetPicker
//
//  Created by ZhengXianda on 2022/9/26.
//

#import "JMVideoPreviewCollectionViewCell.h"

#import "JMAssetPickerCore.h"

#import "PHAsset+JMExtension.h"
#import "PHAsset+JMAssetPickerCore.h"

@implementation JMVideoPreviewCollectionViewCellModel

- (instancetype)initWithAsset:(PHAsset *)asset {
    self = [super initWithAsset:asset];
    if (self) {
        self.cls = [JMVideoPreviewCollectionViewCell class];
    }
    return self;
}

@end

@interface JMVideoPreviewCollectionViewCell ()

@property (nonatomic, strong) JMVideoPreviewCollectionViewCellModel *model;

@property (nonatomic, strong) AVPlayerLayer *videoPlayerLayer;
@property (nonatomic, strong) UIImageView *videoPlayImageView;

@end

@implementation JMVideoPreviewCollectionViewCell

#pragma mark - init

#pragma mark - live cycle

#pragma mark - action

- (void)videoPlay {
    [self.videoPlayerLayer.player play];
    self.videoPlayImageView.hidden = YES;
}

- (void)videoPause {
    [self.videoPlayerLayer.player pause];
    self.videoPlayImageView.hidden = NO;
}

- (void)videoReset {
    [self videoPause];
    
    [self.videoPlayerLayer.player.currentItem seekToTime:CMTimeMake(0, 1)];
}

#pragma mark - setup UI

- (void)setupUI {
    [super setupUI];
    
    [self.zoomView.contentView.layer addSublayer:self.videoPlayerLayer];
    [self.contentView addSubview:self.videoPlayImageView];
    
    self.videoPlayerLayer.frame = self.zoomView.contentView.bounds;
    [self.videoPlayImageView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(50, 50);
        make.centerXJM = self.contentView.centerXJM;
        make.centerYJM = self.contentView.centerYJM;
    }];
}

#pragma mark - setup UI response

- (void)setupUIResponse {
    [super setupUIResponse];
}

- (void)singleTap:(UIGestureRecognizer *)gesture {
    CMTime currentTime = self.videoPlayerLayer.player.currentItem.currentTime;
    CMTime durationTime = self.videoPlayerLayer.player.currentItem.duration;
    if (self.videoPlayerLayer.player.rate == 0.0f) {
        if (currentTime.value == durationTime.value) {
            [self.videoPlayerLayer.player.currentItem seekToTime:CMTimeMake(0, 1)];
        }
        [self videoPlay];
        [self unfoldAction];
    } else {
        [self videoPause];
        [self foldAction];
    }
}

#pragma mark - bind model

- (void)bindModel {
    [super bindModel];
    
    self.videoPlayImageView.image = self.model.asset.jmipcore.videoPlayImage;
    
    __weak typeof(self) weakSelf = self;
    __block NSString *identifier = self.model.asset.localIdentifier;
    [self.model.asset jm_playerItemCompletion:^(AVPlayerItem * _Nonnull playerItem) {
        if ([weakSelf.model.asset.localIdentifier isEqualToString:identifier]) {
            AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
            weakSelf.videoPlayerLayer.player = player;
            
            __block float total = CMTimeGetSeconds([player.currentItem duration]);
            [weakSelf.videoPlayerLayer.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0)
                                                                           queue:dispatch_get_main_queue()
                                                                      usingBlock:^(CMTime time) {
                if (fabs(CMTimeGetSeconds(time) - total) < 0.01) [weakSelf videoReset];
            }];
        }
    }];
    [self videoReset];
    
    [self setupUI];
}

#pragma mark - protocol

#pragma mark - setter

#pragma mark - getter

- (AVPlayerLayer *)videoPlayerLayer {
    if (!_videoPlayerLayer) {
        _videoPlayerLayer = [[AVPlayerLayer alloc] init];
    }
    return _videoPlayerLayer;
}

- (UIImageView *)videoPlayImageView {
    if (!_videoPlayImageView) {
        _videoPlayImageView = [[UIImageView alloc] init];
    }
    return _videoPlayImageView;
}

@end
