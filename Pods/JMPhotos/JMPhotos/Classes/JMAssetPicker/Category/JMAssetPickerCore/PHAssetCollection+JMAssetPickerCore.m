//
//  PHAssetCollection+JMAssetPickerCore.m
//  JMAssetPicker
//
//  Created by ZhengXianda on 2022/6/17.
//

#import "PHAssetCollection+JMAssetPickerCore.h"

#import "PHAsset+JMAssetPickerCore.h"
#import "PHAssetCollection+JMAssetPicker.h"

#import <objc/runtime.h>

@implementation PHAssetCollection (JMAssetPickerCore)

- (BOOL)jmip_filter:(JMAssetPickerCore *)core {
    self.jmipcore = core;
    
    //过滤不可用的Collection
    if (![self isMemberOfClass:[PHAssetCollection class]]) return NO; // 过滤错误的实例
    if (self.estimatedAssetCount <= 0) return NO; // 过滤空相册
    if (self.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumAllHidden) return NO;  // 过滤全隐藏相册
    if (self.assetCollectionSubtype == 1000000201) return NO; // 过滤最近删除相册
    
    //筛选Asset集合
    NSMutableArray *assetList = [NSMutableArray array];
    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:self options:[self.jmipcore assetOptions]];
    for (PHAsset *asset in fetchResult) {
        if ([asset jmip_filter:core]) {
            [assetList addObject:asset];
        }
    }
    
    //过滤不可用的Asset集合
    if (assetList.count <= 0) return NO; // 过滤素材为空的相册
    
    self.assetList = [assetList copy];
    
    [self jmip_posterAsset];
    
    return YES;
}

- (PHAsset *)jmip_posterAsset {
    self.posterAsset = self.jmipcore.sortAscendingByCreationDate
    ? self.assetList.lastObject
    : self.assetList.firstObject;
    return self.posterAsset;
}

#pragma mark - setter

- (void)setJmipcore:(JMAssetPickerCore *)jmipcore {
    objc_setAssociatedObject(self, @"jmipcore", jmipcore, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - getter

- (JMAssetPickerCore *)jmipcore {
    return objc_getAssociatedObject(self, @"jmipcore");
}

@end
