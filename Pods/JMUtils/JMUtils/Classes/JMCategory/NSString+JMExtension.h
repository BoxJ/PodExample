//
//  NSString+JMExtension.h
//  JMBoomSDK
//
//  Created by Thief Toki on 2020/9/14.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (JMExtension)

- (NSString *)domain;

- (NSRange)HTMLTag;
- (BOOL)hasHTMLTag;
- (NSString *)stringWithoutHTMLTags;

- (BOOL)isPhoneNumber;

+ (NSString *)random:(NSInteger )length;

+ (NSString *)bytesSize:(NSUInteger )size;

- (BOOL)isHTTPLink;

@end

NS_ASSUME_NONNULL_END
