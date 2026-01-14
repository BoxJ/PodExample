//
//  JMNavigatorView.h
//  JMUIKit
//
//  Created by ZhengXianda on 2022/9/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMNavigatorView : UIView

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *rightButton;

@end

NS_ASSUME_NONNULL_END
