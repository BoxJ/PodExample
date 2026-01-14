//
//  JMPreviewCollectionViewCell.h
//  JMAssetPicker
//
//  Created by ZhengXianda on 2022/9/22.
//

#import <JMUIKit/JMUIKit.h>

@class PHAsset;

NS_ASSUME_NONNULL_BEGIN

@interface JMPreviewCollectionViewCellModel : JMCollectionViewCellModel

@property (nonatomic, strong) PHAsset *asset;

@property (nonatomic, strong) JMCollectionViewCellEvent tapAction;
@property (nonatomic, strong) JMCollectionViewCellEvent unfoldAction;
@property (nonatomic, strong) JMCollectionViewCellEvent foldAction;

- (instancetype)initWithAsset:(PHAsset *)asset;

@end

@interface JMPreviewCollectionViewCell : JMCollectionViewCell

@property (nonatomic, strong) JMZoomView *zoomView;

- (void)tapAction;
- (void)unfoldAction;
- (void)foldAction;

@end

NS_ASSUME_NONNULL_END
