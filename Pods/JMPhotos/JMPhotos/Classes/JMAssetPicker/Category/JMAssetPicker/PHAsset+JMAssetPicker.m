//
//  PHAsset+JMAssetPicker.m
//  JMAssetPicker
//
//  Created by ZhengXianda on 2022/6/8.
//

#import "PHAsset+JMAssetPicker.h"

#import <objc/runtime.h>

@implementation PHAsset (JMAssetPicker)

#pragma mark - setter

- (void)setIsSelected:(BOOL)isSelected {
    objc_setAssociatedObject(self, @"isSelected", @(isSelected), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    objc_setAssociatedObject(self, @"selectedIndex", @(selectedIndex), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setIsICloudFailed:(BOOL)isICloudFailed {
    objc_setAssociatedObject(self, @"isICloudFailed", @(isICloudFailed), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - getter

- (PHAssetImageType)imageType {
    PHAssetImageType imageType = PHAssetImageTypeNone;
    if (self.mediaType == PHAssetMediaTypeImage) {
        imageType = PHAssetImageTypePhoto;
        if ([[self valueForKey:@"filename"] hasSuffix:@"GIF"]) {
            imageType = PHAssetImageTypeGif;
        }
//        暂时不启用
//        if (self.mediaSubtypes = PHAssetMediaSubtypePhotoLive) {
//            imageType = PHAssetImageTypeLive;
//        }
    }
    return imageType;
}

- (CGSize)displaySize:(CGFloat)displayWidth {
    CGFloat photoWidth = displayWidth;
    CGFloat aspectRatio = (CGFloat)(self.pixelWidth) / (CGFloat)(self.pixelHeight);
    // 超宽图片
    if (aspectRatio > 1.8) {
        photoWidth = photoWidth * 2;
    }
    // 超高图片
    if (aspectRatio < 0.2) {
        photoWidth = photoWidth / 2;
    }
    CGFloat photoHeight = photoWidth / aspectRatio;
    CGSize displaySize = CGSizeMake(photoWidth * 2.0, photoHeight * 2.0);
    return displaySize;
}

- (BOOL)isSelected {
    return [objc_getAssociatedObject(self, @"isSelected") boolValue];
}

- (NSInteger)selectedIndex {
    return [objc_getAssociatedObject(self, @"selectedIndex") integerValue];
}

- (BOOL)isICloudFailed {
    return [objc_getAssociatedObject(self, @"isICloudFailed") boolValue];
}

@end
