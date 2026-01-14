//
//  UIWindow+JMExtension.m
//  JMUIKit
//
//  Created by Thief Toki on 2021/3/16.
//

#import "UIWindow+JMExtension.h"

@implementation UIWindow (JMExtension)

+ (UIWindow *)mainWindow {
    NSPredicate *predicate =
    [NSPredicate predicateWithBlock:^BOOL(UIWindow *evaluatedObject,
                                          NSDictionary<NSString *,id> * _Nullable bindings) {
        return evaluatedObject.isKeyWindow;
    }];
    return [[UIApplication sharedApplication].windows filteredArrayUsingPredicate:predicate].firstObject;
}

@end
