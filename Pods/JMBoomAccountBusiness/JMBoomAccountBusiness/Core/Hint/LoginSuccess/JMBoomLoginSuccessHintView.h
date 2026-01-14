//
//  JMBoomLoginSuccessHintView.h
//  JMBoomSDK
//
//  Created by Thief Toki on 2020/8/20.
//

#import <JMUIKit/JMUIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomLoginSuccessHintView : JMHintView

@property (nonatomic, strong) NSString *nickname;

@property (nonatomic, strong) UIImageView *statusImageView;
@property (nonatomic, strong) UILabel *messageLabel;

- (instancetype)initWithNickname:(NSString *)nickname;

@end

NS_ASSUME_NONNULL_END
