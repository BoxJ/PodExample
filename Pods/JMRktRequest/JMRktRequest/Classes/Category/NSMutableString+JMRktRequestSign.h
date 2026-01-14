//
//  NSMutableString+JMRktRequestSign.h
//  JMRktRequest
//
//  Created by Thief Toki on 2021/1/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableString (JMRktRequestSign)

- (void)insertSecretPair:(NSString *)key value:(NSString *)value;

@end

NS_ASSUME_NONNULL_END
