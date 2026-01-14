//
//  JMRktDialog.h
//  JMRktCommon
//
//  Created by Thief Toki on 2020/10/9.
//

#import <Foundation/Foundation.h>

#import <JMUtils/JMUtils.h>

typedef NS_ENUM(NSUInteger, JMRktErrorMessageStyleType) {
    JMRktErrorMessageStyleType_None = 0,
    JMRktErrorMessageStyleType_Short = 1,
    JMRktErrorMessageStyleType_Long = 2,
    JMRktErrorMessageStyleType_Alert = 3,
    JMRktErrorMessageStyleType_AlertTitle = 4,
    JMRktErrorMessageStyleType_AlertTitleChoice = 5,
};

NS_ASSUME_NONNULL_BEGIN

@interface JMRktDialog : NSObject

+ (void)showError:(NSError *)error responder:(JMResponder *)responder;
+ (void)showError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
