//
//  JMPreviewViewController.h
//  JMAssetPicker
//
//  Created by ZhengXianda on 2022/9/19.
//

#import <Foundation/Foundation.h>

#import <JMPhotos/JMAssetPickerModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMPreviewViewController : UIViewController

- (instancetype)initWithImagePickerModel:(JMAssetPickerModel *)model
                              collection:(PHAssetCollection *)collection
                           onlySelecting:(BOOL)isOnlySelecting
                                   index:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
