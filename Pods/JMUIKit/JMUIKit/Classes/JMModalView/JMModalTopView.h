//
//  JMModalTopView.h
//  JMUIKit
//
//  Created by Thief Toki on 2020/8/4.
//

#import <UIKit/UIKit.h>

#import <JMTheme/JMTheme.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, JMModalTopType) {
    JMModalTopType_Logo = 1 << 0,
    JMModalTopType_GoBack = 1 << 1,
    JMModalTopType_Close = 1 << 2,
};

JMThemeDeclare(JMModalTopView, logoImage, backButtonImage, closeButtonImage);

@interface JMModalTopView : UIView

@property (nonatomic, assign) JMModalTopType type;

@property (nonatomic, assign) BOOL isLocked;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UIButton *goBackButton;
@property (nonatomic, strong) UIButton *closeButton;

- (instancetype)initWithType:(JMModalTopType)type;
- (void)upadteType:(JMModalTopType)type;

@end

NS_ASSUME_NONNULL_END
