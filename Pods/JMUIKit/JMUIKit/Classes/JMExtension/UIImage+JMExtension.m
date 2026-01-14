//
//  UIImage+JMExtension.m
//  JMUIKit
//
//  Created by Thief Toki on 2021/3/15.
//

#import "UIImage+JMExtension.h"

#import "JMGeneralVariable.h"

#import "JMLogger.h"

#import "NSDate+JMExtension.h"
#import "NSString+JMExtension.h"

@implementation UIImage (JMExtension)

+ (NSString *)imageType:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"jpeg";
        case 0x89:
            return @"png";
        case 0x47:
            return @"gif";
        case 0x49:
        case 0x4D:
            return @"tiff";
        case 0x52: {
            if ([data length] < 12) {
                return nil;
            }
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                return @"webp";
            }
            return nil;
        }
        case 0x00: {
            if ([data length] < 12) {
                return nil;
            }
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(4, 8)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"ftyp"]) {
                if ([testString hasSuffix:@"mif1"] || [testString hasSuffix:@"msf1"]) {
                    return @"heif";
                }
                if ([testString hasSuffix:@"heic"] || [testString hasSuffix:@"heix"]) {
                    return @"heic";
                }
            }
            return nil;
        }
    }
    return nil;
}

+ (NSString *)imageTypeFile:(NSString *)filePath {
    return [self imageType:[NSData dataWithContentsOfFile:filePath]];
}

+ (NSString *)saveImageData:(NSData *)imageData name:(NSString *)name {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:name];
    [fileManager createFileAtPath:fullPath contents:imageData attributes:nil];
    
    return fullPath;
}

- (NSString *)save {
    UIImage *image = self;
    
    NSString *suffix = @".jpg";
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    if (data == nil) {
        suffix = @".png";
        data = UIImagePNGRepresentation(image);
    }
    
    return
    [UIImage saveImageData:data
                      name:[NSString stringWithFormat:@"%@%@%@",
                            [[NSDate date] stringValue],
                            [NSString random:10],
                            suffix]];
}

- (NSString *)saveCompress {
    UIImage *image = self;
    
    CGFloat sizeScale = (kScreenWidth * kScreenHeight) / (self.size.width * self.size.height);
    if (sizeScale < 1) {
        image = [image panoramicCompress:sizeScale deviation:500];
    }
    
    return [image save];
}

- (UIImage *)panoramicCompress:(NSInteger)ratio deviation:(CGFloat)deviation {
    UIImage *newImage = nil;
    CGFloat width = self.size.width;
    CGFloat height = self.size.height;
    CGFloat targetHeight;
    CGFloat targetWidth;
    if (height > width && height - width > deviation) {
        //水平全景图
        targetHeight = height * ratio;
        targetWidth = width / (height / targetHeight);
    } else if (width > height && width - height > deviation) {
        //竖直全景图
        targetWidth = width * ratio;
        targetHeight = height / (width / targetWidth);
    } else {
        //普通图片
        return self;
    }
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if (CGSizeEqualToSize(self.size, size) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor;
        } else {
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;

    [self drawInRect:thumbnailRect];

    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (newImage == nil) {
        JMLog(@"压缩图片失败！");
        return self;
    }

    return newImage;
}

/// 修正图片转向
- (UIImage *)fixOrientation {
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp)
        return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

/// 缩放图片至新尺寸
- (UIImage *)scaleToSize:(CGSize)size {
    if (self.size.width > size.width) {
        UIGraphicsBeginImageContext(size);
        [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
        UIImage *reduceImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return reduceImage;
    } else {
        return self;
    }
}

@end
