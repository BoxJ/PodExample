//
//  JMZoomView.m
//  JMUIKit
//
//  Created by ZhengXianda on 2022/9/24.
//

#import "JMZoomView.h"

#import "UIView+JMLayout.h"

@interface JMZoomView () <UIScrollViewDelegate>

@end

@implementation JMZoomView

- (instancetype)initWithDefaultScale:(CGFloat)defaultScale
                            minScale:(CGFloat)minScale
                            maxScale:(CGFloat)maxScale {
    self = [super init];
    if (self) {
        self.defaultScale = defaultScale;
        self.minScale = minScale;
        self.maxScale = maxScale;
        
        [self setupUI];
        [self setupUIResponse];
        [self bindModel];
    }
    return self;
}

- (void)resetScale {
    self.scrollView.contentInset = UIEdgeInsetsZero;
    [self.scrollView setZoomScale:self.defaultScale animated:YES];
}

- (void)zoomToScale:(CGFloat)scale withPoint:(CGPoint)point {
    CGFloat width = self.widthJM / scale;
    CGFloat height = self.heightJM / scale;
    [self.scrollView zoomToRect:CGRectMake(point.x - width / 2.0, point.y - height / 2.0, width, height) animated:YES];
}

#pragma mark - init

#pragma mark - live cycle

#pragma mark - action

#pragma mark - setup UI

- (void)setupUI {
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    
    [self.scrollView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = self.sizeJM;
        make.centerXJM = self.centerXJM;
        make.centerYJM = self.centerYJM;
    }];
    [self.contentView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = self.scrollView.sizeJM;
        make.centerXJM = self.scrollView.centerXJM;
        make.centerYJM = self.scrollView.centerYJM;
    }];
}

#pragma mark - setup UI response

- (void)setupUIResponse {
    
}

#pragma mark - bind model

- (void)bindModel {
    
}

#pragma mark - protocol

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.contentView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (self.scrollView.widthJM > self.scrollView.contentSize.width) ? ((self.scrollView.widthJM - self.scrollView.contentSize.width) * 0.5) : 0.0;
    CGFloat offsetY = (self.scrollView.heightJM > self.scrollView.contentSize.height) ? ((self.scrollView.heightJM - self.scrollView.contentSize.height) * 0.5) : 0.0;
    self.contentView.center = CGPointMake(self.scrollView.contentSize.width * 0.5 + offsetX, self.scrollView.contentSize.height * 0.5 + offsetY);
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    //把当前的缩放比例设进ZoomScale，以便下次缩放时实在现有的比例的基础上
    [scrollView setZoomScale:scale animated:NO];
}

#pragma mark - setter

#pragma mark - getter

- (CGFloat)scale {
    return self.scrollView.zoomScale;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.zoomScale = self.defaultScale;
        _scrollView.maximumZoomScale = self.maxScale;
        _scrollView.minimumZoomScale = self.minScale;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.alwaysBounceVertical = NO;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.bouncesZoom = YES;
        _scrollView.canCancelContentTouches = YES;
        _scrollView.delaysContentTouches = NO;
        _scrollView.multipleTouchEnabled = YES;
        if (@available(iOS 11, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _scrollView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}

@end
