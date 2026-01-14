//
//  JMZoomView.h
//  JMUIKit
//
//  Created by ZhengXianda on 2022/9/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMZoomView : UIView

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, assign, readonly) CGFloat scale;
@property (nonatomic, assign) CGFloat defaultScale;
@property (nonatomic, assign) CGFloat minScale;
@property (nonatomic, assign) CGFloat maxScale;

@property (nonatomic, strong) UIScrollView *scrollView;

- (instancetype)initWithDefaultScale:(CGFloat)defaultScale
                            minScale:(CGFloat)minScale
                            maxScale:(CGFloat)maxScale;

- (void)resetScale;
- (void)zoomToScale:(CGFloat)scale withPoint:(CGPoint)point;

@end

NS_ASSUME_NONNULL_END
