//
//  JMBoomSubmitDetailServiceCell.m
//  JMBoomSubmitBusiness
//
//  Created by Thief Toki on 2021/3/11.
//

#import "JMBoomSubmitDetailServiceCell.h"

#import <JMUIKit/JMUIKit.h>
#import <JMBoomSDKBase/JMBoomSDKBase.h>

@implementation JMBoomSubmitDetailServiceCellModel

- (instancetype)initWithDescribe:(NSString *)describe
                            name:(NSString *)name
                           reply:(NSString *)reply
                       replyTime:(NSInteger)replyTime {
    self = [super init];
    if (self) {
        self.cls = [JMBoomSubmitDetailServiceCell class];
        
        self.describe = describe;
        self.name = name;
        self.reply = reply;
        self.replyTime = replyTime;
    }
    return self;
}

@end

@interface JMBoomSubmitDetailServiceCell ()

@property (nonatomic, strong) JMBoomSubmitDetailServiceCellModel *model;

@property (nonatomic, strong) UIView *boardView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation JMBoomSubmitDetailServiceCell

#pragma mark - setup UI

- (void)setupUI {
    [self.contentView addSubview:self.boardView];
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.contentLabel];
    
    [self.contentLabel jm_layout:^(UIView * _Nonnull make) {
        make.widthJM = kScreenWidth - 88;
        [make sizeToFit];
    }];
    
    self.sizeJM = CGSizeMake(kScreenWidth, self.contentLabel.heightJM + 95);
    self.contentView.frame = CGRectMake(0, 0,
                                        self.widthJM - ((kIsSpecialScreen && kIsLandscape) ? 44*2 : 0),
                                        self.heightJM);
    
    [self.boardView jm_layout:^(UIView * _Nonnull make) {
        CGFloat margin = 15;
        make.sizeJM = CGSizeMake(self.contentView.widthJM - margin*2, self.contentLabel.heightJM + 82);
        make.topJM = 0;
        make.centerXJM = self.contentView.centerXJM;
        
        CGRect shadowRect = CGRectMake(0, make.heightJM, make.widthJM, 9);
        make.layer.shadowPath = [UIBezierPath bezierPathWithRect:shadowRect].CGPath;
    }];
    [self.avatarImageView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(42, 50);
        make.topJM = self.boardView.topJM + 5;
        make.leftJM = self.boardView.leftJM + 6;
    }];
    [self.titleLabel jm_layout:^(UIView * _Nonnull make) {
        [make sizeToFit];
        make.centerYJM = self.avatarImageView.centerYJM;
        make.leftJM = self.avatarImageView.rightJM;
    }];
    [self.timeLabel jm_layout:^(UIView * _Nonnull make) {
        [make sizeToFit];
        make.centerYJM = self.titleLabel.centerYJM;
        make.rightJM = self.boardView.rightJM - 15;
    }];
    [self.iconImageView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(20, 20);
        make.topJM = self.avatarImageView.bottomJM + 10;
        make.leftJM = self.boardView.leftJM + 15;
    }];
    [self.contentLabel jm_layout:^(UIView * _Nonnull make) {
        make.topJM = self.iconImageView.topJM + 2;
        make.leftJM = self.iconImageView.rightJM + 10;
    }];
}

#pragma mark - setup UI response

- (void)setupUIResponse {
    
}

#pragma mark - bind model

- (void)bindModel {
    self.titleLabel.text = self.model.name;
    self.timeLabel.text = [[NSDate dateWithTimeIntervalSince1970:self.model.replyTime]
                           stringValueWithFormat:@"yyyy/MM/dd HH:mm"];
    self.contentLabel.text = self.model.reply;
    
    [self setupUI];
}

#pragma mark - protocol

#pragma mark - setter

#pragma mark - getter

- (UIView *)boardView {
    if (!_boardView) {
        _boardView = [[UIView alloc] init];
        _boardView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        _boardView.layer.cornerRadius = [[[JMBoomSDKResource shared] resourceWithName:JMBRNCorner] floatValue];
        _boardView.layer.masksToBounds = YES;
        _boardView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.04].CGColor;
        _boardView.layer.shadowOpacity = 1;
        _boardView.layer.shadowRadius = [[[JMBoomSDKResource shared] resourceWithName:JMBRNCorner] floatValue];
    }
    return _boardView;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.image = [JMBoomSDKResource imageNamed:@"sug_ic_kefu"];
    }
    return _avatarImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithRed:102/255.0
                                                green:102/255.0
                                                 blue:102/255.0
                                                alpha:1.0];
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor colorWithRed:153/255.0
                                               green:153/255.0
                                                blue:153/255.0
                                               alpha:1.0];
        _timeLabel.font = [UIFont systemFontOfSize:12];
    }
    return _timeLabel;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [JMBoomSDKResource imageNamed:@"sug_ic_answer"];
    }
    return _iconImageView;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor colorWithRed:51/255.0
                                               green:51/255.0
                                                blue:51/255.0
                                               alpha:1.0];
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

@end
