//
//  JMResource.h
//  JMResource
//
//  Created by ZhengXianda on 10/18/2022.
//  Copyright (c) 2022 ZhengXianda. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMResourceName : NSString
@end
@interface JMResourceIntName : JMResourceName //int字符串 @"1"
@end
@interface JMResourceFloatName : JMResourceName //float字符串 @"1.111"
@end
@interface JMResourceTextName : JMResourceName //字符串 @"内容"
@end
@interface JMResourceColorName : JMResourceName //ARGB字符串 @"#FFAABBCC"
@end
@interface JMResourceFontName : JMResourceName //字体名称 @"Font-Bold"
@end
@interface JMResourceImageName : JMResourceName //图片名字符串 @"ImageName"
@end
@interface JMResourceWebImageName : JMResourceName //图片路径 @"https://www.image.com/ImageName.png"
@end

@interface JMResource : NSObject

#pragma mark - shared

+ (instancetype)shared;

#pragma mark - bundle

- (NSString *)name; ///< 重载本函数，实现指定Bundle
- (NSBundle *)resourceBundle;
- (NSBundle *)localBundle;

#pragma mark - image

+ (UIImage *)imageNamed:(NSString *)name;

#pragma mark - localizable

+ (NSString *)stringNamed:(NSString *)name;

#pragma mark - resources

- (void)registerResourceMap:(NSDictionary <NSString *, NSString *>*)resourceMap;
- (BOOL)registered;
- (id)resourceWithName:(NSString *)name;
- (id)resourceValueWithName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
