//
//  JMHintView.h
//  JMUIKit
//
//  Created by Thief Toki on 2020/8/8.
//

#import <UIKit/UIKit.h>

#import <JMUtils/JMUtils.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMHintView : UIView

@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, strong) JMResponder *responder;

@property (nonatomic, strong) UIView *contentView;

- (void)setupUI;
- (void)setupUIResponse;

- (void)show;
- (void)show:(JMResponder *)responder;
- (void)dismiss;
- (void)dismissSuccess:(NSDictionary *)info;
- (void)dismissFailed:(NSError *)error;
- (void)dismissCancel;

@end

NS_ASSUME_NONNULL_END
