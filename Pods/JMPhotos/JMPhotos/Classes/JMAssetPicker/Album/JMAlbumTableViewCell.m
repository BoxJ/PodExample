//
//  JMAlbumTableViewCell.m
//  JMAssetPicker
//
//  Created by ZhengXianda on 2022/6/7.
//

#import "JMAlbumTableViewCell.h"

#import "PHAsset+JMAssetPickerCore.h"
#import "PHAssetCollection+JMAssetPicker.h"
#import "PHAssetCollection+JMAssetPickerCore.h"

@implementation JMAlbumTableViewCellModel

- (instancetype)initWithCollection:(PHAssetCollection *)collection {
    self = [super init];
    if (self) {
        self.cls = [JMAlbumTableViewCell class];
        
        self.collection = collection;
    }
    return self;
}

@end

@interface JMAlbumTableViewCell ()

@property (nonatomic, strong) JMAlbumTableViewCellModel *model;

@property (nonatomic, strong) UIImageView *posterImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) JMDotView *dotView;

@end

@implementation JMAlbumTableViewCell

#pragma mark - setup UI

- (void)setupUI {
    [self.contentView addSubview:self.posterImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.dotView];
    
    CGFloat albumHeight = self.model.collection.jmipcore.albumHeight;
    self.sizeJM = CGSizeMake(kScreenWidth, albumHeight);
    self.contentView.sizeJM = self.sizeJM;
    
    [self.posterImageView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(self.sizeJM.height, self.sizeJM.height);
        make.leftJM = 0;
        make.centerYJM = self.contentView.centerYJM;
    }];
    [self.titleLabel jm_layout:^(UIView * _Nonnull make) {
        [make sizeToFit];
        make.leftJM = self.posterImageView.rightJM + 10;
        make.centerYJM = self.contentView.centerYJM;
    }];
    [self.dotView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(24, 24);
        make.rightJM = self.contentView.rightJM - 24;
        make.centerYJM = self.contentView.centerYJM;
    }];
}

#pragma mark - setup UI response

- (void)setupUIResponse {
    
}

#pragma mark - bind model

- (void)bindModel {
    [self.model.collection.posterAsset jmip_posterCompletion:^(UIImage * _Nonnull image) {
        self.posterImageView.image = image;
    }];
    self.titleLabel.text = [NSString stringWithFormat:@"%@ (%zd)",
                            self.model.collection.localizedTitle,
                            self.model.collection.assetList.count];
    self.dotView.index = self.model.collection.assetListSelecting.count;
    
    [self setupUI];
}

#pragma mark - protocol

#pragma mark - setter

#pragma mark - getter

- (UIImageView *)posterImageView {
    if (!_posterImageView) {
        _posterImageView = [[UIImageView alloc] init];
        _posterImageView.contentMode = UIViewContentModeScaleAspectFill;
        _posterImageView.clipsToBounds = YES;
    }
    return _posterImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (JMDotView *)dotView {
    if (!_dotView) {
        _dotView = [[JMDotView alloc] init];
        _dotView.activeImageView.backgroundColor = UIColor.redColor;
        _dotView.layer.cornerRadius = 12;
        _dotView.layer.masksToBounds = YES;
    }
    return _dotView;
}

@end
