//
//  JMBoomSDKResource.m
//  JMBoomSDK
//
//  Created by ZhengXianda on 10/31/2022.
//  Copyright (c) 2022 ZhengXianda. All rights reserved.
//

#import "JMBoomSDKResource.h"

#import <JMTheme/JMTheme.h>
#import <JMUIKit/JMUIKit.h>

// JiaMian Berserkly Resource Nail
NSString *JMBRNCorner = @"JMResourceFloatName:JMBRNCorner";

NSString *JMBRNButtonBackgroundColor = @"JMResourceColorName:JMBRNButtonBackgroundColor";
NSString *JMBRNButtonTitleFont = @"JMResourceFontName:JMBRNButtonTitleFont";
NSString *JMBRNButtonConfirmTitleColor = @"JMResourceColorName:JMBRNButtonConfirmTitleColor";
NSString *JMBRNButtonCancelTitleColor = @"JMResourceColorName:JMBRNButtonCancelTitleColor";

NSString *JMBRNWindowTitleFont = @"JMResourceFontName:JMBRNWindowTitleFont";

NSString *JMBRNWindowCheckboxSelected = @"JMResourceImageName:JMBRNWindowCheckboxSelected";
NSString *JMBRNWindowCheckboxSelectedTintColor = @"JMResourceColorName:JMBRNWindowCheckboxSelectedTintColor";
NSString *JMBRNWindowCheckboxSelectedBackgroundColor = @"JMResourceColorName:JMBRNWindowCheckboxSelectedBackgroundColor";
NSString *JMBRNWindowCheckboxUnselected = @"JMResourceImageName:JMBRNWindowCheckboxUnselected";
NSString *JMBRNWindowCheckboxUnselectedTintColor = @"JMResourceColorName:JMBRNWindowCheckboxUnselectedTintColor";
NSString *JMBRNWindowCheckboxUnselectedBackgroundColor = @"JMResourceColorName:JMBRNWindowCheckboxUnselectedBackgroundColor";

NSString *JMBRNWindowPhoneIcon = @"JMResourceImageName:JMBRNWindowPhoneIcon";
NSString *JMBRNWindowPhoneIconTintColor = @"JMResourceColorName:JMBRNWindowPhoneIconTintColor";
NSString *JMBRNWindowPhoneIconBackgroundColor = @"JMResourceColorName:JMBRNWindowPhoneIconBackgroundColor";

NSString *JMBRNWindowGuestIcon = @"JMResourceImageName:JMBRNWindowGuestIcon";
NSString *JMBRNWindowGuestIconTintColor = @"JMResourceColorName:JMBRNWindowGuestIconTintColor";
NSString *JMBRNWindowGuestIconBackgroundColor = @"JMResourceColorName:JMBRNWindowGuestIconBackgroundColor";

@interface JMBoomSDKResource ()

@property (nonatomic, assign) JMBoomSDKResourceStyle style;

@end

@implementation JMBoomSDKResource

- (NSString *)name {
    return @"JMBoomSDKBase";
}

- (NSDictionary *)resourceMapWithStyle:(JMBoomSDKResourceStyle)style {
    switch (style) {
        case JMBoomSDKResourceStyle_DEFAULT : {
            return @{
                JMBRNCorner: @"3",
                JMBRNButtonBackgroundColor: @"#FF6074FF",
                JMBRNButtonTitleFont: @"PingFangSC-Regular:15",
                JMBRNButtonConfirmTitleColor: @"#FFFFFFFF",
                JMBRNButtonCancelTitleColor: @"#FF666666",
                
                JMBRNWindowTitleFont: @"PingFangSC-Semibold:22",
                
                JMBRNWindowCheckboxSelected: @"boom_ic_selected",
                JMBRNWindowCheckboxSelectedTintColor: @"#FF6074FF",
                JMBRNWindowCheckboxSelectedBackgroundColor: @"#00000000",
                JMBRNWindowCheckboxUnselected: @"boom_ic_unselect",
                JMBRNWindowCheckboxUnselectedTintColor: @"#FFE9E9E9",
                JMBRNWindowCheckboxUnselectedBackgroundColor: @"#00000000",
                
                JMBRNWindowPhoneIcon: @"boom_ic_iphone",
                JMBRNWindowPhoneIconTintColor: @"#FFFFC470",
                JMBRNWindowPhoneIconBackgroundColor: @"#00000000",
                
                JMBRNWindowGuestIcon: @"boom_ic_guest",
                JMBRNWindowGuestIconTintColor: @"#FFFFC470",
                JMBRNWindowGuestIconBackgroundColor: @"#00000000",
            };
        }
            break;
        case JMBoomSDKResourceStyle_BLACKGOLD: {
            return @{
                JMBRNCorner: @"3",
                JMBRNButtonBackgroundColor: @"#FF393B40",
                JMBRNButtonTitleFont: @"PingFangSC-Regular:15",
                JMBRNButtonConfirmTitleColor: @"#FFFFE4B7",
                JMBRNButtonCancelTitleColor: @"#FFDCBC60",
                
                JMBRNWindowTitleFont: @"PingFangSC-Semibold:22",
                
                JMBRNWindowCheckboxSelected: @"boom_ic_selected",
                JMBRNWindowCheckboxSelectedTintColor: @"#FF393B40",
                JMBRNWindowCheckboxSelectedBackgroundColor: @"#00000000",
                JMBRNWindowCheckboxUnselected: @"boom_ic_unselect",
                JMBRNWindowCheckboxUnselectedTintColor: @"#FFE9E9E9",
                JMBRNWindowCheckboxUnselectedBackgroundColor: @"#00000000",
                
                JMBRNWindowPhoneIcon: @"boom_ic_iphone",
                JMBRNWindowPhoneIconTintColor: @"#FFE9C77F",
                JMBRNWindowPhoneIconBackgroundColor: @"#00000000",
                
                JMBRNWindowGuestIcon: @"boom_ic_guest",
                JMBRNWindowGuestIconTintColor: @"#FFE9C77F",
                JMBRNWindowGuestIconBackgroundColor: @"#00000000",
            };
        }
            break;
        case JMBoomSDKResourceStyle_BLUE: {
            return @{
                JMBRNCorner: @"3",
                JMBRNButtonBackgroundColor: @"#FF1BA8E8",
                JMBRNButtonTitleFont: @"PingFangSC-Regular:15",
                JMBRNButtonConfirmTitleColor: @"#FFFFFFFF",
                JMBRNButtonCancelTitleColor: @"#FF666666",
                
                JMBRNWindowTitleFont: @"PingFangSC-Semibold:22",
                
                JMBRNWindowCheckboxSelected: @"boom_ic_selected",
                JMBRNWindowCheckboxSelectedTintColor: @"#FF1BA8E8",
                JMBRNWindowCheckboxSelectedBackgroundColor: @"#00000000",
                JMBRNWindowCheckboxUnselected: @"boom_ic_unselect",
                JMBRNWindowCheckboxUnselectedTintColor: @"#FFE9E9E9",
                JMBRNWindowCheckboxUnselectedBackgroundColor: @"#00000000",
                
                JMBRNWindowPhoneIcon: @"boom_ic_iphone",
                JMBRNWindowPhoneIconTintColor: @"#FF60BFFF",
                JMBRNWindowPhoneIconBackgroundColor: @"#00000000",
                
                JMBRNWindowGuestIcon: @"boom_ic_guest",
                JMBRNWindowGuestIconTintColor: @"#FF60BFFF",
                JMBRNWindowGuestIconBackgroundColor: @"#00000000",
            };
        }
            break;
        case JMBoomSDKResourceStyle_ORANGE: {
            return @{
                JMBRNCorner: @"3",
                JMBRNButtonBackgroundColor: @"#FFEB7B47",
                JMBRNButtonTitleFont: @"PingFangSC-Regular:15",
                JMBRNButtonConfirmTitleColor: @"#FFFFFFFF",
                JMBRNButtonCancelTitleColor: @"#FF666666",
                
                JMBRNWindowTitleFont: @"PingFangSC-Semibold:22",
                
                JMBRNWindowCheckboxSelected: @"boom_ic_selected",
                JMBRNWindowCheckboxSelectedTintColor: @"#FFEB7B47",
                JMBRNWindowCheckboxSelectedBackgroundColor: @"#00000000",
                JMBRNWindowCheckboxUnselected: @"boom_ic_unselect",
                JMBRNWindowCheckboxUnselectedTintColor: @"#FFE9E9E9",
                JMBRNWindowCheckboxUnselectedBackgroundColor: @"#00000000",
                
                JMBRNWindowPhoneIcon: @"boom_ic_iphone",
                JMBRNWindowPhoneIconTintColor: @"#FF60BFFF",
                JMBRNWindowPhoneIconBackgroundColor: @"#00000000",
                
                JMBRNWindowGuestIcon: @"boom_ic_guest",
                JMBRNWindowGuestIconTintColor: @"#FF60BFFF",
                JMBRNWindowGuestIconBackgroundColor: @"#00000000",
            };
        }
            break;
        case JMBoomSDKResourceStyle_PURPLE: {
            return @{
                JMBRNCorner: @"3",
                JMBRNButtonBackgroundColor: @"#FF6074FF",
                JMBRNButtonTitleFont: @"PingFangSC-Regular:15",
                JMBRNButtonConfirmTitleColor: @"#FFFFFFFF",
                JMBRNButtonCancelTitleColor: @"#FF666666",
                
                JMBRNWindowTitleFont: @"PingFangSC-Semibold:22",
                
                JMBRNWindowCheckboxSelected: @"boom_ic_selected",
                JMBRNWindowCheckboxSelectedTintColor: @"#FF6074FF",
                JMBRNWindowCheckboxSelectedBackgroundColor: @"#00000000",
                JMBRNWindowCheckboxUnselected: @"boom_ic_unselect",
                JMBRNWindowCheckboxUnselectedTintColor: @"#FFE9E9E9",
                JMBRNWindowCheckboxUnselectedBackgroundColor: @"#00000000",
                
                JMBRNWindowPhoneIcon: @"boom_ic_iphone",
                JMBRNWindowPhoneIconTintColor: @"#FFFFC470",
                JMBRNWindowPhoneIconBackgroundColor: @"#00000000",
                
                JMBRNWindowGuestIcon: @"boom_ic_guest",
                JMBRNWindowGuestIconTintColor: @"#FFFFC470",
                JMBRNWindowGuestIconBackgroundColor: @"#00000000",
            };
        }
            break;
    }
}

- (void)registerResourceStyle:(JMBoomSDKResourceStyle)style {
    self.style = style;
    [self registerResourceMap:[self resourceMapWithStyle:self.style]];
}

- (void)registerResourceMap:(NSDictionary<NSString *,NSString *> *)resourceMap {
    if (!self.registered) {
        [super registerResourceMap:[self resourceMapWithStyle:self.style]];
    }
    [super registerResourceMap:resourceMap];

    // JMThemeRegistT UIKit
    JMThemeRegistT(JMTipsModalView,
                   cancelButtonTitleColor: [[JMBoomSDKResource shared] resourceWithName:JMBRNButtonCancelTitleColor]);
    JMThemeRegistT(JMToastLoadingView,
                   loadingAnimationImages: (^NSDictionary *(){
        NSMutableArray *animationImages = [NSMutableArray array];
        for (NSInteger i=0; i<=62; i++) {
            NSString *name = [NSString stringWithFormat:@"loading_%02zd", i];
            [animationImages addObject:[JMBoomSDKResource imageNamed:name]];
        }
        return [animationImages copy];
    }()),
                   loadingAnimationDuration: @(2.6));
    JMThemeRegistT(JMToastSuccessView, successImage: [JMBoomSDKResource imageNamed:@"boom_ic_success"]);
    
    JMThemeRegistT(JMModalTopView,
                   logoImage: [JMBoomSDKResource imageNamed:@"boom_logo"],
                   backButtonImage: [JMBoomSDKResource imageNamed:@"boom_ic_back"],
                   closeButtonImage: [JMBoomSDKResource imageNamed:@"boom_ic_close"]);
    JMThemeRegistT(JMModalView, corner: [[JMBoomSDKResource shared] resourceWithName:JMBRNCorner]);
    JMThemeRegistT(JMCommonButton,
                   corner: [[JMBoomSDKResource shared] resourceWithName:JMBRNCorner],
                   backgroundColor: [[JMBoomSDKResource shared] resourceWithName:JMBRNButtonBackgroundColor],
                   titleFont: [[JMBoomSDKResource shared] resourceWithName:JMBRNButtonTitleFont],
                   titleColor: [[JMBoomSDKResource shared] resourceWithName:JMBRNButtonConfirmTitleColor]);
    JMThemeRegistT(JMCompositeTitleView,
                   titleFont: [[JMBoomSDKResource shared] resourceWithName:JMBRNWindowTitleFont]);
    JMThemeRegistT(JMInputView,
                   corner: [[JMBoomSDKResource shared] resourceWithName:JMBRNCorner]);
    JMThemeRegistT(JMWebTitleView,
                   backButtonImage: [JMBoomSDKResource imageNamed:@"boom_ic_back_web"]);
}

- (id)resourceWithName:(NSString *)name {
    if (!self.registered) {
        [self registerResourceStyle:self.style];
    }
    return [super resourceWithName:name];
}

- (id)resourceValueWithName:(NSString *)name {
    if (!self.registered) {
        [self registerResourceStyle:self.style];
    }
    return [super resourceValueWithName:name];
}

@end
