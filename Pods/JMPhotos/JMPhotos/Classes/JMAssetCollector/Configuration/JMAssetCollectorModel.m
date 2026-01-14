//
//  JMAssetCollectorModel.m
//  JMImagePickerController_Example
//
//  Created by ZhengXianda on 2022/9/29.
//  Copyright © 2022 ZhengXianda. All rights reserved.
//

#import "JMAssetCollectorModel.h"

#import <JMUIKit/JMUIKit.h>

#import "PHAsset+JMExtension.h"

@implementation JMAssetCollectorModel

- (instancetype)initWithImageSelectorCore:(JMAssetCollectorCore *)core {
    self = [super init];
    if (self) {
        self.core = core;
    }
    return self;
}

#pragma mark - delegate

- (void)d_assetCollectorExecute {
    if ([self.delegate respondsToSelector:@selector(assetCollectorExecute:)]) {
        [self.delegate assetCollectorExecute:self];
    }
}

- (void)d_assetCollectorDidChange {
    if ([self.delegate respondsToSelector:@selector(assetCollectorDidChange:)]) {
        [self.delegate assetCollectorDidChange:self];
    }
}

#pragma mark - select

- (BOOL)select:(PHAsset *)asset {
    NSMutableArray *selectingAssetList = [self.selectingAssetList mutableCopy];
    [selectingAssetList addObject:asset];
    self.selectingAssetList = [selectingAssetList copy];
    
    self.core.selectingCeiling = self.selectingAssetList.count >= self.core.selectedCountLimit;
    return self.core.selectingCeiling;
}

- (void)update:(NSArray <PHAsset *> *)assetList {
    [self removeAllSelectedAsset];
    
    for (PHAsset *asset in assetList) {
        BOOL ceiling = [self select:asset];
        if (ceiling) {
            return;
        }
    }
}

- (void)removeAllSelectedAsset {
    self.selectingAssetList = [NSArray array];
    self.core.selectingCeiling = NO;
}

- (void)selectingAssetImageList:(void(^)(NSArray *imageList))callback {
    __block NSMutableArray *imageList = [NSMutableArray array];
    __block NSInteger count = self.selectingAssetList.count;
    
    if (count == 0) {
        if (callback) callback([imageList copy]);
    } else {
        for (PHAsset *asset in self.selectingAssetList) {
            [asset jm_imageDisplaySize:CGSizeMake(kScreenWidth, kScreenHeight)
                           allowICloud:YES
                       progressHandler:^(double progress, BOOL * _Nonnull stop, NSError * _Nonnull error, NSDictionary * _Nonnull info) {
                
            } completion:^(UIImage * _Nonnull photo, NSDictionary * _Nonnull info, BOOL isDegraded) {
                if (!isDegraded) {
                    [imageList addObject:photo];
                    if (imageList.count == count) {
                        if (callback) callback([imageList copy]);
                    }
                }
            }];
        }
    }
}

- (CGFloat)selectingHeight {
    NSInteger selectingCount = MIN(self.selectingAssetList.count+1, self.core.selectedCountLimit);
    NSInteger rowCount = ceilf((float)selectingCount / (float)self.core.displayColumnNumber);
    return rowCount * self.core.assetSize.height + (rowCount - 1) + self.core.displayColumnSpace + self.core.displayInsets.top + self.core.displayInsets.bottom;
}

- (NSArray<PHAsset *> *)selectingAssetList {
    if (!_selectingAssetList) {
        _selectingAssetList = [NSArray array];
    }
    return _selectingAssetList;
}

@end
