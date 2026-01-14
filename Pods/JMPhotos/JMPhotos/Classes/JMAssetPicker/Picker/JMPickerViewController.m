//
//  JMPickerViewController.m
//  JMAssetPicker
//
//  Created by ZhengXianda on 2022/6/13.
//

#import "JMPickerViewController.h"

#import <CoreServices/CoreServices.h>
#import <JMUtils/JMUtils.h>

#import "JMPickerCollectionViewCell.h"
#import "JMPickerCameraCollectionViewCell.h"
#import "JMPhotosToolView.h"
#import "JMPreviewViewController.h"
#import "JMAssetTaker.h"

#import "PHAsset+JMAssetPicker.h"
#import "PHAsset+JMAssetPickerCore.h"
#import "PHAssetCollection+JMAssetPicker.h"

@interface JMPickerViewController () <
UICollectionViewDelegateFlowLayout,
UICollectionViewDelegate,
UICollectionViewDataSource
>

@property (nonatomic, strong) JMAssetPickerModel *model;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) PHAssetCollection *collection;
@property (nonatomic, strong) NSMutableArray <JMCollectionViewCellModel *>*collectionViewModels;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) JMNavigatorView *navigatorView;
@property (nonatomic, strong) JMPhotosToolView *toolView;

@end

@implementation JMPickerViewController

- (instancetype)initWithImagePickerModel:(JMAssetPickerModel *)model index:(NSInteger)index {
    self = [super init];
    if (self) {
        self.model = model;
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

- (void)pop {
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)dismiss {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)preview:(BOOL)isOnlySelecting index:(NSInteger)index {
    JMPreviewViewController *previewViewController = [[JMPreviewViewController alloc] initWithImagePickerModel:self.model
                                                                                                    collection:self.collection
                                                                                                 onlySelecting:isOnlySelecting
                                                                                                         index:index];
    [self.navigationController pushViewController:previewViewController animated:YES];
}

- (void)refreshOriginalSize {
    if (self.toolView.originalStatusDotView.active) {
        [self.model selectingAssetDataLength:^(NSUInteger dataLength) {
            self.toolView.originalSize = [NSString bytesSize:dataLength];
        }];
    } else {
        self.toolView.originalSize = @"";
    }
}

- (void)openCamera {
    NSMutableArray *mediaTypes = [NSMutableArray array];
    if (self.model.core.allowCameraPhoto) [mediaTypes addObject:(NSString *)kUTTypeMovie];
    if (self.model.core.allowCameraVideo) [mediaTypes addObject:(NSString *)kUTTypeImage];
    
    __weak typeof(self) weakSelf = self;
    [JMAssetTaker showAssetTakerOn:self mediaTypes:[mediaTypes copy] saveCompletion:^(PHAsset * _Nonnull asset, NSError * _Nonnull error) {
        if (asset) {
            [weakSelf.model fetchAlbums];
            [weakSelf bindModel];
        }
        if (error) {
            [weakSelf showAlertWithTitle:@"拍摄内容保存失败" message:error.localizedDescription];
        }
    }];
}

#pragma mark - setup UI

- (void)setupUI {
    [self.navigationController setNavigationBarHidden:YES];
    
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:247/255.0 blue:248/255.0 alpha:1.0];
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.navigatorView];
    [self.view addSubview:self.toolView];
    
    [self.collectionView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = self.view.sizeJM;
        make.topJM = 0;
        make.leftJM = 0;
    }];
    [self.navigatorView jm_layout:^(UIView * _Nonnull make) {
        make.topJM = 0;
        make.leftJM = 0;
    }];
    [self.toolView jm_layout:^(UIView * _Nonnull make) {
        make.bottomJM = self.view.bottomJM;
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
                                       action:@selector(cancelButtonTapped)
                             forControlEvents:UIControlEventTouchUpInside];
    [self.toolView.previewButton addTarget:self
                                    action:@selector(previewButtonTapped)
                          forControlEvents:UIControlEventTouchUpInside];
    [self.toolView.originalButton addTarget:self
                                     action:@selector(originalButtonTapped)
                           forControlEvents:UIControlEventTouchUpInside];
    [self.toolView.finishButton addTarget:self
                                   action:@selector(finishButtonTapped)
                         forControlEvents:UIControlEventTouchUpInside];
}

- (void)backButtonTapped {
    [self pop];
}

- (void)cancelButtonTapped {
    [self.model removeAllSelectedAsset];
    [self dismiss];
}

- (void)previewButtonTapped {
    [self preview:(self.collection.assetListSelecting.count > 0) index:0];
}

- (void)originalButtonTapped {
    self.toolView.originalStatusDotView.active = !self.toolView.originalStatusDotView.active;
    [self refreshOriginalSize];
}

- (void)finishButtonTapped {
    __weak typeof(self) weakSelf = self;
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [weakSelf.model d_assetPickerSelectingDidFinish];
    }];
}

#pragma mark - bind model

- (void)bindModel {
    self.navigatorView.titleLabel.text = self.collection.localizedTitle;
    
    self.collectionViewModels = [NSMutableArray array];
    
    __weak typeof(self) weakSelf = self;
    [self.collection.assetList enumerateObjectsUsingBlock:^(PHAsset * _Nonnull asset, NSUInteger idx, BOOL * _Nonnull stop) {
        JMPickerCollectionViewCellModel *model = [[JMPickerCollectionViewCellModel alloc] initWithAsset:asset];
        model.action = ^(NSIndexPath * _Nonnull indexPath) {
            if (asset.selectingCeiling) {
                [weakSelf showAlertWithTitle:@"选择内容已达上限" message:@""];
            } else if (asset.selectingIncompatible) {
                [weakSelf showAlertWithTitle:@"无法同时选择图片和视频" message:@""];
            } else {
                if (weakSelf.model.core.allowCamera && !weakSelf.model.core.sortAscendingByCreationDate) {
                    [weakSelf preview:NO index:MAX(indexPath.item - 1, 0)];
                } else {
                    [weakSelf preview:NO index:indexPath.item];
                }
            }
        };
        model.selectedAction = ^(NSIndexPath * _Nonnull indexPath) {
            [weakSelf.model select:asset];
            weakSelf.toolView.selectedCount = weakSelf.model.selectingAssetList.count;
            [weakSelf refreshOriginalSize];
            
            [weakSelf.collectionView reloadData];
        };
        [weakSelf.collectionViewModels addObject:model];
    }];
    if (self.model.core.allowCamera) {
        JMPickerCameraCollectionViewCellModel *model = [[JMPickerCameraCollectionViewCellModel alloc] initWithCore:self.model.core];
        model.action = ^(NSIndexPath * _Nonnull indexPath) {
            [weakSelf openCamera];
        };
        if (self.model.core.sortAscendingByCreationDate) {
            [self.collectionViewModels addObject:model];
        } else {
            [self.collectionViewModels insertObject:model atIndex:0];
        }
    }
    
    [self setupUI];
}

#pragma mark - protocol

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

- (PHAssetCollection *)collection {
    return self.model.assetCollectionList[self.index];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumInteritemSpacing = self.model.core.columnSpace;
        layout.minimumLineSpacing = self.model.core.columnSpace;
        layout.itemSize = self.model.core.assetSize;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                             collectionViewLayout:layout];
        UIEdgeInsets pickerInsets = self.model.core.pickerInsets;
        _collectionView.contentInset = UIEdgeInsetsMake(pickerInsets.top + kFunctionBarHeight, pickerInsets.left, pickerInsets.bottom + kFunctionBarHeight, pickerInsets.right);
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        
        [_collectionView registerClass:[JMPickerCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JMPickerCollectionViewCell class])];
        [_collectionView registerClass:[JMPickerCameraCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JMPickerCameraCollectionViewCell class])];
    }
    return _collectionView;
}

- (JMNavigatorView *)navigatorView {
    if (!_navigatorView) {
        _navigatorView = [[JMNavigatorView alloc] init];
        _navigatorView.backgroundColor = self.model.core.navigatorBackgroundColor;
        [_navigatorView.backButton setImage:self.model.core.navigatorBackImage forState:UIControlStateNormal];
        [_navigatorView.backButton setImageEdgeInsets:UIEdgeInsetsMake(0, 16, 0, 0)];
        _navigatorView.titleLabel.font = self.model.core.navigatorTitleFont;
        _navigatorView.titleLabel.textColor = self.model.core.navigatorTitleColor;
        [_navigatorView.rightButton setTitle:@"取消" forState:UIControlStateNormal];
        [_navigatorView.rightButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _navigatorView.rightButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightRegular];
        _navigatorView.rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    }
    return _navigatorView;
}

- (JMPhotosToolView *)toolView {
    if (!_toolView) {
        _toolView = [[JMPhotosToolView alloc] init];
        _toolView.backgroundColor = self.model.core.navigatorBackgroundColor;
        _toolView.isAllowOriginal = self.model.core.allowPickingOriginal;
        _toolView.previewTitleLabel.font = self.model.core.toolPreviewContentFont;
        _toolView.previewTitleLabel.textColor = self.model.core.toolPreviewContentColor;
        _toolView.originalStatusDotView.idleImageView.image = self.model.core.toolOriginalUnselectedImage;
        _toolView.originalStatusDotView.activeImageView.image = self.model.core.toolOriginalSelectedImage;
        _toolView.originalTitleLabel.font = self.model.core.toolOriginalContentFont;
        _toolView.originalTitleLabel.textColor = self.model.core.toolOriginalContentColor;
        _toolView.originalSizeLabel.font = self.model.core.toolOriginalContentFont;
        _toolView.originalSizeLabel.textColor = self.model.core.toolOriginalContentColor;
        _toolView.finishTitleLabel.font = self.model.core.toolFinishContentFont;
        _toolView.finishTitleLabel.textColor = self.model.core.toolFinishContentColor;
        _toolView.selectedCountDotView.idleImageView.image = self.model.core.toolSelectedCountIdleImage;
        _toolView.selectedCountDotView.activeImageView.image = self.model.core.toolSelectedCountActiveImage;

    }
    return _toolView;
}

@end
