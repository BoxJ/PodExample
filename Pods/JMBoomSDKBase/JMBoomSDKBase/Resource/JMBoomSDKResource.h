//
//  JMBoomSDKResource.h
//  JMBoomSDK
//
//  Created by ZhengXianda on 10/31/2022.
//  Copyright (c) 2022 ZhengXianda. All rights reserved.
//

#import <JMResource/JMResource.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JMBoomSDKResourceStyle) {
    JMBoomSDKResourceStyle_DEFAULT = 0,
    JMBoomSDKResourceStyle_BLACKGOLD,
    JMBoomSDKResourceStyle_BLUE,
    JMBoomSDKResourceStyle_ORANGE,
    JMBoomSDKResourceStyle_PURPLE,
};

//通用
UIKIT_EXTERN NSString *JMBRNCorner;
//按钮
UIKIT_EXTERN NSString *JMBRNButtonBackgroundColor;
UIKIT_EXTERN NSString *JMBRNButtonTitleFont;
UIKIT_EXTERN NSString *JMBRNButtonConfirmTitleColor;
UIKIT_EXTERN NSString *JMBRNButtonCancelTitleColor;
//窗口
UIKIT_EXTERN NSString *JMBRNWindowTitleFont;

UIKIT_EXTERN NSString *JMBRNWindowCheckboxSelected;
UIKIT_EXTERN NSString *JMBRNWindowCheckboxSelectedTintColor;
UIKIT_EXTERN NSString *JMBRNWindowCheckboxSelectedBackgroundColor;

UIKIT_EXTERN NSString *JMBRNWindowCheckboxUnselected;
UIKIT_EXTERN NSString *JMBRNWindowCheckboxUnselectedTintColor;
UIKIT_EXTERN NSString *JMBRNWindowCheckboxUnselectedBackgroundColor;

UIKIT_EXTERN NSString *JMBRNWindowPhoneIcon;
UIKIT_EXTERN NSString *JMBRNWindowPhoneIconTintColor;
UIKIT_EXTERN NSString *JMBRNWindowPhoneIconBackgroundColor;

UIKIT_EXTERN NSString *JMBRNWindowGuestIcon;
UIKIT_EXTERN NSString *JMBRNWindowGuestIconTintColor;
UIKIT_EXTERN NSString *JMBRNWindowGuestIconBackgroundColor;

@interface JMBoomSDKResource : JMResource

- (void)registerResourceStyle:(JMBoomSDKResourceStyle)style;

- (id)resourceWithName:(NSString *)name;
- (id)resourceValueWithName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
