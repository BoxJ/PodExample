//
//  JMBoomAgreementView.m
//  JMBoomSDK
//
//  Created by Thief Toki on 2020/8/5.
//

#import "JMBoomAgreementView.h"

#import <JMUtils/JMUtils.h>
#import <JMUIKit/JMUIKit.h>
#import <JMBoomSDKBase/JMBoomSDKBase.h>
#import <JMBoomSDKBase/JMBoomSDKBase.h>

@implementation JMBoomAgreementView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.isSelected = NO;
        
        [self setupUI];
        [self setupUIResponse];
    }
    return self;
}

#pragma mark - setup UI

- (void)setupUI {
    [self addSubview:self.selectedImageView];
    [self addSubview:self.checkButton];
    [self addSubview:self.agreementTextView];
    [self bringSubviewToFront:self.checkButton];
    
    switch (self.scene) {
        case JMAgreementScene_Login: {
            CGFloat offset = 25;
            
            self.selectedImageView.hidden = NO;
            [self.selectedImageView jm_layout:^(UIView * _Nonnull make) {
                make.sizeJM = CGSizeMake(14, 14);
                make.leftJM = offset;
                make.topJM = 0;
            }];
            
            self.checkButton.hidden = NO;
            [self.checkButton jm_layout:^(UIView * _Nonnull make) {
                make.sizeJM = CGSizeMake(self.selectedImageView.widthJM + 7*2, self.selectedImageView.heightJM + 7*2);
                make.center = self.selectedImageView.center;
            }];
            
            [self.agreementTextView jm_layout:^(UIView * _Nonnull make) {
                make.sizeJM = CGSizeMake(self.widthJM - self.selectedImageView.rightJM - self.selectedImageView.leftJM, self.heightJM);
                make.leftJM = self.selectedImageView.rightJM + 6;
                make.topJM = 0;
            }];
        }
            break;
        case JMAgreementScene_BindPhone: {
            CGFloat offset = 40;
            
            self.selectedImageView.hidden = YES;
            self.checkButton.hidden = YES;
            
            [self.agreementTextView jm_layout:^(UIView * _Nonnull make) {
                make.sizeJM = CGSizeMake(self.widthJM - offset * 2, self.heightJM);
                make.leftJM = offset;
                make.topJM = 0;
            }];
        }
            break;
    }
    
    [self setupAgreement];
}

- (void)setupAgreement {
    NSArray <NSString *>*links = [JMBoomSDKBusiness.info localAgreementLinks];
    NSString *linkTemplate = @"《-》";
    NSMutableArray *linksTemplate = [NSMutableArray array];
    for (NSInteger i = 0; i < links.count; i++) {
        [linksTemplate addObject:[linkTemplate copy]];
    }
    
    NSString *agreementString;
    
    switch (self.scene) {
        case JMAgreementScene_Login: {
            if (self.protocolName.length > 0 && self.protocolUrl.length > 0) {
                agreementString = [NSString stringWithFormat:@"我已阅读并同意《%@》和%@并授权应用获取本机号码",
                                   self.protocolName,
                                   [linksTemplate componentsJoinedByString:@""]];
            } else {
                if (linksTemplate.count > 1) {
                    [linksTemplate insertObject:@"和" atIndex:1];
                }
                agreementString = [NSString stringWithFormat:@"我已阅读并同意%@",
                                   [linksTemplate componentsJoinedByString:@""]];
            }
        }
            break;
        case JMAgreementScene_BindPhone: {
            agreementString = [NSString stringWithFormat:@"我已阅读并同意《%@》并授权应用获取本机号码", self.protocolName];
        }
            break;
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.firstLineHeadIndent = 0;
    paragraphStyle.headIndent = 0;
    paragraphStyle.tailIndent = 0;
    paragraphStyle.lineSpacing = 1.5;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    NSMutableAttributedString *attributedString =
    [[NSMutableAttributedString alloc] initWithString:agreementString
                                           attributes:@{
                                               NSFontAttributeName : [UIFont systemFontOfSize:11],
                                               NSForegroundColorAttributeName : [UIColor colorWithWhite:187/255.0 alpha:1],
                                               NSParagraphStyleAttributeName : paragraphStyle
                                           }];
    if (self.protocolName.length > 0 && self.protocolUrl.length > 0) {
        NSString *protocolFullName = [NSString stringWithFormat:@"《%@》", self.protocolName];
        [attributedString addAttributes:@{
            NSLinkAttributeName: [NSURL URLWithString:self.protocolUrl],
        }
                                  range:[[attributedString string] rangeOfString:protocolFullName]];
    }
    
    for (NSInteger i=0; i < links.count; i++) {
        NSString *link = links[i];
        NSAttributedString *linkAttributedString =
        [[NSAttributedString alloc] initWithData:[link dataUsingEncoding:NSUnicodeStringEncoding]
                                                                  options:@{
                                                                      NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType
                                                                  }
                                                       documentAttributes:nil
                                                                    error:nil];
        if ([attributedString.string containsString:@"《-》"]) {
            [attributedString replaceCharactersInRange:[[attributedString string] rangeOfString:@"《-》"]
                                  withAttributedString:linkAttributedString];
        } else {
            break;
        }
    }
    self.agreementTextView.attributedText = attributedString;
}

#pragma mark - setup UI response

- (void)setupUIResponse {
    [self.checkButton addTarget:self action:@selector(checkButtonTapped) forControlEvents:UIControlEventTouchUpInside];
}

- (void)checkButtonTapped {
    self.isSelected = !self.isSelected;
    if ([JMBoomSDKBusiness.info localAgreementThrough:YES]) {
        [JMBoomSDKBusiness.event uploadEvent:[JMBoomSDKEventItem event:JMBoomSDKEventId_Agreement_Through]];
    }
}

#pragma mark - action

- (void)updateProtocolName:(NSString *)protocolName
               protocolUrl:(NSString *)protocolUrl {
    self.protocolName = protocolName;
    self.protocolUrl = protocolUrl;
    [self setupUI];
}

- (void)updateScene:(JMAgreementScene)scene {
    self.scene = scene;
    [self setupUI];
}

#pragma mark - protocol

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
    return NO;
}

#pragma mark - setter

- (void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    
    UIImage *image = _isSelected
    ? [[JMBoomSDKResource shared] resourceWithName:JMBRNWindowCheckboxSelected]
    : [[JMBoomSDKResource shared] resourceWithName:JMBRNWindowCheckboxUnselected];
    UIColor *tintColor = _isSelected
    ? [[JMBoomSDKResource shared] resourceWithName:JMBRNWindowCheckboxSelectedTintColor]
    : [[JMBoomSDKResource shared] resourceWithName:JMBRNWindowCheckboxUnselectedTintColor];
    UIColor *backgroundColor = _isSelected
    ? [[JMBoomSDKResource shared] resourceWithName:JMBRNWindowCheckboxSelectedBackgroundColor]
    : [[JMBoomSDKResource shared] resourceWithName:JMBRNWindowCheckboxUnselectedBackgroundColor];
    
    self.selectedImageView.image = image;
    self.selectedImageView.tintColor = tintColor;
    self.selectedImageView.backgroundColor = backgroundColor;
}

#pragma mark - getter

- (UIImageView *)selectedImageView {
    if (!_selectedImageView) {
        _selectedImageView = [[UIImageView alloc] init];
        _selectedImageView.layer.cornerRadius = 7;
        _selectedImageView.layer.masksToBounds = YES;
    }
    return _selectedImageView;
}

- (UIButton *)checkButton {
    if (!_checkButton) {
        _checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _checkButton;
}

- (UITextView *)agreementTextView {
    if (!_agreementTextView) {
        _agreementTextView = [[UITextView alloc] init];
        _agreementTextView.backgroundColor = [UIColor clearColor];
        _agreementTextView.textContainer.lineFragmentPadding = 0.0;
        _agreementTextView.textContainerInset = UIEdgeInsetsZero;
        _agreementTextView.textAlignment = NSTextAlignmentLeft;
        _agreementTextView.layoutManager.allowsNonContiguousLayout=NO;
        _agreementTextView.editable = NO;
        _agreementTextView.scrollEnabled = NO;
        _agreementTextView.dataDetectorTypes = UIDataDetectorTypeLink;
        _agreementTextView.delegate = self;
        _agreementTextView.linkTextAttributes = @{
            NSForegroundColorAttributeName : [UIColor colorWithWhite:153/255.0 alpha:1],
            NSFontAttributeName: [UIFont systemFontOfSize:11 weight:UIFontWeightRegular],
        };
    }
    return _agreementTextView;
}

@end
