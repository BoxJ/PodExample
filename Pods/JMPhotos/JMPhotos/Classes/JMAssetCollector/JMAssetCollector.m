//
//  JMAssetCollector.m
//  JMAssetCollector
//
//  Created by ZhengXianda on 09/30/2022.
//  Copyright (c) 2022 ZhengXianda. All rights reserved.
//

#import "JMAssetCollector.h"

#import <JMUIKit/JMUIKit.h>

#import "JMAssetCollectorModel.h"
#import "JMAssetCollectorFlowLayout.h"
#import "JMAssetCollectorItemCell.h"

#import "PHAsset+JMAssetCollectorCore.h"

@interface JMAssetCollector () <
UICollectionViewDelegateFlowLayout,
UICollectionViewDelegate,
UICollectionViewDataSource
>

@property (nonatomic, strong) JMAssetCollectorModel *model;
@property (nonatomic, strong) NSMutableArray <JMCollectionViewCellModel *>*collectionViewModels;
@property (nonatomic, strong) JMAssetCollectorItemCellModel *addViewModel;

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation JMAssetCollector

#pragma mark - init

- (instancetype)initWithModel:(JMAssetCollectorModel *)model {
    self = [super init];
    if (self) {
        [self configModel:model];
    }
    return self;
}

- (void)configModel:(JMAssetCollectorModel *)model {
    self.model = model;
    
    [self setupUI];
    [self setupUIResponse];
    [self bindModel];
}

#pragma mark - live cycle

#pragma mark - action

- (void)reload {
    self.collectionViewModels = [NSMutableArray array];
    
    __weak typeof(self) weakSelf = self;
    [self.model.selectingAssetList enumerateObjectsUsingBlock:^(PHAsset * _Nonnull asset, NSUInteger idx, BOOL * _Nonnull stop) {
        asset.jmiscore = weakSelf.model.core;
        
        JMAssetCollectorItemCellModel *model = [[JMAssetCollectorItemCellModel alloc] initWithAsset:asset];
        model.deleteAction = ^(NSIndexPath * _Nonnull indexPath) {
            NSMutableArray *selectingAssetList = [weakSelf.model.selectingAssetList mutableCopy];
            [selectingAssetList removeObjectAtIndex:indexPath.item];
            weakSelf.model.selectingAssetList = [selectingAssetList copy];
            
            [self.model d_assetCollectorDidChange];
            
            [weakSelf.collectionViewModels removeObjectAtIndex:indexPath.item];
            
            [weakSelf.collectionView reloadData];
        };
        model.action = ^(NSIndexPath * _Nonnull indexPath) {
            
        };
        [weakSelf.collectionViewModels addObject:model];
    }];
    
    [self.collectionView reloadData];
}

#pragma mark - setup UI

- (void)setupUI {
    [self addSubview:self.collectionView];
    
    [self.collectionView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(self.model.core.displayWidth - self.model.core.displayInsets.left - self.model.core.displayInsets.right,
                                 self.model.selectingHeight - self.model.core.displayInsets.top - self.model.core.displayInsets.bottom);
        make.leftJM = self.model.core.displayInsets.left;
        make.topJM = self.model.core.displayInsets.top;
    }];
}

#pragma mark - setup UI response

- (void)setupUIResponse {
    
}

#pragma mark - bind model

- (void)bindModel {
    self.collectionViewModels = [NSMutableArray array];
    
    __weak typeof(self) weakSelf = self;
    PHAsset *asset = [[PHAsset alloc] init];
    asset.jmiscore = weakSelf.model.core;
    self.addViewModel = [[JMAssetCollectorItemCellModel alloc] initWithAsset:asset];
    self.addViewModel.action = ^(NSIndexPath * _Nonnull indexPath) {
        [weakSelf.model d_assetCollectorExecute];
    };
    
    JMAssetCollectorFlowLayout *layout = [[JMAssetCollectorFlowLayout alloc] init];
    layout.itemSize = self.model.core.assetSize;
    layout.minimumInteritemSpacing = self.model.core.displayColumnSpace;
    layout.minimumLineSpacing = self.model.core.displayColumnSpace;
    self.collectionView.collectionViewLayout = layout;
    
    [self setupUI];
}

#pragma mark - protocol

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.item < self.collectionViewModels.count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    return (sourceIndexPath.item < self.collectionViewModels.count && destinationIndexPath.item < self.collectionViewModels.count);
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    
    NSMutableArray *selectingAssetList = [self.model.selectingAssetList mutableCopy];
    id asset = selectingAssetList[sourceIndexPath.item];
    [selectingAssetList removeObjectAtIndex:sourceIndexPath.item];
    [selectingAssetList insertObject:asset atIndex:destinationIndexPath.item];
    self.model.selectingAssetList = [selectingAssetList copy];
    
    id viewModel = self.collectionViewModels[sourceIndexPath.item];
    [self.collectionViewModels removeObjectAtIndex:sourceIndexPath.item];
    [self.collectionViewModels insertObject:viewModel atIndex:destinationIndexPath.item];
    
    [self.model d_assetCollectorDidChange];
    
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return MIN(self.collectionViewModels.count + 1, self.model.core.selectedCountLimit);
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JMCollectionViewCellModel *model;
    if (indexPath.item == self.collectionViewModels.count) {
        model = self.addViewModel;
    } else {
        model = self.collectionViewModels[indexPath.item];
    }
    
    return [model collectionView:collectionView cellForRowAtIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JMCollectionViewCellModel *model;
    if (indexPath.item == self.collectionViewModels.count) {
        model = self.addViewModel;
    } else {
        model = self.collectionViewModels[indexPath.item];
    }
    
    model.action(indexPath);
}

#pragma mark - setter

#pragma mark - getter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        JMAssetCollectorFlowLayout *layout = [[JMAssetCollectorFlowLayout alloc] init];
        layout.itemSize = self.model.core.assetSize;
        layout.minimumInteritemSpacing = self.model.core.displayColumnSpace;
        layout.minimumLineSpacing = self.model.core.displayColumnSpace;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        
        [_collectionView registerClass:[JMAssetCollectorItemCell class]
            forCellWithReuseIdentifier:NSStringFromClass([JMAssetCollectorItemCell class])];
    }
    return _collectionView;
}

@end
