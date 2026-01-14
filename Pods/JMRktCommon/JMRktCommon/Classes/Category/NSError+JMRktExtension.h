//
//  NSError+JMRktExtension.h
//  JMRktCommon
//
//  Created by Thief Toki on 2021/4/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSError (JMRktExtension)

- (NSString *)message;
- (NSString *)htmlMessage;
- (NSDictionary *)messageStyle;
- (NSString *)traceId;
- (NSDictionary *)responseValue;

@end

NS_ASSUME_NONNULL_END
