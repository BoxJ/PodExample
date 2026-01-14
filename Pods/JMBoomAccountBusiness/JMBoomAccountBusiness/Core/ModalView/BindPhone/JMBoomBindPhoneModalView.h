//
//  JMBoomBindPhoneModalView.h
//  JMBoomSDK
//
//  Created by Thief Toki on 2020/8/11.
//

#import <JMUIKit/JMUIKit.h>

#import "JMBoomBindPhoneType.h"

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomBindPhoneModalView : JMModalView <UITextFieldDelegate, JMKeyboardPreviewViewDelegate>

@property (nonatomic, assign) BOOL isLock;
@property (nonatomic, assign) JMBoomBindPhoneType type;
@property (nonatomic, assign) NSInteger verifyCodeLength;

@property (nonatomic, strong) JMCompositeTitleView *titleView;
@property (nonatomic, strong) JMInputView *inputView;
@property (nonatomic, strong) JMCommonButton *confirmButton;

- (instancetype)initWithLock:(BOOL)isLock
                        type:(JMBoomBindPhoneType)type
            verifyCodeLength:(NSInteger)verifyCodeLength;

@end

NS_ASSUME_NONNULL_END
