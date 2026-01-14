//
//  JMTextField.m
//  JMUIKit
//
//  Created by Thief Toki on 2021/1/7.
//

#import "JMTextField.h"

@implementation JMTextField

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(paste:)) {
        return !self.banPaste;
    }
    return [super canPerformAction:action withSender:sender];
}

@end
