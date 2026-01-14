//
//  JMAlbumViewController.h
//  JMAssetPicker
//
//  Created by ZhengXianda on 2022/6/7.
//

#import <UIKit/UIKit.h>

#import <JMPhotos/JMAssetPickerModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMAlbumViewController : UIViewController

- (instancetype)initWithImagePickerModel:(JMAssetPickerModel *)model;

- (void)showPickerViewController:(NSInteger)index animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
