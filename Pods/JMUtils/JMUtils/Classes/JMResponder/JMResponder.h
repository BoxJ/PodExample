//
//  JMResponder.h
//  JMBoomSDK
//
//  Created by Thief Toki on 2020/8/10.
//

#import <Foundation/Foundation.h>

typedef void(^JMResponderBlockSuccess)(NSDictionary *info);
typedef void(^JMResponderBlockFailed)(NSError *error);
typedef void(^JMResponderBlockCancel)(void);

@interface JMResponder : NSObject

@property (nonatomic, strong) JMResponderBlockSuccess success;
@property (nonatomic, strong) JMResponderBlockFailed failed;
@property (nonatomic, strong) JMResponderBlockCancel cancel;

+ (instancetype)responder;

+ (instancetype)success:(JMResponderBlockSuccess)success
                 failed:(JMResponderBlockFailed)failed
                 cancel:(JMResponderBlockCancel)cancel;

+ (instancetype)success:(JMResponderBlockSuccess)success
                 failed:(JMResponderBlockFailed)failed;
+ (instancetype)success:(JMResponderBlockSuccess)success
                 cancel:(JMResponderBlockCancel)cancel;
+ (instancetype)failed:(JMResponderBlockFailed)failed
                cancel:(JMResponderBlockCancel)cancel;

+ (instancetype)success:(JMResponderBlockSuccess)success;
+ (instancetype)failed:(JMResponderBlockFailed)failed;
+ (instancetype)cancel:(JMResponderBlockCancel)cancel;

@end
