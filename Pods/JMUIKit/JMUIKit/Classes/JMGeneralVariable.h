//
//  JMGeneralVariable.h
//  JMUIKit
//
//  Created by Thief Toki on 2020/8/4.
//

#ifndef JMGeneralVariable_h
#define JMGeneralVariable_h

#define kMainWindow ([UIWindow mainWindow])
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define kIsSpecialScreen (MAX(kScreenWidth,kScreenHeight)/MIN(kScreenWidth,kScreenHeight) > 2)
#define kIsLandscape (kScreenWidth > kScreenHeight)
#define kFunctionBarHeight (44)
#define kSafeAreaTopHeight ((^(){ if (@available(iOS 11.0, *)) return kMainWindow.safeAreaInsets.top; else return (CGFloat)0.0; }()))
#define kSafeAreaBottomHeight ((^(){ if (@available(iOS 11.0, *)) return kMainWindow.safeAreaInsets.bottom; else return (CGFloat)0.0; }()))
#define kIsLeftLandscape ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft)
#define kIsRightLandscape ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)

#endif /* JMGeneralVariable_h */
