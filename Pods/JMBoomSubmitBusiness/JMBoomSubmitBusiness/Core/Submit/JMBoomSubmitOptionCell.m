//
//  JMBoomSubmitOptionCell.m
//  JMBoomSubmitBusiness
//
//  Created by Thief Toki on 2021/3/11.
//

#import "JMBoomSubmitOptionCell.h"

#import <JMUIKit/JMUIKit.h>
#import <JMBoomSDKBase/JMBoomSDKBase.h>

@implementation JMBoomSubmitOptionCellModel

- (instancetype)initWithTitle:(NSString *)title
                     subtitle:(NSString *)subtitle
                  placeholder:(NSString *)placeholder
                      content:(NSString *)content
                      hasMark:(BOOL)hasMark {
    self = [super init];
    if (self) {
        self.cls = [JMBoomSubmitOptionCell class];
        
        self.title = title;
        self.subtitle = subtitle;
        self.placeholder = placeholder;
        self.content = content;
        self.hasMark = hasMark;
    }
    return self;
}

@end

@interface JMBoomSubmitOptionCell ()

@property (nonatomic, strong) JMBoomSubmitOptionCellModel *model;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *markLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation JMBoomSubmitOptionCell

#pragma mark - setup UI

- (void)setupUI {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.markLabel];
    [self.contentView addSubview:self.subtitleLabel];
    [self.contentView addSubview:self.placeholderLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.arrowImageView];
    [self.contentView addSubview:self.bottomLine];
    
    self.sizeJM = CGSizeMake(kScreenWidth, 60);
    self.contentView.frame = CGRectMake(0, 0,
                                        self.widthJM - ((kIsSpecialScreen && kIsLandscape) ? 44*2 : 0),
                                        self.heightJM);
    
    
    [self.titleLabel jm_layout:^(UIView * _Nonnull make) {
        [make sizeToFit];
        make.leftJM = 16;
        make.centerYJM = self.contentView.centerYJM;
    }];
    [self.markLabel jm_layout:^(UIView * _Nonnull make) {
        [make sizeToFit];
        make.leftJM = self.titleLabel.rightJM + 8;
        make.centerYJM = self.titleLabel.centerYJM;
    }];
    [self.subtitleLabel jm_layout:^(UIView * _Nonnull make) {
        [make sizeToFit];
        make.leftJM = self.model.hasMark ?
        (self.markLabel.rightJM  + 10) :
        (self.titleLabel.rightJM  + 10);
        make.centerYJM = self.titleLabel.centerYJM;
    }];
    [self.placeholderLabel jm_layout:^(UIView * _Nonnull make) {
        [make sizeToFit];
        make.rightJM = self.contentView.rightJM - 38;
        make.centerYJM = self.titleLabel.centerYJM;
    }];
    [self.contentLabel jm_layout:^(UIView * _Nonnull make) {
        [make sizeToFit];
        make.rightJM = self.contentView.rightJM - 38;
        make.centerYJM = self.titleLabel.centerYJM;
    }];
    [self.arrowImageView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(8, 13);
        make.rightJM = self.contentView.rightJM - 15;
        make.centerYJM = self.titleLabel.centerYJM;
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
    self.titleLabel.text = self.model.title;
    self.markLabel.text = self.model.hasMark ? @"*" : @"";
    self.subtitleLabel.text = self.model.subtitle;
    self.placeholderLabel.text = self.model.placeholder;
    self.contentLabel.text = self.model.content;
    
    BOOL hasCotent = self.model.content.length > 0;
    self.contentLabel.hidden = !hasCotent;
    self.placeholderLabel.hidden = hasCotent;
    
    [self setupUI];
}

#pragma mark - protocol

#pragma mark - setter

#pragma mark - getter

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

- (UILabel *)markLabel {
    if (!_markLabel) {
        _markLabel = [[UILabel alloc] init];
        _markLabel.textColor = [UIColor colorWithRed:255/255.0
                                               green:124/255.0
                                                blue:101/255.0
                                                alpha:1.0];
        _markLabel.font = [UIFont systemFontOfSize:16];
    }
    return _markLabel;
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

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.textColor = [UIColor colorWithRed:187/255.0
                                                      green:187/255.0
                                                       blue:187/255.0
                                                      alpha:1.0];
        _placeholderLabel.font = [UIFont systemFontOfSize:16];
    }
    return _placeholderLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = [UIColor colorWithRed:51/255.0
                                                  green:51/255.0
                                                   blue:51/255.0
                                                  alpha:1.0];
        _contentLabel.font = [UIFont systemFontOfSize:16];
    }
    return _contentLabel;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = [JMBoomSDKResource imageNamed:@"sug_ic_next"];
    }
    return _arrowImageView;
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
