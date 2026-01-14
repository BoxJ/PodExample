//
//  JMAssetCollectorItemCell.h
//  JMImagePickerController_Example
//
//  Created by ZhengXianda on 2022/9/27.
//  Copyright © 2022 ZhengXianda. All rights reserved.
//

#import <JMUIKit/JMUIKit.h>

#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMAssetCollectorItemCellModel : JMCollectionViewCellModel

@property (nonatomic, strong) PHAsset *asset;

@property (nonatomic, strong) JMCollectionViewCellEvent deleteAction;

- (instancetype)initWithAsset:(PHAsset *)asset;

@end

@interface JMAssetCollectorItemCell : JMCollectionViewCell

- (UIView *)snapshotView;

@end

NS_ASSUME_NONNULL_END
