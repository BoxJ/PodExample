//
//  JMToastView.h
//  JMUIKit
//
//  Created by Thief Toki on 2020/8/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMToastView : UIView

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *boardView;
@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, assign) BOOL isShow;

- (void)setupBoardView;

- (void)showToast:(NSString *)message;
- (void)dismissDelay:(NSTimeInterval)delay;
- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
