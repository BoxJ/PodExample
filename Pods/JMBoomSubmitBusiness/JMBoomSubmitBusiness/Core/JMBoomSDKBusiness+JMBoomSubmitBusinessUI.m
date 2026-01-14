//
//  JMBoomSDKBusiness+JMBoomSubmitBusinessUI.m
//  JMBoomSubmitBusiness
//
//  Created by ZhengXianda on 11/02/2022.
//  Copyright (c) 2022 ZhengXianda. All rights reserved.
//

#import "JMBoomSDKBusiness+JMBoomSubmitBusinessUI.h"

#import <JMUIKit/JMUIKit.h>

#import "JMBoomSubmitViewController.h"

@implementation JMBoomSDKBusiness (JMBoomSubmitBusinessUI)

- (void)showSubmitWithHistoryStatus:(BOOL)hasHistory callback:(JMBusinessCallback)callback {
    JMBoomSubmitViewController *vc = [[JMBoomSubmitViewController alloc] initWithHistoryStatus:hasHistory
                                                                                      callback:callback];
    
    JMPortraitNavigationController *nav = [[JMPortraitNavigationController alloc] initWithRootViewController:vc];
    nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
    
    UIViewController *currentViewController = [UIViewController rootViewController].currentViewController;
    if ([currentViewController isKindOfClass:[JMBoomSubmitViewController class]]) {
        JMLog(@"当前流程正在展示中，请勿重复调用");
    } else {
        [currentViewController presentViewController:nav animated:YES completion:nil];
    }
}

@end
