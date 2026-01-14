//
//  JMPickerCameraCollectionViewCell.h
//  JMAssetPicker
//
//  Created by ZhengXianda on 2022/6/23.
//

#import <JMUIKit/JMUIKit.h>

#import <JMPhotos/JMAssetPickerCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMPickerCameraCollectionViewCellModel : JMCollectionViewCellModel

@property (nonatomic, strong) JMAssetPickerCore *core;

- (instancetype)initWithCore:(JMAssetPickerCore *)core;

@end

@interface JMPickerCameraCollectionViewCell : JMCollectionViewCell

@end

NS_ASSUME_NONNULL_END
