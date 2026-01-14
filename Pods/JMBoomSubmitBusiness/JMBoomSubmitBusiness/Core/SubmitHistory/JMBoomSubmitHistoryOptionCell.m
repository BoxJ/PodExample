//
//  JMBoomSubmitHistoryOptionCell.m
//  JMBoomSubmitBusiness
//
//  Created by Thief Toki on 2021/3/11.
//

#import "JMBoomSubmitHistoryOptionCell.h"

#import <JMUIKit/JMUIKit.h>
#import <JMBoomSDKBase/JMBoomSDKBase.h>

@implementation JMBoomSubmitHistoryOptionCellModel

- (instancetype)initWithId:(NSInteger)submitId
                 createdOn:(NSInteger)createdOn
                issueTitle:(NSString *)issueTitle
                      type:(JMBoomSubmitType)type
               issueStatus:(BOOL)issueStatus {
    self = [super init];
    if (self) {
        self.cls = [JMBoomSubmitHistoryOptionCell class];
        
        self.submitId = submitId;
        self.createdOn = createdOn;
        self.issueTitle = issueTitle;
        self.item = [[JMBoomSubmitTypeItem alloc] initWithType:type];
        self.issueStatus = issueStatus;
    }
    return self;
}

@end

@interface JMBoomSubmitHistoryOptionCell ()

@property (nonatomic, strong) JMBoomSubmitHistoryOptionCellModel *model;

@property (nonatomic, strong) UIView *boardView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *typeBackView;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *stampImageView;

@end

@implementation JMBoomSubmitHistoryOptionCell

#pragma mark - setup UI

- (void)setupUI {
    self.titleLabel.text = self.model.issueTitle;
    self.typeBackView.backgroundColor = self.model.item.backgroundColor;
    self.typeLabel.text = self.model.item.title;
    self.typeLabel.textColor = self.model.item.titleColor;
    self.timeLabel.text = [[NSDate dateWithTimeIntervalSince1970:self.model.createdOn]
                           stringValueWithFormat:@"yyyy/MM/dd HH:mm"];
    self.stampImageView.hidden = !self.model.issueStatus;
    
    [self.contentView addSubview:self.boardView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.typeBackView];
    [self.contentView addSubview:self.typeLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.stampImageView];
    
    self.sizeJM = CGSizeMake(kScreenWidth, 98);
    self.contentView.frame = CGRectMake(0, 0,
                                        self.widthJM - ((kIsSpecialScreen && kIsLandscape) ? 44*2 : 0),
                                        self.heightJM);
    
    [self.boardView jm_layout:^(UIView * _Nonnull make) {
        CGFloat margin = 15;
        make.sizeJM = CGSizeMake(self.contentView.widthJM - margin*2, 86);
        make.topJM = 0;
        make.centerXJM = self.contentView.centerXJM;
        
        CGRect shadowRect = CGRectMake(0, make.heightJM, make.widthJM, 9);
        make.layer.shadowPath = [UIBezierPath bezierPathWithRect:shadowRect].CGPath;
    }];
    [self.titleLabel jm_layout:^(UIView * _Nonnull make) {
        CGFloat margin = 30;
        make.sizeJM = CGSizeMake(self.contentView.widthJM - margin*2, 24);
        make.topJM = self.boardView.topJM + 12;
        make.leftJM = self.boardView.leftJM + 15;
    }];
    [self.typeBackView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(67, 24);
        make.bottomJM = self.boardView.bottomJM - 16;
        make.leftJM = self.boardView.leftJM + 15;
    }];
    [self.typeLabel jm_layout:^(UIView * _Nonnull make) {
        [make sizeToFit];
        make.center = self.typeBackView.center;
    }];
    [self.timeLabel jm_layout:^(UIView * _Nonnull make) {
        [make sizeToFit];
        make.centerYJM = self.typeLabel.centerYJM;
        make.rightJM = self.boardView.rightJM - 15;
    }];
    [self.stampImageView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(45, 42);
        make.topJM = self.boardView.topJM;
        make.rightJM = self.boardView.rightJM;
    }];
}

#pragma mark - setup UI response

- (void)setupUIResponse {
    
}

#pragma mark - bind model

- (void)bindModel {
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

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithRed:51/255.0
                                                green:51/255.0
                                                 blue:51/255.0
                                                alpha:1.0];
        _titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _titleLabel;
}

- (UIView *)typeBackView {
    if (!_typeBackView) {
        _typeBackView = [[UIView alloc] init];
        _typeBackView.layer.cornerRadius = [[[JMBoomSDKResource shared] resourceWithName:JMBRNCorner] floatValue];
        _typeBackView.layer.masksToBounds = YES;
    }
    return _typeBackView;
}

- (UILabel *)typeLabel {
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.font = [UIFont systemFontOfSize:12];
    }
    return _typeLabel;
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


- (UIImageView *)stampImageView {
    if (!_stampImageView) {
        _stampImageView = [[UIImageView alloc] init];
        _stampImageView.image = [JMBoomSDKResource imageNamed:@"sug_ic_reply"];
    }
    return _stampImageView;
}

@end
