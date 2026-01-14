//
//  JMModalStack.m
//  JMUIKit
//
//  Created by Thief Toki on 2020/8/18.
//

#import "JMModalStack.h"

#import "JMGeneralVariable.h"

#import "JMModalView.h"

#import "UIView+JMLayout.h"
#import "UIWindow+JMExtension.h"

@implementation JMModalStack

#pragma mark - init

+ (instancetype)stackWithRootModaView:(JMModalView *)rootModaView {
    JMModalStack *stack = [[JMModalStack alloc] init];
    stack.rootModaView = rootModaView;
    
    [stack stackPush:rootModaView];
    return stack;
}

#pragma mark - stack action

- (void)stackPush:(JMModalView *)modaView {
    modaView.stack = self;
    [self.modaList addObject:modaView];
}

- (JMModalView *)stackPop {
    JMModalView *modaView = self.modaList.lastObject;
    if (!modaView) return nil;
    
    modaView.stack = nil;
    [self.modaList removeLastObject];
    
    return modaView;
}

- (JMModalView *)deQueue {
    JMModalView *modaView = self.modaList.firstObject;
    if (!modaView) return nil;
    
    modaView.stack = nil;
    [self.modaList removeObject:modaView];
    
    return modaView;
}

#pragma mark - action

- (void)push:(JMModalView *)modaView {
    JMModalView *firstModaView = self.modaList.firstObject;
    if (firstModaView && modaView && !modaView.isShow) {
        [firstModaView mask];
        
        modaView.isShow = YES;
        
        modaView.leftJM = kScreenWidth;
        [self.modaList.firstObject.contentView addSubview:modaView];
        [UIView animateWithDuration:0.5 animations:^{
            modaView.leftJM = 0;
        } completion:^(BOOL finished) {
            [firstModaView unmask];
        }];
    }
    
    [self stackPush:modaView];
}

- (void)push:(JMModalView *)modaView responder:(JMResponder *)responder {
    modaView.responder = responder;
    
    [self push:modaView];
}

- (JMModalView *)pop {
    if (self.modaList.count == 1) return nil;
    
    JMModalView *modaView = [self stackPop];
    if (!modaView) return nil;
    
    JMModalView *firstModaView = self.modaList.firstObject;
    if (firstModaView && modaView && modaView.isShow) {
        [firstModaView mask];
        
        [UIView animateWithDuration:0.5 animations:^{
            modaView.leftJM = kScreenWidth;
        } completion:^(BOOL finished) {
            [modaView removeFromSuperview];
            modaView.isShow = NO;
            [firstModaView unmask];
        }];
    }
    
    return modaView;
}

- (void)dismiss:(void(^)(void))completion {
    [[self deQueue] dismiss:completion];
    [self clear];
}

- (void)dismiss {
    [[self deQueue] dismiss];
    [self clear];
}

- (void)dismissSuccess:(NSDictionary *)info {
    [[self deQueue] dismissSuccess:info];
    [self clear];
}

- (void)dismissFailed:(NSError *)error {
    [[self deQueue] dismissFailed:error];
    [self clear];
}

- (void)dismissCancel {
    [[self deQueue] dismissCancel];
    [self clear];
}

- (void)clear {
    while (self.modaList.count > 0) {
        [[self stackPop] dismiss];
    }
}

#pragma mark - getter

- (NSMutableArray<JMModalView *> *)modaList {
    if (!_modaList) {
        _modaList = [NSMutableArray array];
    }
    return _modaList;
}

@end
