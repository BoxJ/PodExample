//
//  JMResource.m
//  JMResource
//
//  Created by ZhengXianda on 10/18/2022.
//  Copyright (c) 2022 ZhengXianda. All rights reserved.
//

#import "JMResource.h"

@interface JMResourceName ()
@property (nonatomic, strong) NSString *value;
@end
@implementation JMResourceName

- (instancetype)initWithString:(NSString *)aString {
    self = [self init];
    if (self) {
        self.value = [[NSString stringWithFormat:@"%@:%@", NSStringFromClass(self.class), aString] copy];
    }
    return self;
}

- (NSUInteger)length {
    return [self.value length];
}

- (unichar)characterAtIndex:(NSUInteger)index {
    return [self.value characterAtIndex:index];
}

@end
@implementation JMResourceIntName
@end
@implementation JMResourceFloatName
@end
@implementation JMResourceTextName
@end
@implementation JMResourceColorName
@end
@implementation JMResourceFontName
@end
@implementation JMResourceImageName
@end
@implementation JMResourceWebImageName
@end

@interface JMResource ()

@property (nonatomic, strong) NSBundle *localBundle;
@property (nonatomic, strong) NSBundle *resourceBundle;
@property (nonatomic, strong) NSDictionary <NSString *, NSString *>*resourceValueMap;
@property (nonatomic, strong) NSDictionary <NSString *, NSString *>*resourceMap;

@end

@implementation JMResource

#pragma mark - shared

+ (instancetype)shared {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (NSString *)name {
    return @"JMResource";
}

#pragma mark - bundle

- (NSBundle *)localBundle {
    if (!_localBundle) {
        _localBundle = [NSBundle bundleForClass:[self class]];
    }
    return _localBundle;
}

- (NSBundle *)resourceBundle {
    if (!_resourceBundle) {
        NSString *path = [[self localBundle] pathForResource:self.name?:@""
                                                      ofType:@"bundle"];
        _resourceBundle = [NSBundle bundleWithPath:path];
    }
    return _resourceBundle;
}

#pragma mark - image

+ (UIImage *)imageNamed:(NSString *)name {
    UIImage *image = [UIImage imageNamed:name];
    if (image) return image;
    
    NSBundle *resourceBundle = [[self shared] resourceBundle];
    if (@available(iOS 13.0, *)) {
        return [UIImage imageNamed:name inBundle:resourceBundle withConfiguration:nil];
    } else {
        return [UIImage imageNamed:name inBundle:resourceBundle compatibleWithTraitCollection:nil];
    }
}

#pragma mark - localizable

+ (NSString *)stringNamed:(NSString *)name {
    return
    [[[self shared] resourceBundle] localizedStringForKey:name
                                                    value:@""
                                                    table:@"Localizable"];
}

#pragma mark - resources

- (void)registerResourceMap:(NSDictionary <NSString *, NSString *>*)resourceMap {
    NSMutableDictionary *map = self.resourceMap ? [self.resourceMap mutableCopy] : [NSMutableDictionary dictionary];
    NSMutableDictionary *valueMap = self.resourceValueMap ? [self.resourceValueMap mutableCopy] : [NSMutableDictionary dictionary];
    
    for (NSString *name in resourceMap.allKeys) {
        NSString *value = resourceMap[name];
        
        //int字符串 @"1"
        if ([name hasPrefix:NSStringFromClass([JMResourceIntName class])]) {
            map[name] = @([value intValue]);
        }
        //float字符串 @"1.111"
        else if ([name hasPrefix:NSStringFromClass([JMResourceFloatName class])]) {
            map[name] = @([value floatValue]);
        }
        //字符串 @"内容"
        else if ([name hasPrefix:NSStringFromClass([JMResourceTextName class])]) {
            map[name] = value;
        }
        //ARGB字符串 @"#FFAABBCC"
        else if ([name hasPrefix:NSStringFromClass([JMResourceColorName class])]) {
            map[name] = ^UIColor *(NSString *value) {
                NSString *HEX = [[value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
                
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
            }(value);
        }
        //字体名称 @"Font-Bold"
        else if ([name hasPrefix:NSStringFromClass([JMResourceFontName class])]) {
            NSMutableArray <NSString *>*tuple = [[value componentsSeparatedByString:@":"] mutableCopy];
            CGFloat fontSize = [tuple.lastObject floatValue];
            [tuple removeLastObject];
            NSString *fontName = [tuple componentsJoinedByString:@":"];
            map[name] = [UIFont fontWithName:fontName size:fontSize] ?:
                [UIFont systemFontOfSize:fontSize weight:UIFontWeightRegular];
        }
        //图片名字符串 @"ImageName"
        else if ([name hasPrefix:NSStringFromClass([JMResourceImageName class])]) {
            UIImage *image = [UIImage imageNamed:value];
            if (!image) {
                image = [[self class] imageNamed:value];
            }
            map[name] = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        }
        //图片路径 @"https://www.image.com/ImageName.png"
        else if ([name hasPrefix:NSStringFromClass([JMResourceWebImageName class])]) {
            map[name] = value;
        }
        //非预设类型 @"Unknown"
        else {
            map[name] = value;
        }
        
        valueMap[name] = value;
    }
    self.resourceMap = [map copy];
    self.resourceValueMap = [valueMap copy];
}

- (BOOL)registered {
    return (self.resourceMap.count > 0) && (self.resourceValueMap.count > 0);
}

- (id)resourceWithName:(NSString *)name {
    return self.resourceMap[name?:@""];
}

- (id)resourceValueWithName:(NSString *)name {
    return self.resourceValueMap[name?:@""];
}

@end
