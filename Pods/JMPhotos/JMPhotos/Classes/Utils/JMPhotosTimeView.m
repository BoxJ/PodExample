//
//  JMPhotosTimeView.m
//  JMAssetPicker
//
//  Created by ZhengXianda on 2022/6/27.
//

#import "JMPhotosTimeView.h"

#import <JMUIKit/JMUIKit.h>

@implementation JMPhotosTimeView

#pragma mark - init

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupUI];
        [self setupUIResponse];
        [self bindModel];
    }
    return self;
}

#pragma mark - live cycle

#pragma mark - action

#pragma mark - setup UI

- (void)setupUI {
    [self addSubview:self.maskView];
    [self.maskView addSubview:self.iconImageView];
    [self.maskView addSubview:self.timeLabel];
    
    [self.maskView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = self.sizeJM;
        make.topJM = 0;
        make.leftJM = 0;
    }];
    [self.iconImageView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(self.maskView.heightJM, self.maskView.heightJM);
        make.topJM = 0;
        make.leftJM = self.maskView.heightJM * 0.5;
    }];
    [self.timeLabel jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(self.maskView.widthJM - self.maskView.heightJM * (0.5*2+1), self.maskView.heightJM);
        make.topJM = 0;
        make.leftJM = self.iconImageView.rightJM;
    }];
}

#pragma mark - setup UI response

- (void)setupUIResponse {
    
}

#pragma mark - bind model

- (void)bindModel {
    self.maskView.hidden = self.time <= 0;
    self.timeLabel.text = self.timeString;
    
    [self setupUI];
}

#pragma mark - protocol

#pragma mark - setter

- (void)setTime:(NSTimeInterval)time {
    _time = time;
    
    [self bindModel];
}

#pragma mark - getter

- (NSString *)timeString {
    NSTimeInterval timestamp = self.time;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    
    if (timestamp / 60 / 60 > 1) {
        formatter.dateFormat = @"HH:mm:ss";
    } else if (timestamp / 60 > 1) {
        formatter.dateFormat = @"0:mm:ss";
    } else {
        formatter.dateFormat = @"0:ss";
    }
    
    NSString *timeString = [formatter stringFromDate:date];
    return timeString;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] init];
        _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    }
    return _maskView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImageView.clipsToBounds = YES;
    }
    return _iconImageView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont boldSystemFontOfSize:11];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
}

@end
