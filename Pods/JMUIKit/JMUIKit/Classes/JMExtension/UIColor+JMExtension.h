//
//  UIColor+JMExtension.h
//  JMUIKit
//
//  Created by ZhengXianda on 2021/12/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (JMExtension)

/// 十六进制字符串转颜色
/// @param HexString ARGB
+ (UIColor *)colorWithHexString:(NSString *)HexString;

@end

NS_ASSUME_NONNULL_END
