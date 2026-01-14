//
//  JMPhotos.m
//  JMPhotos
//
//  Created by ZhengXianda on 10/18/22.
//

#import "JMPhotos.h"

#import <JMUIKit/JMUIKit.h>

@implementation JMPhotos

+ (void)requestAuthorization:(void(^)(PHAuthorizationStatus status))handler {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (handler) {
                handler(status);
            }
        });
    }];
}

+ (void)requestAuthorizationForAccessLevel:(PHAccessLevel)accessLevel handler:(void(^)(PHAuthorizationStatus status))handler {
    [PHPhotoLibrary requestAuthorizationForAccessLevel:accessLevel handler:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (handler) {
                handler(status);
            }
        });
    }];
}

+ (void)showImagePickerCore:(JMAssetPickerCore *)core on:(UIViewController *)viewController {
    JMAssetPickerModel *model = [[JMAssetPickerModel alloc] initWithImagePickerCore:core];
    __block JMAlbumViewController *album = [[JMAlbumViewController alloc] initWithImagePickerModel:model];
    
    JMPortraitNavigationController *nav = [[JMPortraitNavigationController alloc] initWithRootViewController:album];
    nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [viewController presentViewController:nav animated:YES completion:^{
        
    }];
    [album showPickerViewController:0 animated:NO];
}

+ (void)showImagePickerModel:(JMAssetPickerModel *)model on:(UIViewController *)viewController {
    __block JMAlbumViewController *album = [[JMAlbumViewController alloc] initWithImagePickerModel:model];
    
    JMPortraitNavigationController *nav = [[JMPortraitNavigationController alloc] initWithRootViewController:album];
    nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
    
    [viewController presentViewController:nav animated:YES completion:^{
        
    }];
    [album showPickerViewController:0 animated:NO];
}

@end
