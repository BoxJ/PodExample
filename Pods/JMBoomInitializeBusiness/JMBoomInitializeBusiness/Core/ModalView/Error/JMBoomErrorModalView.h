//
//  JMBoomErrorModalView.h
//  JMBoomInitializeBusiness
//
//  Created by Thief Toki on 2020/8/10.
//

#import <JMUIKit/JMUIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomErrorModalView : JMModalView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) JMCommonButton *retryButton;

@end

NS_ASSUME_NONNULL_END
