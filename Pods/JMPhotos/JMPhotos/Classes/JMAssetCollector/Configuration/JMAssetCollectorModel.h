//
//  JMAssetCollectorModel.h
//  JMImagePickerController_Example
//
//  Created by ZhengXianda on 2022/9/29.
//  Copyright © 2022 ZhengXianda. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <JMPhotos/JMAssetCollectorCore.h>

NS_ASSUME_NONNULL_BEGIN

@class JMAssetCollectorModel;
@protocol JMAssetCollectorModelDelegate <NSObject>

- (void)assetCollectorExecute:(JMAssetCollectorModel *)model;
- (void)assetCollectorDidChange:(JMAssetCollectorModel *)model;

@end

@interface JMAssetCollectorModel : NSObject

@property (nonatomic, strong) JMAssetCollectorCore *core;
- (instancetype)initWithImageSelectorCore:(JMAssetCollectorCore *)core;

#pragma mark - delegate

@property (nonatomic, weak) id<JMAssetCollectorModelDelegate> delegate;
- (void)d_assetCollectorExecute;
- (void)d_assetCollectorDidChange;

#pragma mark - select

- (BOOL)select:(PHAsset *)asset;
- (void)update:(NSArray <PHAsset *> *)assetList;
- (void)removeAllSelectedAsset;
- (void)selectingAssetImageList:(void(^)(NSArray *imageList))callback;
- (CGFloat)selectingHeight;
@property (nonatomic, strong) NSArray<PHAsset *> *selectingAssetList;

@end

NS_ASSUME_NONNULL_END
