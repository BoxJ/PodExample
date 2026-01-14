//
//  NSDictionary+JMExtension.h
//  JMBoomSDK
//
//  Created by Thief Toki on 2020/9/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (JMExtension)

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end

NS_ASSUME_NONNULL_END
