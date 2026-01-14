//
//  UIView+JMLayout.m
//  JMUIKit
//
//  Created by Thief Toki on 2020/8/3.
//

#import "UIView+JMLayout.h"

@implementation UIView (JMLayout)

- (void)jm_layout:(void (^)(UIView * _Nonnull))layoutBlock {
    layoutBlock(self);
    [self setupUI];
}

- (void)setupUI {
    
}

- (CGFloat)leftJM{
    return self.frame.origin.x;
}
- (CGFloat)rightJM{
    return self.frame.origin.x + self.frame.size.width;
}
- (CGFloat)topJM{
    return self.frame.origin.y;
}
- (CGFloat)bottomJM{
    return self.frame.origin.y + self.frame.size.height;
}
- (CGFloat)centerXJM{
    return self.frame.origin.x + self.frame.size.width/2;
}
- (CGFloat)centerYJM{
    return self.frame.origin.y + self.frame.size.height/2;
}
- (CGFloat)widthJM{
    return self.frame.size.width;
}
- (CGFloat)heightJM{
    return self.frame.size.height;
}
- (CGSize)sizeJM{
    return self.frame.size;
}

- (void)setLeftJM:(CGFloat)left{
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}
- (void)setRightJM:(CGFloat)right{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}
- (void)setTopJM:(CGFloat)top{
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}
- (void)setBottomJM:(CGFloat)bottom{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}
- (void)setCenterXJM:(CGFloat)centerX{
    CGRect frame = self.frame;
    frame.origin.x = centerX - frame.size.width/2;
    self.frame = frame;
}
- (void)setCenterYJM:(CGFloat)centerY{
    CGRect frame = self.frame;
    frame.origin.y = centerY - frame.size.height/2;
    self.frame = frame;
}
- (void)setWidthJM:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
- (void)setHeightJM:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)setSizeJM:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

@end
