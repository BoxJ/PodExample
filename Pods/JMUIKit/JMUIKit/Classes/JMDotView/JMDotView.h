//
//  JMDotView.h
//  JMUIKit
//
//  Created by ZhengXianda on 2022/6/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMDotView : UIView

@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, assign, getter = isActive) BOOL active;

@property (nonatomic, strong) UIImageView *idleImageView;
@property (nonatomic, strong) UIImageView *activeImageView;
@property (nonatomic, strong) UILabel *indexLabel; ///<  index < 0时不显示

@end

NS_ASSUME_NONNULL_END
