//
//  NSDictionary+JMRktRequestSign.h
//  JMRktRequest
//
//  Created by Thief Toki on 2021/1/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (JMRktRequestSign)

- (NSString *)secretWithKey:(NSString *)secretKey andOrder:(NSArray <NSString *>*)order;

@end

NS_ASSUME_NONNULL_END
