//
//  JMBoomAgreementModalView.m
//  JMBoomInitializeBusiness
//
//  Created by ZhengXianda on 2021/11/29.
//

#import "JMBoomAgreementModalView.h"

#import <JMBoomSDKBase/JMBoomSDKBase.h>

#import "JMBoomAgreementItemView.h"

@interface JMBoomAgreementModalView () <UITextViewDelegate>

@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSAttributedString *attributedMessage;

@property (nonatomic, assign) NSTimeInterval cancelEnableDelay;

@property (nonatomic, strong) JMCompositeTitleView *titleView;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) UITextView *messageTextView;
@property (nonatomic, strong) JMBoomAgreementItemView *phoneItemView;
@property (nonatomic, strong) JMBoomAgreementItemView *storageItemView;
@property (nonatomic, strong) UILabel *tipsLabel;
@property (nonatomic, strong) JMCommonButton *confirmButton;
@property (nonatomic, strong) JMCommonButton *cancelButton;

@end

@implementation JMBoomAgreementModalView

- (instancetype)initWithMessage:(NSString *)message {
    self = [self init];
    if (self) {
        self.message = message;
        
        [self setupUI];
        [self setupUIResponse];
    }
    return self;
}

#pragma mark - setup UI

- (void)setupUI {
    [super setupUI];
    
    [self.contentView addSubview:self.boardImageView];
    [self.contentView addSubview:self.titleView];
    [self.contentView addSubview:self.contentScrollView];
    [self.contentScrollView addSubview:self.messageTextView];
    [self.contentScrollView addSubview:self.phoneItemView];
    [self.contentScrollView addSubview:self.storageItemView];
    [self.contentView addSubview:self.tipsLabel];
    [self.contentView addSubview:self.confirmButton];
    [self.contentView addSubview:self.cancelButton];
    
    CGFloat boardWidth = kIsLandscape ? 487 : 320;
    CGFloat contentHeight = kIsLandscape ? 198 : 290;
    
    [self.titleView jm_layout:^(UIView * _Nonnull make) {
        [make sizeToFit];
    }];
    [self.messageTextView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(boardWidth - (12+12)*2, 0);
        [make sizeToFit];
    }];
    self.contentScrollView.contentSize =
    CGSizeMake(boardWidth - 12 * 2,
               10 +
               self.messageTextView.heightJM +
               11 +
               52 +
               10 +
               52 +
               10);
    [self.contentScrollView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(boardWidth - 12 * 2, MIN(self.contentScrollView.contentSize.height, contentHeight));
    }];
    [self.tipsLabel jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(boardWidth - 20*2, 0);
        [make sizeToFit];
    }];
    
    [self.boardImageView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(boardWidth,
                                 15 +
                                 self.titleView.heightJM +
                                 15 +
                                 self.contentScrollView.heightJM +
                                 9 +
                                 self.tipsLabel.heightJM +
                                 10 +
                                 48 +
                                 19);
        make.centerXJM = self.contentView.centerXJM;
        make.centerYJM = self.contentView.centerYJM;
    }];
    
    [self.titleView jm_layout:^(UIView * _Nonnull make) {
        make.topJM = self.boardImageView.topJM + 15;
        make.centerXJM = self.boardImageView.centerXJM;
    }];
    
    [self.contentScrollView jm_layout:^(UIView * _Nonnull make) {
        make.topJM = self.titleView.bottomJM + 15;
        make.centerXJM = self.contentView.centerXJM;
    }];
    
    [self.messageTextView jm_layout:^(UIView * _Nonnull make) {
        make.topJM = 10;
        make.centerXJM = self.contentScrollView.centerXJM - self.contentScrollView.leftJM;
    }];
    
    [self.phoneItemView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(self.contentScrollView.widthJM - 12 - 17, 52);
        make.topJM = self.messageTextView.bottomJM + 11;
        make.leftJM = 12;
    }];
    
    [self.storageItemView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(self.contentScrollView.widthJM - 12 - 17, 52);
        make.topJM = self.phoneItemView.bottomJM + 10;
        make.leftJM = 12;
    }];
    
    [self.tipsLabel jm_layout:^(UIView * _Nonnull make) {
        make.topJM = self.contentScrollView.bottomJM + 9;
        make.centerXJM = self.boardImageView.centerXJM;
    }];
    
    [self.confirmButton jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(120, 48);
        make.topJM = self.tipsLabel.bottomJM + 10;
        make.leftJM = self.boardImageView.centerXJM + 10;
    }];
    [self.cancelButton jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(120, 48);
        make.topJM = self.tipsLabel.bottomJM + 10;
        make.rightJM = self.boardImageView.centerXJM - 10;
    }];
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

#pragma mark - protocol

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
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
        _titleView.titleLabel.text = @"用户协议和隐私政策";
    }
    return _titleView;
}

- (UIScrollView *)contentScrollView {
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] init];
        _contentScrollView.backgroundColor = [UIColor colorWithWhite:243/255.0 alpha:1];
        _contentScrollView.layer.cornerRadius = [[[JMBoomSDKResource shared] resourceWithName:JMBRNCorner] floatValue];
        _contentScrollView.layer.masksToBounds = YES;
    }
    return _contentScrollView;
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
        _messageTextView.textContainer.lineFragmentPadding = 0;
        _messageTextView.textContainerInset = UIEdgeInsetsZero;
        _messageTextView.textAlignment = NSTextAlignmentLeft;
        _messageTextView.editable = NO;
        _messageTextView.scrollEnabled = NO;
        _messageTextView.dataDetectorTypes = UIDataDetectorTypeLink;
        _messageTextView.delegate = self;
    }
    return _messageTextView;
}

- (JMBoomAgreementItemView *)phoneItemView {
    if (!_phoneItemView) {
        _phoneItemView = [[JMBoomAgreementItemView alloc] initWithIcon:@"agreement_ic_call"
                                                                 title:@"设备权限"
                                                                 intro:@"电话权限(设备通话状态和识别码)用于正常识别 手机设备和保证网络免流服务。"];
    }
    return _phoneItemView;
}

- (JMBoomAgreementItemView *)storageItemView {
    if (!_storageItemView) {
        _storageItemView = [[JMBoomAgreementItemView alloc] initWithIcon:@"agreement_ic_save"
                                                                   title:@"存储权限"
                                                                   intro:@"访问存储权限用于保存图片并体验分享和资源下 载更新等功能。"];
    }
    return _storageItemView;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.text = @"请充分阅读并理解上述协议，同意并接受全部条款后开始使用我们的产品和服务。";
        _tipsLabel.numberOfLines = 0;
        _tipsLabel.textColor = [UIColor colorWithWhite:51/255.0 alpha:1];
        _tipsLabel.font = [UIFont systemFontOfSize:12];
    }
    return _tipsLabel;
}

- (JMCommonButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [JMCommonButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitle:@"同意并继续" forState:UIControlStateNormal];
    }
    return _confirmButton;
}

- (JMCommonButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [JMCommonButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"不同意" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[[JMBoomSDKResource shared] resourceWithName:JMBRNButtonCancelTitleColor]
                            forState:UIControlStateNormal];
        _cancelButton.backgroundColor = [UIColor clearColor];
        _cancelButton.layer.borderColor = [UIColor colorWithWhite:222/255.0 alpha:1].CGColor;
        _cancelButton.layer.borderWidth = 1;
    }
    return _cancelButton;
}

@end
