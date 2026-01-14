//
//  PHAssetCollection+JMAssetPicker.h
//  JMAssetPicker
//
//  Created by ZhengXianda on 2022/6/8.
//

#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface PHAssetCollection ()

@property (nonatomic, assign) BOOL isRecents;

@property (nonatomic, strong) NSArray <PHAsset *> *assetList;
@property (nonatomic, strong) NSArray <PHAsset *> *assetListSelecting;
@property (nonatomic, strong) PHAsset *posterAsset;

@end

@interface PHAssetCollection (JMAssetPicker)

@end

NS_ASSUME_NONNULL_END
