//
//  JMBoomSubmitContactWayCell.m
//  JMBoomSubmitBusiness
//
//  Created by Thief Toki on 2021/3/14.
//

#import "JMBoomSubmitContactWayCell.h"

#import <JMUIKit/JMUIKit.h>
#import <JMBoomSDKBase/JMBoomSDKBase.h>

@implementation JMBoomSubmitContactWayCellModel

- (instancetype)initWithTitle:(NSString *)title
                     subtitle:(NSString *)subtitle
                  placeholder:(NSString *)placeholder
                      content:(NSString *)content
                      hasMark:(BOOL)hasMark {
    self = [super init];
    if (self) {
        self.cls = [JMBoomSubmitContactWayCell class];
        
        self.title = title;
        self.subtitle = subtitle;
        self.placeholder = placeholder;
        self.content = content;
        self.hasMark = hasMark;
    }
    return self;
}

@end

@interface JMBoomSubmitContactWayCell () <UITextFieldDelegate>

@property (nonatomic, strong) JMBoomSubmitContactWayCellModel *model;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *markLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIView *contentBackView;
@property (nonatomic, strong) JMKeyboardPreviewLinkTextField *contentTextField;

@end

@implementation JMBoomSubmitContactWayCell

#pragma mark - setup UI

- (void)setupUI {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.markLabel];
    [self.contentView addSubview:self.subtitleLabel];
    [self.contentView addSubview:self.contentBackView];
    [self.contentView addSubview:self.contentTextField];
    
    self.sizeJM = CGSizeMake(kScreenWidth, 92);
    self.contentView.frame = CGRectMake(0, 0,
                                        self.widthJM - ((kIsSpecialScreen && kIsLandscape) ? 44*2 : 0),
                                        self.heightJM);
    
    [self.titleLabel jm_layout:^(UIView * _Nonnull make) {
        [make sizeToFit];
        make.leftJM = 16;
        make.topJM = 16;
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
    [self.contentBackView jm_layout:^(UIView * _Nonnull make) {
        CGFloat margin = 15;
        make.widthJM = self.contentView.widthJM - margin*2;
        make.heightJM = 48;
        make.leftJM = margin;
        make.topJM = self.titleLabel.bottomJM + 10;
    }];
    [self.contentTextField jm_layout:^(UIView * _Nonnull make) {
        CGFloat margin = 14;
        CGFloat textPadding = 4;
        make.widthJM = self.contentBackView.widthJM - margin*2;
        make.heightJM = self.contentBackView.heightJM - (margin-textPadding)*2;
        make.leftJM = self.contentBackView.leftJM + margin;
        make.topJM = self.contentBackView.topJM + (margin-textPadding);
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
    self.contentTextField.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:self.model.placeholder
                                    attributes:@{
        NSFontAttributeName: [UIFont systemFontOfSize:14 weight:UIFontWeightRegular],
        NSForegroundColorAttributeName: [UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:1],
    }];
    self.contentTextField.text = self.model.content;
    
    [self setupUI];
}

#pragma mark - protocol

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.model.content = self.contentTextField.text;
}

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

- (UIView *)contentBackView {
    if (!_contentBackView) {
        _contentBackView = [[UIView alloc] init];
        _contentBackView.backgroundColor = [UIColor colorWithRed:245/255.0
                                                           green:247/255.0
                                                            blue:248/255.0
                                                           alpha:1.0];
        _contentBackView.layer.cornerRadius = [[[JMBoomSDKResource shared] resourceWithName:JMBRNCorner] floatValue];
        _contentBackView.layer.masksToBounds = YES;
    }
    return _contentBackView;
}

- (JMKeyboardPreviewLinkTextField *)contentTextField {
    if (!_contentTextField) {
        _contentTextField = [[JMKeyboardPreviewLinkTextField alloc] init];
        _contentTextField.delegate = self;
        _contentTextField.textColor = [UIColor colorWithRed:51/255.0
                                                      green:51/255.0
                                                       blue:51/255.0
                                                      alpha:1.0];
        _contentTextField.font = [UIFont systemFontOfSize:16];
    }
    return _contentTextField;
}

@end
