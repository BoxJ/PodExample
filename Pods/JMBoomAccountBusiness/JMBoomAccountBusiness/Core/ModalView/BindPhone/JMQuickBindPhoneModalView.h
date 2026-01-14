//
//  JMQuickBindPhoneModalView.h
//  JMBoomSDK
//
//  Created by Thief Toki on 2020/8/4.
//

#import <JMUIKit/JMUIKit.h>

#import "JMBoomBindPhoneType.h"
#import "JMBoomAgreementView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JMQuickBindPhoneModalView : JMModalView

@property (nonatomic, strong) NSArray<NSString *> *loginStyle;
@property (nonatomic, strong, nullable) NSString *number;
@property (nonatomic, strong, nullable) NSString *operatorName;
@property (nonatomic, strong, nullable) NSString *protocolName;
@property (nonatomic, strong, nullable) NSString *protocolUrl;
@property (nonatomic, assign) BOOL isLock;
@property (nonatomic, assign) JMBoomBindPhoneType type;
@property (nonatomic, assign) NSInteger verifyCodeLength;

@property (nonatomic, strong) JMCompositeTitleView *titleView;
@property (nonatomic, strong) UILabel *phoneNumberLabel;
@property (nonatomic, strong) JMCommonButton *boundButton;
@property (nonatomic, strong) JMCrispButton *phoneSchemeButton;
@property (nonatomic, strong) UIImageView *phoneImageView;
@property (nonatomic, strong) JMBoomAgreementView *agreementView;


- (instancetype)initWithNumber:(NSString *)number
                  operatorName:(NSString *)operatorName
                  protocolName:(NSString *)protocolName
                   protocolUrl:(NSString *)protocolUrl
              verifyCodeLength:(NSInteger)verifyCodeLength
                          lock:(BOOL)isLock
                          type:(JMBoomBindPhoneType)type;

@end

NS_ASSUME_NONNULL_END
