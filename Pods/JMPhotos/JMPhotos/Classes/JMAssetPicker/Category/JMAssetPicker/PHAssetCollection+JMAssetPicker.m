//
//  PHAssetCollection+JMAssetPicker.m
//  JMAssetPicker
//
//  Created by ZhengXianda on 2022/6/8.
//

#import "PHAssetCollection+JMAssetPicker.h"

#import <objc/runtime.h>

@implementation PHAssetCollection (JMAssetPicker)

#pragma mark - setter

- (void)setAssetList:(NSArray<PHAsset *> *)assetList {
    objc_setAssociatedObject(self, "assetList", assetList, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setAssetListSelecting:(NSArray<PHAsset *> *)assetListSelecting {
    objc_setAssociatedObject(self, "assetListSelecting", assetListSelecting, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setPosterAsset:(PHAsset *)posterAsset {
    objc_setAssociatedObject(self, "posterAsset", posterAsset, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - getter

- (BOOL)isRecents {
    return self.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary;
}

- (NSArray<PHAsset *> *)assetList {
    return objc_getAssociatedObject(self, "assetList");
}

- (NSArray<PHAsset *> *)assetListSelecting {
    return objc_getAssociatedObject(self, "assetListSelecting");
}

- (PHAsset *)posterAsset {
    return objc_getAssociatedObject(self, "posterAsset");
}

@end
