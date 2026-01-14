//
//  JMPhotosTimeView.h
//  JMAssetPicker
//
//  Created by ZhengXianda on 2022/6/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMPhotosTimeView : UIView

@property (nonatomic, assign) NSTimeInterval time;
@property (nonatomic, strong) NSString *timeString;

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *timeLabel;

@end

NS_ASSUME_NONNULL_END
