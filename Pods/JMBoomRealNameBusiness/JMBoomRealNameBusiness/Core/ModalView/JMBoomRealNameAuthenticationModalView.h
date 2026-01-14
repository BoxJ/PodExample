//
//  JMBoomRealNameAuthenticationModalView.h
//  JMBoomSDK
//
//  Created by Thief Toki on 2020/8/3.
//

#import <JMUIKit/JMUIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomRealNameAuthenticationModalView : JMModalView <JMKeyboardPreviewViewDelegate>

@property (nonatomic, assign) BOOL isLock;

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) JMCompositeTitleView *titleView;
@property (nonatomic, strong) UILabel *introLabel;
@property (nonatomic, strong) JMInputView *nameInputView;
@property (nonatomic, strong) JMInputView *idNumberInputView;
@property (nonatomic, strong) JMCommonButton *confirmButton;

- (instancetype)initWithLock:(BOOL)isLock;

@end

NS_ASSUME_NONNULL_END
