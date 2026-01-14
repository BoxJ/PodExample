//
//  JMToastLoadingView.h
//  JMUIKit
//
//  Created by Thief Toki on 2020/8/4.
//

#import "JMToastView.h"

#import <JMTheme/JMTheme.h>

NS_ASSUME_NONNULL_BEGIN

JMThemeDeclare(JMToastLoadingView, loadingAnimationImages, loadingAnimationDuration);

@interface JMToastLoadingView : JMToastView

@property (nonatomic, strong) UIImageView *imageView;

@end

NS_ASSUME_NONNULL_END
