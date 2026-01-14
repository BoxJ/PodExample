//
//  JMPickerViewController.h
//  JMAssetPicker
//
//  Created by ZhengXianda on 2022/6/13.
//

#import <UIKit/UIKit.h>

#import <JMPhotos/JMAssetPickerModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMPickerViewController : UIViewController

- (instancetype)initWithImagePickerModel:(JMAssetPickerModel *)model index:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
