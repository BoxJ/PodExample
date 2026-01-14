//
//  JMToast.h
//  JMUIKit
//
//  Created by ZhengXianda on 10/19/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMToast : NSObject

+ (void)showToast:(NSString *)message;
+ (void)showToast:(NSString *)message duartion:(NSTimeInterval)time;
+ (void)showToastSuccess:(NSString *)message;
+ (void)showToastSuccess:(NSString *)message duartion:(NSTimeInterval)time;
+ (void)showToastLoading;
+ (void)showToastLoadingDuartion:(NSTimeInterval)time;
+ (void)dismissToast;
+ (void)dismissToastDelay:(NSTimeInterval)time;

@end

NS_ASSUME_NONNULL_END
