//
//  JMPreviewViewController.m
//  JMAssetPicker
//
//  Created by ZhengXianda on 2022/9/19.
//

#import "JMPreviewViewController.h"

#import "JMAssetPickerCore.h"
#import "JMImagePreviewCollectionViewCell.h"
#import "JMGifPreviewCollectionViewCell.h"
#import "JMVideoPreviewCollectionViewCell.h"
#import "JMPhotosToolView.h"

#import "PHAsset+JMAssetPicker.h"
#import "PHAsset+JMAssetPickerCore.h"
#import "PHAssetCollection+JMAssetPicker.h"

@interface JMPreviewViewController () <
UIScrollViewDelegate,
UICollectionViewDelegateFlowLayout,
UICollectionViewDelegate,
UICollectionViewDataSource
>

@property (nonatomic, strong) JMAssetPickerModel *model;
@property (nonatomic, strong) PHAssetCollection *collection;
@property (nonatomic, strong) NSArray<PHAsset *> *assetList;
@property (nonatomic, strong) NSMutableArray <JMCollectionViewCellModel *>*collectionViewModels;
@property (nonatomic, assign) BOOL isOnlySelecting;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) JMNavigatorView *navigatorView;
@property (nonatomic, strong) JMPhotosToolView *toolView;
@property (nonatomic, strong) JMDotView *navigatorDotView;

@end

@implementation JMPreviewViewController

- (instancetype)initWithImagePickerModel:(JMAssetPickerModel *)model
                              collection:(PHAssetCollection *)collection
                           onlySelecting:(BOOL)isOnlySelecting
                                   index:(NSInteger)index {
    if (self) {
        self.model = model;
        
        self.collection = collection;
        self.assetList = isOnlySelecting ? self.collection.assetListSelecting : self.collection.assetList;
        self.isOnlySelecting = isOnlySelecting;
        self.index = index;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self setupUIResponse];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self bindModel];
}

- (void)dismiss {
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:NO];
}

#pragma mark - setup UI

- (void)setupUI {
    [self.navigationController setNavigationBarHidden:YES];
    
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:247/255.0 blue:248/255.0 alpha:1.0];
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.navigatorView];
    [self.view addSubview:self.toolView];
    [self.navigatorView.contentView insertSubview:self.navigatorDotView belowSubview:self.navigatorView.rightButton];
    
    [self.navigatorView jm_layout:^(UIView * _Nonnull make) {
        make.topJM = 0;
        make.leftJM = 0;
    }];
    [self.toolView jm_layout:^(UIView * _Nonnull make) {
        make.bottomJM = self.view.bottomJM;
        make.leftJM = 0;
    }];
    [self.navigatorDotView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(24, 24);
        make.rightJM = self.navigatorView.rightButton.rightJM - 10;
        make.centerYJM = self.navigatorView.rightButton.centerYJM;
    }];
    [self.collectionView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = self.view.sizeJM;
        make.topJM = 0;
        make.leftJM = 0;
    }];
    
    [self.collectionView reloadData];
}

#pragma mark - setup UI response

- (void)setupUIResponse {
    [self.navigatorView.backButton addTarget:self
                                      action:@selector(backButtonTapped)
                            forControlEvents:UIControlEventTouchUpInside];
    [self.navigatorView.rightButton addTarget:self
                                       action:@selector(selectButtonTapped)
                             forControlEvents:UIControlEventTouchUpInside];
    [self.toolView.finishButton addTarget:self
                                   action:@selector(finishButtonTapped)
                         forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)backButtonTapped {
    [self dismiss];
}

- (void)selectButtonTapped {
    PHAsset *asset = self.assetList[self.index];
    if (asset.selectingCeiling) {
        [self showAlertWithTitle:@"选择内容已达上限" message:@""];
    } else if (asset.selectingIncompatible) {
        [self showAlertWithTitle:@"无法同时选择图片和视频" message:@""];
    } else {
        [self.model select:asset];
    }
    self.navigatorDotView.index = self.assetList[self.index].selectedIndex;
    self.toolView.selectedCount = self.model.selectingAssetList.count;
}

- (void)finishButtonTapped {
    [self dismiss];
}

#pragma mark - bind model

- (void)bindModel {
    self.navigatorDotView.idleImageView.image = self.model.core.pickerUnselectedImage;
    self.navigatorDotView.activeImageView.image = self.model.core.pickerSelectedImage;
    self.navigatorDotView.index = self.assetList[self.index].selectedIndex;
    self.toolView.selectedCount = self.model.selectingAssetList.count;
    
    self.collectionViewModels = [NSMutableArray array];
    
    __weak typeof(self) weakSelf = self;
    [self.assetList enumerateObjectsUsingBlock:^(PHAsset * _Nonnull asset, NSUInteger idx, BOOL * _Nonnull stop) {
        JMPreviewCollectionViewCellModel *model;
        switch (asset.mediaType) {
            case PHAssetMediaTypeImage: {
                switch (asset.imageType) {
                    case PHAssetImageTypeGif:
                        model = [[JMGifPreviewCollectionViewCellModel alloc] initWithAsset:asset];
                        break;
                    default:
                        model = [[JMImagePreviewCollectionViewCellModel alloc] initWithAsset:asset];
                        break;
                }
            }
                break;
            case PHAssetMediaTypeVideo:
                model = [[JMVideoPreviewCollectionViewCellModel alloc] initWithAsset:asset];
                break;
            default:
                model = [[JMImagePreviewCollectionViewCellModel alloc] initWithAsset:asset];
                break;
        }
        
        model.tapAction = ^(NSIndexPath * _Nonnull indexPath) {
            weakSelf.navigatorView.hidden = !weakSelf.navigatorView.hidden;
            weakSelf.toolView.hidden = !weakSelf.toolView.hidden;
        };
        model.unfoldAction = ^(NSIndexPath * _Nonnull indexPath) {
            weakSelf.navigatorView.hidden = YES;
            weakSelf.toolView.hidden = YES;
        };
        model.foldAction = ^(NSIndexPath * _Nonnull indexPath) {
            weakSelf.navigatorView.hidden = NO;
            weakSelf.toolView.hidden = NO;
        };
        
        [weakSelf.collectionViewModels addObject:model];
    }];
    
    [self setupUI];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.index inSection:0]
                                atScrollPosition:UICollectionViewScrollPositionNone
                                        animated:NO];
}

#pragma mark - protocol

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (fabs(scrollView.contentOffset.x - self.index * self.view.widthJM) >= self.view.widthJM) {
        NSInteger currentIndex = scrollView.contentOffset.x / self.view.widthJM;
        if (currentIndex < self.assetList.count && self.index != currentIndex) {
            self.collectionViewModels[self.index].reload([NSIndexPath indexPathForItem:self.index inSection:0]);
            self.index = currentIndex;
            if (self.index >= 0) {
                self.navigatorDotView.index = self.assetList[self.index].selectedIndex;
            }
        }
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.collectionViewModels.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.collectionViewModels[indexPath.row] collectionView:collectionView cellForRowAtIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.collectionViewModels[indexPath.row].action(indexPath);
}

#pragma mark - setter

#pragma mark - getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.itemSize = CGSizeMake(kScreenWidth, kScreenHeight);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                             collectionViewLayout:layout];
        _collectionView.contentInset = UIEdgeInsetsZero;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        
        [_collectionView registerClass:[JMImagePreviewCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JMImagePreviewCollectionViewCell class])];
        [_collectionView registerClass:[JMGifPreviewCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JMGifPreviewCollectionViewCell class])];
        [_collectionView registerClass:[JMVideoPreviewCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JMVideoPreviewCollectionViewCell class])];
    }
    return _collectionView;
}

- (JMNavigatorView *)navigatorView {
    if (!_navigatorView) {
        _navigatorView = [[JMNavigatorView alloc] init];
        _navigatorView.backgroundColor = self.model.core.navigatorBackgroundColorTranslucent;
        [_navigatorView.backButton setImage:self.model.core.navigatorBackImage forState:UIControlStateNormal];
        [_navigatorView.backButton setImageEdgeInsets:UIEdgeInsetsMake(0, 16, 0, 0)];
        _navigatorView.titleLabel.font = self.model.core.navigatorTitleFont;
        _navigatorView.titleLabel.textColor = self.model.core.navigatorTitleColor;
    }
    return _navigatorView;
}

- (JMPhotosToolView *)toolView {
    if (!_toolView) {
        _toolView = [[JMPhotosToolView alloc] init];
        _toolView.backgroundColor = self.model.core.toolBackgroundColorTranslucent;
        _toolView.previewTitleLabel.hidden = YES;
        _toolView.originalStatusDotView.hidden = YES;
        _toolView.originalTitleLabel.hidden = YES;
        _toolView.finishTitleLabel.font = self.model.core.toolFinishContentFont;
        _toolView.finishTitleLabel.textColor = self.model.core.toolFinishContentColor;
        _toolView.selectedCountDotView.idleImageView.image = self.model.core.toolSelectedCountIdleImage;
        _toolView.selectedCountDotView.activeImageView.image = self.model.core.toolSelectedCountActiveImage;
    }
    return _toolView;
}

- (JMDotView *)navigatorDotView {
    if (!_navigatorDotView) {
        _navigatorDotView = [[JMDotView alloc] init];
        _navigatorDotView.idleImageView.image = self.model.core.toolSelectedCountIdleImage;
        _navigatorDotView.activeImageView.image = self.model.core.toolSelectedCountActiveImage;
    }
    return _navigatorDotView;
}

@end
