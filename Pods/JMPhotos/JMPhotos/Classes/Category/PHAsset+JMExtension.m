//
//  PHAsset+JMExtension.m
//  JMUtils
//
//  Created by ZhengXianda on 2022/9/28.
//

#import "PHAsset+JMExtension.h"

#import <objc/runtime.h>

#import <JMUIKit/JMUIKit.h>

@implementation PHAsset (JMExtension)

- (PHImageRequestID)jm_imageDisplaySize:(CGSize)displaySize allowICloud:(BOOL)allowICloud progressHandler:(void (^)(double progress, BOOL *stop, NSError *error, NSDictionary *info))progressHandler completion:(void (^)(UIImage *photo, NSDictionary *info, BOOL isDegraded))completion {
    __weak typeof(self) weakSelf = self;
    PHImageRequestID imageRequestID = 0;
    
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    imageRequestID =
    [[PHImageManager defaultManager] requestImageForAsset:self
                                               targetSize:displaySize
                                              contentMode:PHImageContentModeAspectFill
                                                  options:option
                                            resultHandler:^(UIImage *image, NSDictionary *info) {
        BOOL cancelled = [[info objectForKey:PHImageCancelledKey] boolValue];
        if (!cancelled && image) {
            if (completion) {
                completion([image fixOrientation], info, [[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
            }
        }
        
        if ([info objectForKey:PHImageResultIsInCloudKey]
            && !image
            && allowICloud) {
            [weakSelf jm_imageDataProgressHandler:progressHandler completion:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
                UIImage *image = [UIImage imageWithData:imageData];
                if (image) {
                    image = [image scaleToSize:displaySize];
                    if (completion) {
                        completion([image fixOrientation], info, NO);
                    }
                }
            }];
        }
    }];
    return imageRequestID;
}

- (PHImageRequestID)jm_imageDataCompletion:(void (^)(NSData *imageData))completion {
    __weak typeof(self) weakSelf = self;
    
    if (self.jm_imageData) {
        if (completion) completion(self.jm_imageData);
        return 0;
    } else {
        return [self jm_imageDataProgressHandler:^(double progress, BOOL *stop, NSError *error, NSDictionary *info) {
            
        } completion:^(NSData *data, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info) {
            weakSelf.jm_imageData = data;
            if (completion) completion(data);
        }];
    }
}

- (PHImageRequestID)jm_imageDataProgressHandler:(void (^)(double progress, BOOL *stop, NSError *error, NSDictionary *info))progressHandler completion:(void (^)(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info))completion {
    PHImageRequestID imageRequestID = 0;
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (progressHandler) {
                progressHandler(progress, stop, error, info);
            }
        });
    };
    options.networkAccessAllowed = YES;
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    
    imageRequestID =
    [[PHImageManager defaultManager] requestImageDataForAsset:self
                                                      options:options
                                                resultHandler:^(NSData *imageData,
                                                                NSString *dataUTI,
                                                                UIImageOrientation orientation,
                                                                NSDictionary *info) {
        completion(imageData, dataUTI, orientation, info);
    }];
    
    return imageRequestID;
}

- (PHImageRequestID)jm_videoDataCompletion:(void (^)(NSData *videoData))completion {
    __weak typeof(self) weakSelf = self;
    
    if (self.jm_videoData) {
        if (completion) completion(self.jm_videoData);
        return 0;
    } else {
        return [self jm_playerItemCompletion:^(AVPlayerItem *playerItem) {
            NSURL *URL = [(AVURLAsset *)playerItem.asset URL];
            NSData *videoData = [NSData dataWithContentsOfURL:URL];
            weakSelf.jm_videoData = videoData;
            if (completion) completion(videoData);
        }];
    }
}

- (PHImageRequestID)jm_playerItemCompletion:(void (^)(AVPlayerItem *playerItem))completion {
    __weak typeof(self) weakSelf = self;
    
    if (self.jm_playerItem) {
        if (completion) completion(self.jm_playerItem);
        return 0;
    } else {
        return [self jm_playerItemProgressHandler:^(double progress, BOOL *stop, NSError *error, NSDictionary *info) {
            
        } completion:^(AVPlayerItem *playerItem, NSDictionary *info) {
            weakSelf.jm_playerItem = playerItem;
            if (completion) completion(playerItem);
        }];
    }
}

- (PHImageRequestID)jm_playerItemProgressHandler:(void (^)(double progress, BOOL *stop, NSError *error, NSDictionary *info))progressHandler completion:(void (^)(AVPlayerItem *playerItem, NSDictionary *info))completion {
    PHImageRequestID imageRequestID = 0;
    
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (progressHandler) {
                progressHandler(progress, stop, error, info);
            }
        });
    };
    options.networkAccessAllowed = YES;
    imageRequestID =
    [[PHImageManager defaultManager] requestPlayerItemForVideo:self
                                                       options:options
                                                 resultHandler:^(AVPlayerItem *playerItem, NSDictionary *info) {
        if (completion) completion(playerItem, info);
    }];
    
    return imageRequestID;
}

#pragma mark - setter

- (void)setJm_imageData:(NSData *)jm_imageData {
    objc_setAssociatedObject(self, @"jm_imageData", jm_imageData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setJm_videoData:(NSData *)jm_videoData {
    objc_setAssociatedObject(self, @"jm_videoData", jm_videoData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setJm_playerItem:(AVPlayerItem *)jm_playerItem {
    objc_setAssociatedObject(self, @"jm_playerItem", jm_playerItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - getter

- (NSData *)jm_imageData {
    return objc_getAssociatedObject(self, @"jm_imageData");
}

- (NSData *)jm_videoData {
    return objc_getAssociatedObject(self, @"jm_videoData");
}

- (AVPlayerItem *)jm_playerItem {
    return objc_getAssociatedObject(self, @"jm_playerItem");
}

@end
