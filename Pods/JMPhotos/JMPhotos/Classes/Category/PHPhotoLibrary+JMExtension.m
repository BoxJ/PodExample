//
//  PHPhotoLibrary+JMExtension.m
//  JMUtils
//
//  Created by ZhengXianda on 2022/10/4.
//

#import "PHPhotoLibrary+JMExtension.h"

#import "JMLogger.h"
#import "NSString+JMExtension.h"

#import <objc/runtime.h>
#import <CoreServices/CoreServices.h>

@implementation PHPhotoLibrary (JMExtension)

- (void)jm_saveImage:(UIImage *)image completion:(void (^)(PHAsset *asset, NSError *error))completion {
    [self jm_changeRequest:^PHAssetChangeRequest * _Nonnull{
        return [PHAssetChangeRequest creationRequestForAssetFromImage:image];
    } completion:^(PHAsset * _Nonnull asset, NSError * _Nonnull error) {
        if (completion) completion(asset, error);
    }];
}

- (void)jm_saveImage:(UIImage *)image meta:(NSDictionary *)meta completion:(void (^)(PHAsset *asset, NSError *error))completion {
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);
    NSString *path = [NSTemporaryDirectory() stringByAppendingFormat:@"%@.jpg", [NSString random:12]];
    NSURL *URL = [NSURL fileURLWithPath:path];
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)URL, kUTTypeJPEG, 1, NULL);
    CGImageDestinationAddImageFromSource(destination, source, 0, (__bridge CFDictionaryRef)meta);
    CGImageDestinationFinalize(destination);
    CFRelease(destination);
    CFRelease(source);
    
    [self jm_changeRequest:^PHAssetChangeRequest * _Nonnull{
        return [PHAssetChangeRequest creationRequestForAssetFromImageAtFileURL:URL];
    } completion:^(PHAsset * _Nonnull asset, NSError * _Nonnull error) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        if (completion) completion(asset, error);
    }];
}

- (void)jm_saveVideoURL:(NSURL *)videoURL completion:(void (^)(PHAsset *asset, NSError *error))completion {
    [self jm_changeRequest:^PHAssetChangeRequest * _Nonnull{
        return [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:videoURL];
    } completion:^(PHAsset * _Nonnull asset, NSError * _Nonnull error) {
        [[NSFileManager defaultManager] removeItemAtPath:videoURL.path error:nil];
        if (completion) completion(asset, error);
    }];
}

- (void)jm_changeRequest:(PHAssetChangeRequest *(^)(void))requestCreator completion:(void (^)(PHAsset *asset, NSError *error))completion {
    __block NSString *localIdentifier = nil;
    [self performChanges:^{
        PHAssetChangeRequest *request = requestCreator();
        request.creationDate = [NSDate date];
        
        localIdentifier = request.placeholderForCreatedAsset.localIdentifier;
    } completionHandler:^(BOOL success, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success && completion) {
                [self jm_fetchIocalIdentifier:localIdentifier retryCount:self.jm_retryCount completion:completion];
            }
            if (error) {
                JMLog(@"%@", error.localizedDescription);
                if (completion) completion(nil, error);
            }
        });
    }];
}

- (void)jm_fetchIocalIdentifier:(NSString *)localIdentifier retryCount:(NSInteger)retryCount completion:(void (^)(PHAsset *asset, NSError *error))completion {
    PHAsset *asset = [[PHAsset fetchAssetsWithLocalIdentifiers:@[localIdentifier] options:nil] firstObject];
    if (asset || retryCount <= 0) {
        if (completion) completion(asset, nil);
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.jm_retryInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self jm_fetchIocalIdentifier:localIdentifier retryCount:retryCount-1 completion:completion];
    });
}

#pragma mark - setter

- (void)setJm_retryCount:(int)jm_retryCount {
    objc_setAssociatedObject(self, @"jm_retryCount", @(jm_retryCount), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setJm_retryInterval:(float)jm_retryInterval {
    objc_setAssociatedObject(self, @"jm_retryInterval", @(jm_retryInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - getter

- (int)jm_retryCount {
    return [objc_getAssociatedObject(self, @"jm_retryCount") intValue];
}

- (float)jm_retryInterval {
    return [objc_getAssociatedObject(self, @"jm_retryInterval") floatValue];
}

@end
