//
//  JMTipsModalView.m
//  JMUIKit
//
//  Created by Thief Toki on 2020/8/12.
//

#import "JMTipsModalView.h"

#import "JMCompositeTitleView.h"
#import "JMCommonButton.h"

#import "UIColor+JMExtension.h"
#import "UIView+JMLayout.h"

typedef NS_OPTIONS(NSUInteger, JMTipsModalViewType) {
    JMTipsModalViewType_None = 1 << 0,
    JMTipsModalViewType_Confirm = 1 << 1,
    JMTipsModalViewType_Cancel = 1 << 2,
};

@interface JMTipsModalView ()

@property (nonatomic, assign) BOOL isImageTitle;
@property (nonatomic, assign) JMTipsModalViewType type;
@property (nonatomic, assign) NSTimeInterval cancelEnableDelay;

@property (nonatomic, strong) NSString *title; ///< 标题
@property (nonatomic, strong) UIImage *titleImage; ///< 图片标题， 赋值后会覆盖title
@property (nonatomic, strong) NSString *message; ///< 内容
@property (nonatomic, strong) NSAttributedString *attributedMessage; ///< 富文本内容， 赋值后会覆盖message
@property (nonatomic, strong) NSString *confirmTitle; ///< 确认按钮标题
@property (nonatomic, strong) NSString *cancelTitle; ///< 取消按钮标题

@property (nonatomic, strong) JMCompositeTitleView *titleView;
@property (nonatomic, strong) UIImageView *titleImageView;
@property (nonatomic, strong) UITextView *messageTextView;
@property (nonatomic, strong) JMCommonButton *confirmButton;
@property (nonatomic, strong) JMCommonButton *cancelButton;

@end

@implementation JMTipsModalView

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                 confirmTitle:(NSString *)confirmTitle {
    return [self initWithTitle:title
                    titleImage:nil
                       message:message
             attributedMessage:nil
                  confirmTitle:confirmTitle
                   cancelTitle:nil];
}

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                 confirmTitle:(NSString *)confirmTitle
                  cancelTitle:(NSString *)cancelTitle {
    return [self initWithTitle:title
                    titleImage:nil
                       message:message
             attributedMessage:nil
                  confirmTitle:confirmTitle
                   cancelTitle:cancelTitle];
}

- (instancetype)initWithTitle:(NSString *)title
                   titleImage:(UIImage *)titleImage
                      message:(NSString *)message
            attributedMessage:(NSAttributedString *)attributedMessage
                 confirmTitle:(NSString *)confirmTitle
                  cancelTitle:(NSString *)cancelTitle {
    self = [self init];
    if (self) {
        self.title = title;
        self.titleImage = titleImage;
        if (message) self.message = message;
        if (attributedMessage) self.attributedMessage = attributedMessage;
        self.confirmTitle = confirmTitle;
        self.cancelTitle = cancelTitle;
        
        self.type = JMTipsModalViewType_None;
        if (confirmTitle.length > 0) {
            self.type |= JMTipsModalViewType_Confirm;
        }
        if (cancelTitle.length > 0) {
            self.type |= JMTipsModalViewType_Cancel;
        }
        
        self.isImageTitle = !!self.titleImage;
        
        [self setupUI];
        [self setupUIResponse];
    }
    return self;
}

- (instancetype)cancelEnableDelay:(NSTimeInterval)cancelEnableDelay {
    self.cancelEnableDelay = cancelEnableDelay;
    return self;
}

#pragma mark - setup UI

- (void)setupUI {
    [super setupUI];
    
    [self.contentView addSubview:self.boardImageView];
    [self.contentView addSubview:self.titleImageView];
    [self.contentView addSubview:self.titleView];
    [self.contentView addSubview:self.messageTextView];
    [self.contentView addSubview:self.confirmButton];
    [self.contentView addSubview:self.cancelButton];
    
    [self.titleImageView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(48, 48);
    }];
    
    [self.titleView jm_layout:^(UIView * _Nonnull make) {
        [make sizeToFit];
    }];
    
    [self.messageTextView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(320 - 20*2, 0);
        [make sizeToFit];
    }];
    
    CGFloat title_message_interval = 12;
    
    [self.boardImageView jm_layout:^(UIView * _Nonnull make) {
        if (self.isImageTitle) {
            make.sizeJM = CGSizeMake(320, 24 + self.titleImageView.heightJM + title_message_interval + self.messageTextView.heightJM + 24 + 48 + 23);
        } else {
            make.sizeJM = CGSizeMake(320, 24 + self.titleView.heightJM + title_message_interval + self.messageTextView.heightJM + 24 + 48 + 23);
        }
        make.centerXJM = self.contentView.centerXJM;
        make.centerYJM = self.contentView.centerYJM;
    }];
    
    [self.titleImageView jm_layout:^(UIView * _Nonnull make) {
        make.topJM = self.boardImageView.topJM + 27;
        make.centerXJM = self.contentView.centerXJM;
    }];
    
    [self.titleView jm_layout:^(UIView * _Nonnull make) {
        make.topJM = self.boardImageView.topJM + 21;
        make.centerXJM = self.boardImageView.centerXJM;
    }];
    
    [self.messageTextView jm_layout:^(UIView * _Nonnull make) {
        if (self.isImageTitle) {
            make.topJM = self.titleImageView.bottomJM + title_message_interval;
        } else {
            make.topJM = self.titleView.bottomJM + title_message_interval;
        }
        make.centerXJM = self.boardImageView.centerXJM;
    }];
    
    if (self.type & JMTipsModalViewType_Confirm) {
        if (self.type == (JMTipsModalViewType_Confirm | JMTipsModalViewType_None)) {
            [self.confirmButton jm_layout:^(UIView * _Nonnull make) {
                make.sizeJM = CGSizeMake(260, 48);
                make.topJM = self.messageTextView.bottomJM + 27;
                make.centerXJM = self.boardImageView.centerXJM;
            }];
        } else {
            [self.confirmButton jm_layout:^(UIView * _Nonnull make) {
                make.sizeJM = CGSizeMake(120, 48);
                make.topJM = self.messageTextView.bottomJM + 27;
                make.leftJM = self.boardImageView.centerXJM + 10;
            }];
        }
    }
    
    if (self.type & JMTipsModalViewType_Cancel) {
        if (self.type == (JMTipsModalViewType_Cancel | JMTipsModalViewType_None)) {
            [self.cancelButton jm_layout:^(UIView * _Nonnull make) {
                make.sizeJM = CGSizeMake(260, 48);
                make.topJM = self.messageTextView.bottomJM + 27;
                make.centerXJM = self.boardImageView.centerXJM;
            }];
        } else {
            [self.cancelButton jm_layout:^(UIView * _Nonnull make) {
                make.sizeJM = CGSizeMake(120, 48);
                make.topJM = self.messageTextView.bottomJM + 27;
                make.rightJM = self.boardImageView.centerXJM - 10;
            }];
        }
    }
}

#pragma mark - setup UI response

- (void)setupUIResponse {
    [super setupUIResponse];
    
    [self.confirmButton addTarget:self
                           action:@selector(confirmButtonTapped)
                 forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton addTarget:self
                          action:@selector(cancelButtonTapped)
                forControlEvents:UIControlEventTouchUpInside];
}

- (void)confirmButtonTapped {
    [self dismissSuccess:@{}];
}

- (void)cancelButtonTapped {
    [self dismissCancel];
}

#pragma mark - action

- (void)show:(JMResponder *)responder {
    [super show:responder];
    
    self.cancelButton.enabled = NO;
    self.cancelButton.alpha = 0.5;
    [NSTimer scheduledTimerWithTimeInterval:self.cancelEnableDelay
                                     target:self
                                   selector:@selector(cancelEnable)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)cancelEnable {
    self.cancelButton.enabled = YES;
    self.cancelButton.alpha = 1;
}

#pragma mark - protocol

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    [[UIApplication sharedApplication] openURL:URL];
    return NO;
}

#pragma mark - setter

- (void)setMessage:(NSString *)message {
    if ([message hasHTMLTag]) {
        self.attributedMessage = [[NSAttributedString alloc] initWithData:[message dataUsingEncoding:NSUnicodeStringEncoding]
                                                                  options:@{
                                                                      NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType
                                                                  }
                                                       documentAttributes:nil
                                                                    error:nil];
    } else {
        _message = message;
    }
}

#pragma mark - getter

- (JMCompositeTitleView *)titleView {
    if (!_titleView) {
        _titleView = [[JMCompositeTitleView alloc] init];
        _titleView.titleLabel.text = self.title ?: @"提示";
        _titleView.hidden = self.isImageTitle;
    }
    return _titleView;
}

- (UIImageView *)titleImageView {
    if (!_titleImageView) {
        _titleImageView = [[UIImageView alloc] init];
        _titleImageView.image = self.titleImage;
    }
    return _titleImageView;
}

- (UITextView *)messageTextView {
    if (!_messageTextView) {
        _messageTextView = [[UITextView alloc] init];
        if (self.attributedMessage) {
            _messageTextView.attributedText = self.attributedMessage;
        } else {
            _messageTextView.text = self.message;
            _messageTextView.textColor = [UIColor colorWithWhite:51/255.0 alpha:1];
            _messageTextView.textAlignment = NSTextAlignmentCenter;
            _messageTextView.font = [UIFont systemFontOfSize:15];
        }
        _messageTextView.backgroundColor = UIColor.clearColor;
        _messageTextView.textContainerInset = UIEdgeInsetsZero;
        _messageTextView.editable = NO;
        _messageTextView.scrollEnabled = NO;
        _messageTextView.dataDetectorTypes = UIDataDetectorTypeLink;
        _messageTextView.delegate = self;
    }
    return _messageTextView;
}

- (JMCommonButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [JMCommonButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitle:self.confirmTitle?:@"确定" forState:UIControlStateNormal];
    }
    return _confirmButton;
}

- (JMCommonButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [JMCommonButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:self.cancelTitle?:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:JMThemeFetchT(JMTipsModalView, cancelButtonTitleColor)
                            forState:UIControlStateNormal];
        _cancelButton.backgroundColor = [UIColor clearColor];
        _cancelButton.layer.borderColor = [UIColor colorWithWhite:222/255.0 alpha:1].CGColor;
        _cancelButton.layer.borderWidth = 1;
    }
    return _cancelButton;
}

@end
