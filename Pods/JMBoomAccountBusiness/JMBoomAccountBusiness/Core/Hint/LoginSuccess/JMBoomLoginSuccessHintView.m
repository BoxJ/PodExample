//
//  JMBoomLoginSuccessHintView.m
//  JMBoomSDK
//
//  Created by Thief Toki on 2020/8/20.
//

#import "JMBoomLoginSuccessHintView.h"

#import <JMBoomSDKBase/JMBoomSDKBase.h>

@implementation JMBoomLoginSuccessHintView

- (instancetype)initWithNickname:(NSString *)nickname {
    self = [self init];
    if (self) {
        self.nickname = nickname;
        
        [self setupUI];
        [self setupUIResponse];
    }
    return self;
}

#pragma mark - setup UI

- (void)setupUI {
    [super setupUI];
    
    [self.contentView addSubview:self.statusImageView];
    [self.contentView addSubview:self.messageLabel];

    [self.statusImageView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(18, 18);
        make.topJM = 19;
        make.leftJM = 15;
    }];
    [self.messageLabel jm_layout:^(UIView * _Nonnull make) {
        [make sizeToFit];
        make.leftJM = self.statusImageView.rightJM + 8;
        make.centerYJM = self.statusImageView.centerYJM;
    }];
}

#pragma mark - setup UI response

- (void)setupUIResponse {
    [super setupUIResponse];
}

#pragma mark - action

- (void)show {
    [super show];
    
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:1];
}

#pragma mark - protocol

#pragma mark - setter

#pragma mark - getter

- (UIImageView *)statusImageView {
    if (!_statusImageView) {
        _statusImageView = [[UIImageView alloc] init];
        _statusImageView.image = [[JMBoomSDKResource shared] resourceWithName:JMBRNWindowCheckboxSelected];
        _statusImageView.tintColor = [[JMBoomSDKResource shared] resourceWithName:JMBRNWindowCheckboxSelectedTintColor];
        _statusImageView.backgroundColor = [[JMBoomSDKResource shared] resourceWithName:JMBRNWindowCheckboxSelectedBackgroundColor];
        _statusImageView.layer.cornerRadius = 9;
        _statusImageView.layer.masksToBounds = YES;
    }
    return _statusImageView;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.text = [NSString stringWithFormat:@"%@, 欢迎回来!", self.nickname];
        _messageLabel.textColor = [UIColor colorWithWhite:51/255.0 alpha:1];
        _messageLabel.font = [UIFont systemFontOfSize:16];
    }
    return _messageLabel;
}


@end
