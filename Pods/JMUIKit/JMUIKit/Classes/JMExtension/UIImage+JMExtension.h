//
//  UIImage+JMExtension.h
//  JMUIKit
//
//  Created by Thief Toki on 2021/3/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (JMExtension)

+ (NSString *)imageType:(NSData *)data;
+ (NSString *)imageTypeFile:(NSString *)filePath;

+ (NSString *)saveImageData:(NSData *)imageData name:(NSString *)name;

- (NSString *)save;
- (NSString *)saveCompress;
- (UIImage *)panoramicCompress:(NSInteger)ratio deviation:(CGFloat)deviation;

/// 修正图片转向
- (UIImage *)fixOrientation;

/// 缩放图片至新尺寸
- (UIImage *)scaleToSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
