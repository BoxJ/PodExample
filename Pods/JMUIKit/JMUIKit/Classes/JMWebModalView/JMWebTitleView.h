//
//  JMWebTitleView.h
//  JMUIKit
//
//  Created by Thief Toki on 2020/9/16.
//

#import <UIKit/UIKit.h>

#import <JMTheme/JMTheme.h>

NS_ASSUME_NONNULL_BEGIN

JMThemeDeclare(JMWebTitleView, backButtonImage);

@interface JMWebTitleView : UIView

@property (nonatomic, strong) UIView *statusView;

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIButton *goBackButton;
@property (nonatomic, strong) UILabel *titleLabel;

@end

NS_ASSUME_NONNULL_END
