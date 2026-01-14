//
//  JMPhotosToolView.h
//  JMAssetPicker
//
//  Created by ZhengXianda on 2022/7/4.
//

#import <UIKit/UIKit.h>

@class JMDotView;

NS_ASSUME_NONNULL_BEGIN

@interface JMPhotosToolView : UIView

@property (nonatomic, assign) BOOL isAllowOriginal;
@property (nonatomic, strong) NSString *originalSize;
@property (nonatomic, assign) NSUInteger selectedCount;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UILabel *previewTitleLabel;
@property (nonatomic, strong) UIButton *previewButton;

@property (nonatomic, strong) JMDotView *originalStatusDotView;
@property (nonatomic, strong) UILabel *originalTitleLabel;
@property (nonatomic, strong) UILabel *originalSizeLabel;
@property (nonatomic, strong) UIButton *originalButton;

@property (nonatomic, strong) UILabel *finishTitleLabel;
@property (nonatomic, strong) UIButton *finishButton;
@property (nonatomic, strong) JMDotView *selectedCountDotView;

@end

NS_ASSUME_NONNULL_END
