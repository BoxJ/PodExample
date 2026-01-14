//
//  PHPhotoLibrary+JMExtension.h
//  JMUtils
//
//  Created by ZhengXianda on 2022/10/4.
//

#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface PHPhotoLibrary (JMExtension)

@property (nonatomic, assign) int jm_retryCount;
@property (nonatomic, assign) float jm_retryInterval;

- (void)jm_saveImage:(UIImage *)image completion:(void (^)(PHAsset *asset, NSError *error))completion;
- (void)jm_saveImage:(UIImage *)image meta:(NSDictionary *)meta completion:(void (^)(PHAsset *asset, NSError *error))completion;
- (void)jm_saveVideoURL:(NSURL *)videoURL completion:(void (^)(PHAsset *asset, NSError *error))completion;

- (void)jm_changeRequest:(PHAssetChangeRequest *(^)(void))requestCreator completion:(void (^)(PHAsset *asset, NSError *error))completion;
- (void)jm_fetchIocalIdentifier:(NSString *)localIdentifier retryCount:(NSInteger)retryCount completion:(void (^)(PHAsset *asset, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
