//
//  PHAsset+JMExtension.h
//  JMUtils
//
//  Created by ZhengXianda on 2022/9/28.
//

#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface PHAsset (JMExtension)

@property (nonatomic, strong) NSData *jm_imageData;
@property (nonatomic, strong) NSData *jm_videoData;
@property (nonatomic, strong) AVPlayerItem *jm_playerItem;

- (PHImageRequestID)jm_imageDisplaySize:(CGSize)displaySize allowICloud:(BOOL)allowICloud progressHandler:(void (^)(double progress, BOOL *stop, NSError *error, NSDictionary *info))progressHandler completion:(void (^)(UIImage *photo, NSDictionary *info, BOOL isDegraded))completion;

- (PHImageRequestID)jm_imageDataCompletion:(void (^)(NSData *imageData))completion;
- (PHImageRequestID)jm_imageDataProgressHandler:(void (^)(double progress, BOOL *stop, NSError *error, NSDictionary *info))progressHandler completion:(void (^)(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info))completion;

- (PHImageRequestID)jm_videoDataCompletion:(void (^)(NSData *videoData))completion;
- (PHImageRequestID)jm_playerItemCompletion:(void (^)(AVPlayerItem *playerItem))completion;
- (PHImageRequestID)jm_playerItemProgressHandler:(void (^)(double progress, BOOL *stop, NSError *error, NSDictionary *info))progressHandler completion:(void (^)(AVPlayerItem *playerItem, NSDictionary *info))completion;

@end

NS_ASSUME_NONNULL_END
