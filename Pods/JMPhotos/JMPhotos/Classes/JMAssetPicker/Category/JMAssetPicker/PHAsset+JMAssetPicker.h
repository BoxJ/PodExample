//
//  PHAsset+JMAssetPicker.h
//  JMAssetPicker
//
//  Created by ZhengXianda on 2022/6/8.
//

#import <Photos/Photos.h>

typedef enum : NSUInteger {
    PHAssetImageTypeNone,
    PHAssetImageTypePhoto,
    PHAssetImageTypeLive,
    PHAssetImageTypeGif,
} PHAssetImageType;

NS_ASSUME_NONNULL_BEGIN

@interface PHAsset ()

/// 图片细分类型
@property (nonatomic, assign, readonly) PHAssetImageType imageType;

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) BOOL isICloudFailed;

@end

@interface PHAsset (JMAssetPicker)

- (CGSize)displaySize:(CGFloat)displayWidth;

@end

NS_ASSUME_NONNULL_END
