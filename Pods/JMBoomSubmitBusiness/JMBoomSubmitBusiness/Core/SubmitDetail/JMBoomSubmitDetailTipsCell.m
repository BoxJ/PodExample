//
//  JMBoomSubmitDetailTipsCell.m
//  JMBoomSubmitBusiness
//
//  Created by Thief Toki on 2021/3/11.
//

#import "JMBoomSubmitDetailTipsCell.h"

#import <JMUIKit/JMUIKit.h>
#import <SDWebImage/SDWebImage.h>
#import <JMBoomSDKBase/JMBoomSDKBase.h>

#import "JMBoomSubmitDetailPlayerItemCell.h"

@implementation JMBoomSubmitDetailTipsCellModel

- (instancetype)initWithTitle:(NSString *)title {
    self = [super init];
    if (self) {
        self.cls = [JMBoomSubmitDetailTipsCell class];
        
        self.title = title;
    }
    return self;
}

@end

@interface JMBoomSubmitDetailTipsCell ()

@property (nonatomic, strong) JMBoomSubmitDetailTipsCellModel *model;

@property (nonatomic, strong) UIView *boardView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation JMBoomSubmitDetailTipsCell

#pragma mark - setup UI

- (void)setupUI {
    [self.contentView addSubview:self.boardView];
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    
    self.sizeJM = CGSizeMake(kScreenWidth, 44);
    self.contentView.frame = CGRectMake(0, 0,
                                        self.widthJM - ((kIsSpecialScreen && kIsLandscape) ? 44*2 : 0),
                                        self.heightJM);
    
    [self.boardView jm_layout:^(UIView * _Nonnull make) {
        CGFloat margin = 15;
        make.sizeJM = CGSizeMake(self.contentView.widthJM - margin*2, 32);
        make.topJM = 0;
        make.centerXJM = self.contentView.centerXJM;
    }];
    [self.iconImageView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(12, 15);
        make.centerYJM = self.boardView.centerYJM;
        make.leftJM = self.boardView.leftJM + 10;
    }];
    [self.titleLabel jm_layout:^(UIView * _Nonnull make) {
        [make sizeToFit];
        make.centerYJM = self.boardView.centerYJM;
        make.leftJM = self.iconImageView.rightJM + 5;
    }];
}

#pragma mark - setup UI response

- (void)setupUIResponse {
    
}

#pragma mark - bind model

- (void)bindModel {
    self.titleLabel.text = self.model.title;
    
    [self setupUI];
}

#pragma mark - protocol

#pragma mark - setter

#pragma mark - getter

- (UIView *)boardView {
    if (!_boardView) {
        _boardView = [[UIView alloc] init];
        _boardView.backgroundColor = [UIColor colorWithRed:226/255.0
                                                     green:232/255.0
                                                      blue:248/255.0
                                                     alpha:1.0];
        _boardView.layer.cornerRadius = [[[JMBoomSDKResource shared] resourceWithName:JMBRNCorner] floatValue];
        _boardView.layer.masksToBounds = YES;
    }
    return _boardView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [JMBoomSDKResource imageNamed:@"sug_ic_tip"];
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
        _titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _titleLabel;
}

@end
