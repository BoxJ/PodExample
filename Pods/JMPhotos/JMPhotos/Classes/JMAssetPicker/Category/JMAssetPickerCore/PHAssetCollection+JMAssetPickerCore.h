//
//  PHAssetCollection+JMAssetPickerCore.h
//  JMAssetPicker
//
//  Created by ZhengXianda on 2022/6/17.
//

#import <Photos/Photos.h>

#import <JMPhotos/JMAssetPickerCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface PHAssetCollection ()

@property (nonatomic, strong) JMAssetPickerCore *jmipcore;

@end

@interface PHAssetCollection (JMAssetPickerCore)

- (BOOL)jmip_filter:(JMAssetPickerCore *)core;

- (PHAsset *)jmip_posterAsset;

@end

NS_ASSUME_NONNULL_END
