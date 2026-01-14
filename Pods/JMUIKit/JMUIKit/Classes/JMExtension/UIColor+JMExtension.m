//
//  UIColor+JMExtension.m
//  JMUIKit
//
//  Created by ZhengXianda on 2021/12/1.
//

#import "UIColor+JMExtension.h"

@implementation UIColor (JMExtension)

+ (UIColor *)colorWithHexString:(NSString *)HexString {
    //转为大写
    NSString *HEX = [[HexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    //去除前缀
    if ([HEX hasPrefix:@"0X"]) {
        HEX = [HEX substringFromIndex:2];
    } else if ([HEX hasPrefix:@"#"]) {
        HEX = [HEX substringFromIndex:1];
    }
    
    NSString *A, *R, *G, *B;
    if ([HEX length] == 6) {
        A = @"FF";
    } else if ([HEX length] == 8) {
        A = [HEX substringWithRange:NSMakeRange(0, 2)];
        HEX = [HEX substringFromIndex:2];
    } else {
        return [UIColor clearColor];
    }
    R = [HEX substringWithRange:NSMakeRange(0, 2)];
    G = [HEX substringWithRange:NSMakeRange(2, 2)];
    B = [HEX substringWithRange:NSMakeRange(4, 2)];
    
    unsigned int a, r, g, b;
    [[NSScanner scannerWithString:A] scanHexInt:&a];
    [[NSScanner scannerWithString:R] scanHexInt:&r];
    [[NSScanner scannerWithString:G] scanHexInt:&g];
    [[NSScanner scannerWithString:B] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:((float) a / 255.0f)];
}

@end
