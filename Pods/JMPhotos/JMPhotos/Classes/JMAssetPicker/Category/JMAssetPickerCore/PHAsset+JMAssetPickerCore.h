//
//  PHAsset+JMAssetPickerCore.h
//  JMAssetPicker
//
//  Created by ZhengXianda on 2022/6/13.
//

#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@class JMAssetPickerCore;
@interface PHAsset ()

@property (nonatomic, strong) JMAssetPickerCore *jmipcore;
@property (nonatomic, assign) BOOL selectingCeiling;
@property (nonatomic, assign) BOOL selectingIncompatible;

@property (nonatomic, strong) UIImage *jmipposter;
@property (nonatomic, strong) UIImage *jmipimage;

@end

@interface PHAsset (JMAssetPickerCore)

- (BOOL)jmip_filter:(JMAssetPickerCore *)core;

- (PHImageRequestID)jmip_posterCompletion:(void (^)(UIImage *image))completion;
- (PHImageRequestID)jmip_imageCompletion:(void (^)(UIImage *image))completion;

@end

NS_ASSUME_NONNULL_END
