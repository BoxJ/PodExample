//
//  JMBoomSubmitTypeOptionCell.m
//  JMBoomSubmitBusiness
//
//  Created by Thief Toki on 2021/3/11.
//

#import "JMBoomSubmitTypeOptionCell.h"

#import <JMUIKit/JMUIKit.h>

@implementation JMBoomSubmitTypeOptionCellModel

- (instancetype)initWithType:(JMBoomSubmitType)type {
    self = [super init];
    if (self) {
        self.cls = [JMBoomSubmitTypeOptionCell class];
        
        self.item = [[JMBoomSubmitTypeItem alloc] initWithType:type];
    }
    return self;
}

@end

@interface JMBoomSubmitTypeOptionCell ()

@property (nonatomic, strong) JMBoomSubmitTypeOptionCellModel *model;

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation JMBoomSubmitTypeOptionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    return self;
}

#pragma mark - setup UI

- (void)setupUI {
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subtitleLabel];
    [self.contentView addSubview:self.bottomLine];
    
    self.sizeJM = CGSizeMake(kScreenWidth, 76);
    self.contentView.frame = CGRectMake(0, 0,
                                        self.widthJM - ((kIsSpecialScreen && kIsLandscape) ? 44*2 : 0),
                                        self.heightJM);
    
    [self.iconImageView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(40, 40);
        make.leftJM = 20;
        make.centerYJM = self.contentView.centerYJM;
    }];
    [self.titleLabel jm_layout:^(UIView * _Nonnull make) {
        [make sizeToFit];
        make.leftJM = self.iconImageView.rightJM + 16;
        make.topJM = 16;
    }];
    [self.subtitleLabel jm_layout:^(UIView * _Nonnull make) {
        [make sizeToFit];
        make.leftJM = self.iconImageView.rightJM + 16;
        make.bottomJM = self.contentView.bottomJM - 16;
    }];
    [self.bottomLine jm_layout:^(UIView * _Nonnull make) {
        make.widthJM = self.contentView.widthJM;
        make.heightJM = 1.0f / UIScreen.mainScreen.scale;
        make.bottomJM = self.contentView.heightJM;
        make.centerXJM = self.contentView.centerXJM;
    }];
}

#pragma mark - setup UI response

- (void)setupUIResponse {
    
}

#pragma mark - bind model

- (void)bindModel {
    self.iconImageView.image = self.model.item.icon;
    self.titleLabel.text = self.model.item.title;
    self.subtitleLabel.text = self.model.item.content;
    
    [self setupUI];
}

#pragma mark - protocol

#pragma mark - setter

#pragma mark - getter

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithRed:51/255.0
                                                green:51/255.0
                                                 blue:51/255.0
                                                alpha:1.0];
        _titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel {
    if (!_subtitleLabel) {
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.textColor = [UIColor colorWithRed:102/255.0
                                                   green:102/255.0
                                                    blue:102/255.0
                                                   alpha:1.0];
        _subtitleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _subtitleLabel;
}

- (UIView *)bottomLine {
    if (!_bottomLine) {
        _bottomLine = [[UIView alloc] init];
        _bottomLine.backgroundColor = [UIColor colorWithRed:233/255.0
                                                      green:233/255.0
                                                       blue:233/255.0
                                                      alpha:1.0];
    }
    return _bottomLine;
}

@end
