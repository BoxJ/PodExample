//
//  JMAssetTaker.m
//  JMAssetTaker
//
//  Created by ZhengXianda on 10/04/2022.
//  Copyright (c) 2022 ZhengXianda. All rights reserved.
//

#import "JMAssetTaker.h"

#import "JMLogger.h"
#import "PHPhotoLibrary+JMExtension.h"

@implementation JMAssetTaker

#pragma mark - shared

+ (instancetype)shared {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - status

+ (void)requestAccessForMediaTypeVideo:(void(^)(AVAuthorizationStatus status))handler {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusNotDetermined) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                    if (handler) handler(AVAuthorizationStatusAuthorized);
                } else {
                    if (handler) handler(AVAuthorizationStatusDenied);
                }
            });
        }];
    } else {
        if (handler) handler(status);
    }
}

#pragma mark - action

+ (void)showAssetTakerOn:(UIViewController *)viewController {
    JMAssetTaker *assetTaker = [JMAssetTaker shared];
    
    [self showAssetTakerOn:viewController saveCompletion:assetTaker.saveCompletion];
}

+ (void)showAssetTakerOn:(UIViewController *)viewController saveCompletion:(JMPhotoLibrarySaveCompletion)saveCompletion {
    JMAssetTaker *assetTaker = [JMAssetTaker shared];
    NSMutableArray *mediaTypes = [NSMutableArray array];
    if (assetTaker.allowTakeImage) [mediaTypes addObject:(NSString *)kUTTypeImage];
    if (assetTaker.allowTakeMovie) [mediaTypes addObject:(NSString *)kUTTypeMovie];
    
    [self showAssetTakerOn:viewController mediaTypes:mediaTypes saveCompletion:saveCompletion];
}

+ (void)showAssetTakerOn:(UIViewController *)viewController mediaTypes:(NSArray <NSString *> *)mediaTypes saveCompletion:(JMPhotoLibrarySaveCompletion)saveCompletion {
    JMAssetTaker *assetTaker = [JMAssetTaker shared];
    assetTaker.saveCompletion = saveCompletion;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *cameraController = [[UIImagePickerController alloc] init];
        cameraController.delegate = assetTaker;
        cameraController.sourceType = UIImagePickerControllerSourceTypeCamera;
        cameraController.mediaTypes = mediaTypes;
        
        [viewController presentViewController:cameraController animated:YES completion:nil];
    } else {
        JMLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

#pragma mark - protocol

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        [[PHPhotoLibrary sharedPhotoLibrary] jm_saveImage:(UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage]
                                                     meta:(NSDictionary *)[info objectForKey:UIImagePickerControllerMediaMetadata]
                                               completion:self.saveCompletion];
    }
    if ([type isEqualToString:@"public.movie"]) {
        [[PHPhotoLibrary sharedPhotoLibrary] jm_saveVideoURL:(NSURL *)[info objectForKey:UIImagePickerControllerMediaURL]
                                                  completion:self.saveCompletion];
    }
}

@end
