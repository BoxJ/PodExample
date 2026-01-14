//
//  JMBoomSubmitDescriptionCell.m
//  JMBoomSubmitBusiness
//
//  Created by Thief Toki on 2021/3/12.
//

#import "JMBoomSubmitDescriptionCell.h"

#import <JMUIKit/JMUIKit.h>
#import <JMBoomSDKBase/JMBoomSDKBase.h>

@implementation JMBoomSubmitDescriptionCellModel

- (instancetype)initWithTitle:(NSString *)title
                     subtitle:(NSString *)subtitle
                  placeholder:(NSString *)placeholder
                      content:(NSString *)content
                   wordsLimit:(NSInteger)wordsLimit
                      hasMark:(BOOL)hasMark {
    self = [super init];
    if (self) {
        self.cls = [JMBoomSubmitDescriptionCell class];
        
        self.title = title;
        self.subtitle = subtitle;
        self.placeholder = placeholder;
        self.content = content;
        self.wordsLimit = wordsLimit;
        self.hasMark = hasMark;
    }
    return self;
}

@end

@interface JMBoomSubmitDescriptionCell () <UITextViewDelegate>

@property (nonatomic, strong) JMBoomSubmitDescriptionCellModel *model;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *markLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIView *contentBackView;
@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, strong) UILabel *placeholderLabel;
@property (nonatomic, strong) UILabel *wordsLimitLabel;

@end

@implementation JMBoomSubmitDescriptionCell

#pragma mark - setup UI

- (void)setupUI {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.markLabel];
    [self.contentView addSubview:self.subtitleLabel];
    [self.contentView addSubview:self.contentBackView];
    [self.contentView addSubview:self.contentTextView];
    [self.contentView addSubview:self.placeholderLabel];
    [self.contentView addSubview:self.wordsLimitLabel];
    
    self.sizeJM = CGSizeMake(kScreenWidth, 187);
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
        CGFloat margin = 16;
        make.widthJM = self.contentView.widthJM - margin*2;
        make.heightJM = 132;
        make.leftJM = margin;
        make.topJM = self.titleLabel.bottomJM + 12;
    }];
    [self.contentTextView jm_layout:^(UIView * _Nonnull make) {
        CGFloat margin = 12;
        CGFloat textPadding = 4;
        CGFloat bottomSpace = 17;
        make.widthJM = self.contentBackView.widthJM - margin*2;
        make.heightJM = self.contentBackView.heightJM - (margin-textPadding)*2 - bottomSpace;
        make.leftJM = self.contentBackView.leftJM + margin;
        make.topJM = self.contentBackView.topJM + (margin-textPadding);
    }];
    [self.placeholderLabel jm_layout:^(UIView * _Nonnull make) {
        CGFloat margin = 12;
        make.widthJM = self.contentBackView.widthJM - margin*2;
        [make sizeToFit];
        make.leftJM = self.contentBackView.leftJM + 12;
        make.topJM = self.contentBackView.topJM + 12;
    }];
    [self.wordsLimitLabel jm_layout:^(UIView * _Nonnull make) {
        [make sizeToFit];
        make.rightJM = self.contentBackView.rightJM - 8;
        make.bottomJM = self.contentBackView.bottomJM - 6;
    }];
    
    [self textViewDidChange:self.contentTextView];
}

#pragma mark - setup UI response

- (void)setupUIResponse {
    
}

#pragma mark - bind model

- (void)bindModel {
    self.titleLabel.text = self.model.title;
    self.markLabel.text = self.model.hasMark ? @"*" : @"";
    self.subtitleLabel.text = self.model.subtitle;
    self.contentTextView.text = self.model.content;
    self.placeholderLabel.text = self.model.placeholder;
    
    [self setupUI];
}

#pragma mark - protocol

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.placeholderLabel.hidden = YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.placeholderLabel.hidden = textView.text.length > 0;
}

- (void)textViewDidChange:(UITextView *)textView {
    self.wordsLimitLabel.text = [NSString stringWithFormat:@"%zd/%zd",
                                 textView.text.length,
                                 self.model.wordsLimit];
    [self.wordsLimitLabel jm_layout:^(UIView * _Nonnull make) {
        [make sizeToFit];
        make.rightJM = self.contentBackView.rightJM - 8;
        make.bottomJM = self.contentBackView.bottomJM - 6;
    }];
    
    self.model.content = textView.text;
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

- (UITextView *)contentTextView {
    if (!_contentTextView) {
        _contentTextView = [[UITextView alloc] init];
        _contentTextView.delegate = self;
        _contentTextView.backgroundColor = UIColor.clearColor;
        _contentTextView.textColor = [UIColor colorWithRed:51/255.0
                                                     green:51/255.0
                                                      blue:51/255.0
                                                     alpha:1.0];
        _contentTextView.font = [UIFont systemFontOfSize:16];
    }
    return _contentTextView;
}

- (UILabel *)placeholderLabel {
    if (!_placeholderLabel) {
        _placeholderLabel = [[UILabel alloc] init];
        _placeholderLabel.userInteractionEnabled = NO;
        _placeholderLabel.numberOfLines = 0;
        _placeholderLabel.textColor = [UIColor colorWithRed:187/255.0
                                                      green:187/255.0
                                                       blue:187/255.0
                                                      alpha:1.0];
        _placeholderLabel.font = [UIFont systemFontOfSize:16];
    }
    return _placeholderLabel;
}

- (UILabel *)wordsLimitLabel {
    if (!_wordsLimitLabel) {
        _wordsLimitLabel = [[UILabel alloc] init];
        _wordsLimitLabel.userInteractionEnabled = NO;
        _wordsLimitLabel.textColor = [UIColor colorWithRed:187/255.0
                                                     green:187/255.0
                                                      blue:187/255.0
                                                     alpha:1.0];
        _wordsLimitLabel.font = [UIFont systemFontOfSize:12];
    }
    return _wordsLimitLabel;
}

@end
