//
//  JMAssetPickerModel.h
//  JMAssetPicker
//
//  Created by ZhengXianda on 2022/6/17.
//

#import <Foundation/Foundation.h>

#import <Photos/Photos.h>

typedef enum : NSUInteger {
    JMIPSelectingStatusUnkonw,  //未知
    JMIPSelectingStatusStillRemaining, // 仍然 有空余
    JMIPSelectingStatusStillCeiling, // 仍然 无空余
    JMIPSelectingStatusBecameRemaining, // 变成 有空余
    JMIPSelectingStatusBecameCeiling, // 变成 无空余
    JMIPSelectingStatusIncompatible,  // 不兼容，allowPickingMultipleType 关闭时，不可同时选择图片和视频
} JMIPSelectingStatus;

NS_ASSUME_NONNULL_BEGIN

@class JMAssetPickerModel;
@protocol JMAssetPickerModelDelegate <NSObject>

- (void)assetPickerSelectingDidFinish:(JMAssetPickerModel *)model;

@end

@class JMAssetPickerCore;
@interface JMAssetPickerModel : NSObject

@property (nonatomic, strong) JMAssetPickerCore *core;
- (instancetype)initWithImagePickerCore:(JMAssetPickerCore *)core;

#pragma mark - delegate

@property (nonatomic, weak) id<JMAssetPickerModelDelegate> delegate;
- (void)d_assetPickerSelectingDidFinish;

#pragma mark - fetch

- (void)fetchAlbums;
@property (nonatomic, strong) NSArray<PHAssetCollection *> *assetCollectionList;

#pragma mark - select

- (JMIPSelectingStatus)select:(PHAsset *)asset;
- (void)update:(NSArray <PHAsset *> *)assetList;
- (void)removeAllSelectedAsset;
- (void)selectingAssetDataLength:(void(^)(NSUInteger dataLength))callback;
@property (nonatomic, strong) NSArray<PHAsset *> *selectingAssetList;
@property (nonatomic, strong) NSArray<PHAsset *> *selectingImageList;
@property (nonatomic, strong) NSArray<PHAsset *> *selectingVideoList;

@end

NS_ASSUME_NONNULL_END
