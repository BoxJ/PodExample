//
//  JMAssetTaker.h
//  JMAssetTaker
//
//  Created by ZhengXianda on 10/04/2022.
//  Copyright (c) 2022 ZhengXianda. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreServices/CoreServices.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^JMPhotoLibrarySaveCompletion)(PHAsset * _Nonnull asset, NSError * _Nonnull error);

@interface JMAssetTaker : NSObject <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, assign) BOOL allowTakeImage;
@property (nonatomic, assign) BOOL allowTakeMovie;
@property (nonatomic, strong) JMPhotoLibrarySaveCompletion saveCompletion;

#pragma mark - shared

+ (instancetype)shared;

#pragma mark - status

+ (void)requestAccessForMediaTypeVideo:(void(^)(AVAuthorizationStatus status))handler;

#pragma mark - action

+ (void)showAssetTakerOn:(UIViewController *)viewController;
+ (void)showAssetTakerOn:(UIViewController *)viewController saveCompletion:(JMPhotoLibrarySaveCompletion)saveCompletion;
+ (void)showAssetTakerOn:(UIViewController *)viewController mediaTypes:(NSArray <NSString *> *)mediaTypes saveCompletion:(JMPhotoLibrarySaveCompletion)saveCompletion;

@end

NS_ASSUME_NONNULL_END
