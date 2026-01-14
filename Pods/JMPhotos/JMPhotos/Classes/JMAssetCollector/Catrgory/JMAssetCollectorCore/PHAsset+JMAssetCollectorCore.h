//
//  PHAsset+JMAssetCollectorCore.h
//  JMImagePickerController
//
//  Created by ZhengXianda on 2022/6/13.
//

#import <Photos/Photos.h>

@class JMAssetCollectorCore;

NS_ASSUME_NONNULL_BEGIN

@interface PHAsset ()

@property (nonatomic, strong) JMAssetCollectorCore *jmiscore;

@property (nonatomic, strong) UIImage *jmisposter;

@end

@interface PHAsset (JMAssetCollectorCore)

- (PHImageRequestID)jmis_posterCompletion:(void (^)(UIImage *image))completion;

@end

NS_ASSUME_NONNULL_END
