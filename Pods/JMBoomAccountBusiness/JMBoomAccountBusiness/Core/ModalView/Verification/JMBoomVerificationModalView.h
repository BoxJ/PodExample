//
//  JMBoomVerificationModalView.h
//  JMBoomSDK
//
//  Created by Thief Toki on 2020/8/7.
//

#import <JMUIKit/JMUIKit.h>

#import "JMBoomVerificationType.h"

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomVerificationModalView : JMModalView <JMSplitInputViewDelegate, JMKeyboardPreviewViewDelegate>

@property (nonatomic, strong) NSString *number;
@property (nonatomic, assign) NSInteger verifyCodeLength;
@property (nonatomic, assign) JMBoomVerificationType type;

@property (nonatomic, strong) JMCompositeTitleView *titleView;
@property (nonatomic, strong) JMSplitInputView *inputView;
@property (nonatomic, strong) JMCountDownButton *countDownButton;
@property (nonatomic, strong) JMCommonButton *confirmButton;

- (instancetype)initWithNumber:(NSString *)number
              verifyCodeLength:(NSInteger)verifyCodeLength
                          type:(JMBoomVerificationType)type;

@end

NS_ASSUME_NONNULL_END
