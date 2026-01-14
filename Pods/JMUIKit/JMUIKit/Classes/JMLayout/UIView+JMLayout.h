//
//  UIView+JMLayout.h
//  JMUIKit
//
//  Created by Thief Toki on 2020/8/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (JMLayout)

- (void)jm_layout:(void(^)(UIView *make))layoutBlock;

- (void)setupUI;

- (CGFloat)leftJM;
- (CGFloat)rightJM;
- (CGFloat)topJM;
- (CGFloat)bottomJM;
- (CGFloat)centerXJM;
- (CGFloat)centerYJM;
- (CGFloat)widthJM;
- (CGFloat)heightJM;
- (CGSize)sizeJM;

- (void)setLeftJM:(CGFloat)left;
- (void)setRightJM:(CGFloat)right;
- (void)setTopJM:(CGFloat)top;
- (void)setBottomJM:(CGFloat)bottom;
- (void)setCenterXJM:(CGFloat)centerX;
- (void)setCenterYJM:(CGFloat)centerY;
- (void)setWidthJM:(CGFloat)width;
- (void)setHeightJM:(CGFloat)height;
- (void)setSizeJM:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
