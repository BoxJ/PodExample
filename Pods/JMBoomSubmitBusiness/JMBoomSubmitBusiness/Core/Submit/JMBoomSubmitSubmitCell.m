//
//  JMBoomSubmitSubmitCell.m
//  JMBoomSubmitBusiness
//
//  Created by Thief Toki on 2021/3/11.
//

#import "JMBoomSubmitSubmitCell.h"

#import <JMUIKit/JMUIKit.h>
#import <JMBoomSDKBase/JMBoomSDKBase.h>

@implementation JMBoomSubmitSubmitCellModel

- (instancetype)initWithHasLog:(BOOL)hasLog
                        submit:(void (^)(void))submit {
    self = [super init];
    if (self) {
        self.cls = [JMBoomSubmitSubmitCell class];
        
        self.hasLog = hasLog;
        self.submit = submit;
    }
    return self;
}

@end

@interface JMBoomSubmitSubmitCell ()

@property (nonatomic, strong) JMBoomSubmitSubmitCellModel *model;

@property (nonatomic, strong) UIImageView *hasLogCheckImageView;
@property (nonatomic, strong) UILabel *hasLogCheckLabel;
@property (nonatomic, strong) UIButton *hasLogCheckButton;
@property (nonatomic, strong) JMCommonButton *submitButton;

@end

@implementation JMBoomSubmitSubmitCell

#pragma mark - setup UI

- (void)setupUI {
    [self.contentView addSubview:self.hasLogCheckImageView];
    [self.contentView addSubview:self.hasLogCheckLabel];
    [self.contentView addSubview:self.hasLogCheckButton];
    [self.contentView addSubview:self.submitButton];
    
    self.sizeJM = CGSizeMake(kScreenWidth, 134);
    self.contentView.frame = CGRectMake(0, 0,
                                        self.widthJM - ((kIsSpecialScreen && kIsLandscape) ? 44*2 : 0),
                                        self.heightJM);
    
    [self.hasLogCheckImageView jm_layout:^(UIView * _Nonnull make) {
        make.widthJM = 16;
        make.heightJM = 16;
        make.topJM = 14;
        make.leftJM = 15;
    }];
    [self.hasLogCheckLabel jm_layout:^(UIView * _Nonnull make) {
        [make sizeToFit];
        make.leftJM = self.hasLogCheckImageView.rightJM + 6;
        make.centerYJM = self.hasLogCheckImageView.centerYJM;
    }];
    [self.hasLogCheckButton jm_layout:^(UIView * _Nonnull make) {
        make.widthJM = self.hasLogCheckLabel.rightJM - self.hasLogCheckImageView.leftJM;
        make.heightJM = self.hasLogCheckImageView.heightJM;
        make.leftJM = self.hasLogCheckImageView.leftJM;
        make.topJM = self.hasLogCheckImageView.topJM;
    }];
    [self.submitButton jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(300, 48);
        make.topJM = 57;
        make.centerXJM = self.contentView.centerXJM;
    }];
}

#pragma mark - setup UI response

- (void)setupUIResponse {
    [self.hasLogCheckButton addTarget:self action:@selector(hasLogCheckButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.submitButton addTarget:self action:@selector(submitButtonTapped) forControlEvents:UIControlEventTouchUpInside];
}

- (void)hasLogCheckButtonTapped {
    self.model.hasLog = !self.model.hasLog;
    [self setupUI];
}

- (void)submitButtonTapped {
    if (self.model.submit) self.model.submit();
}

#pragma mark - bind model

- (void)bindModel {
    self.hasLogCheckImageView.image = [JMBoomSDKResource imageNamed:self.model.hasLog ? @"sug_ic_select" : @"sug_ic_unselect"];
    
    [self setupUI];
}

#pragma mark - protocol

#pragma mark - setter

#pragma mark - getter

- (UIImageView *)hasLogCheckImageView {
    if (!_hasLogCheckImageView) {
        _hasLogCheckImageView = [[UIImageView alloc] init];
    }
    return _hasLogCheckImageView;
}

- (UILabel *)hasLogCheckLabel {
    if (!_hasLogCheckLabel) {
        _hasLogCheckLabel = [[UILabel alloc] init];
        _hasLogCheckLabel.text = @"上传报错日志";
        _hasLogCheckLabel.textColor = [UIColor colorWithRed:153/255.0
                                                      green:153/255.0
                                                       blue:153/255.0
                                                      alpha:1.0];
        _hasLogCheckLabel.font = [UIFont systemFontOfSize:12];
    }
    return _hasLogCheckLabel;
}

- (UIButton *)hasLogCheckButton {
    if (!_hasLogCheckButton) {
        _hasLogCheckButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _hasLogCheckButton;
}

- (JMCommonButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [JMCommonButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
    }
    return _submitButton;
}

@end
