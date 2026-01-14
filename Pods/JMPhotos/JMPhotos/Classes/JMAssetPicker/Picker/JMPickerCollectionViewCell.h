//
//  JMPickerCollectionViewCell.h
//  JMAssetPicker
//
//  Created by ZhengXianda on 2022/6/15.
//

#import <JMUIKit/JMUIKit.h>

#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMPickerCollectionViewCellModel : JMCollectionViewCellModel

@property (nonatomic, strong) PHAsset *asset;

@property (nonatomic, strong) JMCollectionViewCellEvent selectedAction;

- (instancetype)initWithAsset:(PHAsset *)asset;

@end

@interface JMPickerCollectionViewCell : JMCollectionViewCell

- (void)selectedAction;

@end

NS_ASSUME_NONNULL_END
