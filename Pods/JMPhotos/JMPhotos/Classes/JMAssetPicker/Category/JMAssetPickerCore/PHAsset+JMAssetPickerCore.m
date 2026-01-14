//
//  PHAsset+JMAssetPickerCore.m
//  JMAssetPicker
//
//  Created by ZhengXianda on 2022/6/13.
//

#import "PHAsset+JMAssetPickerCore.h"

#import <objc/runtime.h>
#import <JMUIKit/JMUIKit.h>

#import "JMAssetPickerCore.h"

#import "PHAsset+JMExtension.h"
#import "PHAsset+JMAssetPicker.h"

@implementation PHAsset (JMAssetPickerCore)

- (BOOL)jmip_filter:(JMAssetPickerCore *)core {
    self.jmipcore = core;
    
    if (!self.jmipcore.allowPickingVideo && self.mediaType == PHAssetMediaTypeVideo) return NO;
    if (!self.jmipcore.allowPickingImage && self.mediaType == PHAssetMediaTypeImage) return NO;
    if (self.jmipcore.isSizeLimitValid) {
        if (self.jmipcore.sizeLimitMin.width > self.pixelWidth) return NO;
        if (self.jmipcore.sizeLimitMin.height > self.pixelHeight) return NO;
    }
    
    return YES;
}

- (PHImageRequestID)jmip_posterCompletion:(void (^)(UIImage *image))completion {
    __weak typeof(self) weakSelf = self;
    
    if (self.jmipposter) {
        if (completion) completion(self.jmipposter);
        return 0;
    } else {
        return [self jm_imageDisplaySize:[self displaySize:self.jmipcore.assetSize.width]
                             allowICloud:self.jmipcore.allowDownloadFromICloud
                         progressHandler:^(double progress, BOOL * _Nonnull stop, NSError * _Nonnull error, NSDictionary * _Nonnull info) {
            
        } completion:^(UIImage * _Nonnull image, NSDictionary * _Nonnull info, BOOL isDegraded) {
            weakSelf.jmipimage = image;
            if (completion) completion(image);
        }];
    }
}

- (PHImageRequestID)jmip_imageCompletion:(void (^)(UIImage *image))completion {
    __weak typeof(self) weakSelf = self;
    
    if (self.jmipimage) {
        if (completion) completion(self.jmipimage);
        return 0;
    } else {
        return [self jm_imageDisplaySize:[self displaySize:kScreenWidth]
                             allowICloud:self.jmipcore.allowDownloadFromICloud
                         progressHandler:^(double progress, BOOL * _Nonnull stop, NSError * _Nonnull error, NSDictionary * _Nonnull info) {
            
        } completion:^(UIImage * _Nonnull image, NSDictionary * _Nonnull info, BOOL isDegraded) {
            weakSelf.jmipimage = image;
            if (completion) completion(image);
        }];
    }
}

#pragma mark - setter

- (void)setJmipcore:(JMAssetPickerCore *)jmipcore {
    objc_setAssociatedObject(self, @"jmipcore", jmipcore, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setJmipposter:(UIImage *)jmipposter {
    objc_setAssociatedObject(self, @"jmipposter", jmipposter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setJmipimage:(UIImage *)jmipimage {
    objc_setAssociatedObject(self, @"jmipimage", jmipimage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - getter

- (JMAssetPickerCore *)jmipcore {
    return objc_getAssociatedObject(self, @"jmipcore");
}

- (BOOL)selectingCeiling {
    return self.selectedIndex <= 0 && self.jmipcore.selectingCeiling;
}

- (BOOL)selectingIncompatible {
    return self.selectedIndex <= 0 &&
    ((self.jmipcore.selectingImageCeiling && self.mediaType == PHAssetMediaTypeImage) ||
     (self.jmipcore.selectingVideoCeiling && self.mediaType == PHAssetMediaTypeVideo));
}

- (UIImage *)jmipposter {
    return objc_getAssociatedObject(self, @"jmipposter");
}

- (UIImage *)jmipimage {
    return objc_getAssociatedObject(self, @"jmipimage");
}

@end
