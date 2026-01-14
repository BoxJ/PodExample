//
//  JMCompositeTitleView.h
//  JMUIKit
//
//  Created by Thief Toki on 2020/8/7.
//

#import <UIKit/UIKit.h>

#import <JMTheme/JMTheme.h>

NS_ASSUME_NONNULL_BEGIN

JMThemeDeclare(JMCompositeTitleView, titleFont);

@interface JMCompositeTitleView : UIView

@property (nonatomic, assign) CGFloat space;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;

@end

NS_ASSUME_NONNULL_END
