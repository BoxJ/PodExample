//
//  JMBoomAutoLoginHintView.h
//  JMBoomSDK
//
//  Created by Thief Toki on 2020/8/8.
//

#import <JMUIKit/JMUIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JMCommonButton;
@interface JMBoomAutoLoginHintView : JMHintView

@property (nonatomic, strong, nullable) NSString *number;
@property (nonatomic, strong, nullable) NSString *protocolName;
@property (nonatomic, strong, nullable) NSString *protocolUrl;
@property (nonatomic, assign) NSInteger verifyCodeLength;
@property (nonatomic, assign) NSTimeInterval delayTime;
@property (nonatomic, strong) NSString *nickname;

@property (nonatomic, strong) UIImageView *statusImageView;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) JMCommonButton *breakButton;

- (instancetype)initWithNumber:(NSString *)number
                  protocolName:(NSString *)protocolName
                   protocolUrl:(NSString *)protocolUrl
              verifyCodeLength:(NSInteger)verifyCodeLength
                     delayTime:(NSTimeInterval)delayTime
                      nickname:(NSString *)nickname;

@end

NS_ASSUME_NONNULL_END
