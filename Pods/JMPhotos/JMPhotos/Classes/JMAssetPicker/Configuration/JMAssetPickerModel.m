//
//  JMAssetPickerModel.m
//  JMAssetPicker
//
//  Created by ZhengXianda on 2022/6/17.
//

#import "JMAssetPickerModel.h"

#import "PHAsset+JMExtension.h"
#import "PHAsset+JMAssetPicker.h"
#import "PHAsset+JMAssetPickerCore.h"
#import "PHAssetCollection+JMAssetPicker.h"
#import "PHAssetCollection+JMAssetPickerCore.h"

@implementation JMAssetPickerModel

@synthesize selectingAssetList = _selectingAssetList;
@synthesize selectingImageList = _selectingImageList;
@synthesize selectingVideoList = _selectingVideoList;

- (instancetype)initWithImagePickerCore:(JMAssetPickerCore *)core {
    self = [super init];
    if (self) {
        self.core = core;
    }
    return self;
}

#pragma mark - delegate

- (void)d_assetPickerSelectingDidFinish {
    if ([self.delegate respondsToSelector:@selector(assetPickerSelectingDidFinish:)]) {
        [self.delegate assetPickerSelectingDidFinish:self];
    }
}

#pragma mark - fetch

- (void)fetchAlbums {
    NSArray *allAlbums;
    if (self.core.isRecentsOnly) {
        allAlbums = @[
            [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                     subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary
                                                     options:nil],
        ];
    } else {
        allAlbums = @[
            [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum
                                                     subtype:PHAssetCollectionSubtypeAlbumRegular
                                                     options:nil],
            [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                     subtype:PHAssetCollectionSubtypeAlbumRegular
                                                     options:nil]
        ];
    }
    
    NSMutableArray *assetCollectionList = [NSMutableArray array];
    for (PHFetchResult *fetchResult in allAlbums) {
        for (PHAssetCollection *collection in fetchResult) {
            if ([collection jmip_filter:self.core]) {
                if (collection.isRecents) {
                    [assetCollectionList insertObject:collection atIndex:0];
                } else {
                    [assetCollectionList addObject:collection];
                }
            };
        }
    }
    self.assetCollectionList = [assetCollectionList copy];
}

- (NSArray<PHAssetCollection *> *)assetCollectionList {
    if (!_assetCollectionList) {
        _assetCollectionList = [NSArray array];
    }
    return _assetCollectionList;
}

#pragma mark - select

- (JMIPSelectingStatus)select:(PHAsset *)asset {
    BOOL selected = !asset.isSelected;
    BOOL selectingCeiling = self.core.selectingCeiling;
    if (!selected || !selectingCeiling) {
        NSMutableArray *selectingAssetList = [self.selectingAssetList mutableCopy];
        NSMutableArray *selectingImageList = [self.selectingImageList mutableCopy];
        NSMutableArray *selectingVideoList = [self.selectingVideoList mutableCopy];
        
        if ((asset.isSelected = selected)) {
            if (!asset.selectingIncompatible && ![selectingAssetList containsObject:asset]) {
                [selectingAssetList addObject:asset];
                if (asset.mediaType == PHAssetMediaTypeImage) [selectingImageList addObject:asset];
                if (asset.mediaType == PHAssetMediaTypeVideo) [selectingVideoList addObject:asset];
                
                asset.selectedIndex = selectingAssetList.count;
            }
        } else {
            if ([selectingAssetList containsObject:asset]) {
                [selectingAssetList removeObject:asset];
                for (PHAsset *remainAsset in selectingAssetList) {
                    if (asset.selectedIndex < remainAsset.selectedIndex) {
                        remainAsset.selectedIndex --;
                    }
                }
                asset.selectedIndex = 0;
            }
            if ([selectingImageList containsObject:asset]) [selectingImageList removeObject:asset];
            if ([selectingVideoList containsObject:asset]) [selectingVideoList removeObject:asset];
        }
        self.selectingAssetList = [selectingAssetList copy];
        self.selectingImageList = [selectingImageList copy];
        self.selectingVideoList = [selectingVideoList copy];
    }
    self.core.selectingCeiling = self.selectingAssetList.count >= self.core.selectedCountLimit;
    self.core.selectingImageCeiling = self.selectingImageList.count >= self.core.selectedImageCountLimit || (!self.core.allowPickingMultipleType && self.selectingVideoList.count > 0);
    self.core.selectingVideoCeiling = self.selectingVideoList.count >= self.core.selectedVideoCountLimit || (!self.core.allowPickingMultipleType && self.selectingImageList.count > 0);
    
    if (asset.selectingCeiling) {
        return JMIPSelectingStatusIncompatible;
    }
    if (self.core.selectingCeiling) {
        if (selectingCeiling) {
            return JMIPSelectingStatusStillCeiling;
        } else {
            return JMIPSelectingStatusBecameCeiling;
        }
    } else {
        if (!selectingCeiling) {
            return JMIPSelectingStatusStillRemaining;
        } else {
            return JMIPSelectingStatusBecameRemaining;
        }
    }
    return JMIPSelectingStatusUnkonw;
}

- (void)update:(NSArray <PHAsset *> *)assetList {
    [self removeAllSelectedAsset];
    
    for (PHAsset *asset in assetList) {
        JMIPSelectingStatus status = [self select:asset];
        switch (status) {
            case JMIPSelectingStatusUnkonw:
            case JMIPSelectingStatusStillCeiling:
            case JMIPSelectingStatusBecameCeiling:
            case JMIPSelectingStatusIncompatible:
                return;
            default:
                break;
        }
    }
}

- (void)removeAllSelectedAsset {
    for (PHAsset *asset in self.selectingAssetList) {
        asset.isSelected = NO;
        asset.selectedIndex = 0;
    }
    self.selectingAssetList = [NSArray array];
    self.selectingImageList = [NSArray array];
    self.selectingVideoList = [NSArray array];
    self.core.selectingCeiling = NO;
    self.core.selectingImageCeiling = NO;
    self.core.selectingVideoCeiling = NO;
}

- (void)selectingAssetDataLength:(void(^)(NSUInteger dataLength))callback {
    __block NSUInteger dataLength = 0;
    
    if (self.selectingAssetList.count == 0) {
        if (callback) callback(dataLength);
    } else {
        for (PHAsset *asset in self.selectingAssetList) {
            [asset jm_imageDataCompletion:^(NSData * _Nonnull imageData) {
                dataLength += imageData.length;
                if (callback) callback(dataLength);
            }];
        }
    }
}

- (NSArray<PHAsset *> *)selectingAssetList {
    if (!_selectingAssetList) {
        _selectingAssetList = [NSArray array];
    }
    return _selectingAssetList;
}

- (NSArray<PHAsset *> *)selectingImageList {
    if (!_selectingImageList) {
        _selectingImageList = [NSArray array];
    }
    return _selectingImageList;
}

- (NSArray<PHAsset *> *)selectingVideoList {
    if (!_selectingVideoList) {
        _selectingVideoList = [NSArray array];
    }
    return _selectingVideoList;
}

#pragma mark - setter

- (void)setSelectingAssetList:(NSArray<PHAsset *> *)selectingAssetList {
    _selectingAssetList = selectingAssetList;
    
    for (PHAssetCollection *collection in self.assetCollectionList) {
        NSMutableArray *assetListSelecting = [NSMutableArray array];
        for (PHAsset *selectingAsset in selectingAssetList) {
            if ([collection.assetList containsObject:selectingAsset]) {
                [assetListSelecting addObject:selectingAsset];
            }
        }
        collection.assetListSelecting = [assetListSelecting copy];
    }
}

@end
