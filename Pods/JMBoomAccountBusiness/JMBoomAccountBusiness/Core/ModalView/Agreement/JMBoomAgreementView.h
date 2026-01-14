//
//  JMBoomAgreementView.h
//  JMBoomSDK
//
//  Created by Thief Toki on 2020/8/5.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JMAgreementScene) {
    JMAgreementScene_Login = 0,
    JMAgreementScene_BindPhone = 1,
};

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomAgreementView : UIView <UITextViewDelegate>

@property (nonatomic, strong, nullable) NSString *protocolName;
@property (nonatomic, strong, nullable) NSString *protocolUrl;

@property (nonatomic, assign) JMAgreementScene scene;

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, strong) UIImageView *selectedImageView;
@property (nonatomic, strong) UIButton *checkButton;
@property (nonatomic, strong) UITextView *agreementTextView;

- (void)updateProtocolName:(nullable NSString *)protocolName
               protocolUrl:(nullable NSString *)protocolUrl;

- (void)updateScene:(JMAgreementScene)scene;

@end

NS_ASSUME_NONNULL_END
