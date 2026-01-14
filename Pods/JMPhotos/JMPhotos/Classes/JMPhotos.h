//
//  JMPhotos.h
//  JMPhotos
//
//  Created by ZhengXianda on 10/18/2022.
//  Copyright (c) 2022 ZhengXianda. All rights reserved.
//

#import <Photos/Photos.h>

#import <JMUIKit/JMUIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreServices/CoreServices.h>

#import <JMPhotos/PHAsset+JMExtension.h>
#import <JMPhotos/PHPhotoLibrary+JMExtension.h>

#import <JMPhotos/JMAssetTaker.h>

#import <JMPhotos/JMAssetCollectorCore.h>
#import <JMPhotos/JMAssetCollectorModel.h>
#import <JMPhotos/JMAssetCollector.h>
#import <JMPhotos/PHAsset+JMAssetCollectorCore.h>

#import <JMPhotos/JMAssetPickerCore.h>
#import <JMPhotos/JMAssetPickerModel.h>
#import <JMPhotos/JMAlbumViewController.h>
#import <JMPhotos/JMPickerViewController.h>
#import <JMPhotos/JMPreviewViewController.h>
#import <JMPhotos/PHAsset+JMAssetPicker.h>
#import <JMPhotos/PHAsset+JMAssetPickerCore.h>
#import <JMPhotos/PHAssetCollection+JMAssetPicker.h>
#import <JMPhotos/PHAssetCollection+JMAssetPickerCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMPhotos : NSObject

+ (void)requestAuthorization:(void(^)(PHAuthorizationStatus status))handler API_DEPRECATED_WITH_REPLACEMENT("+requestAuthorizationForAccessLevel:handler:", ios(8, API_TO_BE_DEPRECATED), macos(10.13, API_TO_BE_DEPRECATED), tvos(10, API_TO_BE_DEPRECATED));

+ (void)requestAuthorizationForAccessLevel:(PHAccessLevel)accessLevel handler:(void(^)(PHAuthorizationStatus status))handler API_AVAILABLE(macosx(11.0), ios(14), tvos(14)) NS_SWIFT_ASYNC(2);

+ (void)showImagePickerCore:(JMAssetPickerCore *)core on:(UIViewController *)viewController;
+ (void)showImagePickerModel:(JMAssetPickerModel *)model on:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
