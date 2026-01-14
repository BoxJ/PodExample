//
//  JMSubmitDatePickerModalView.m
//  JMRktDialog
//
//  Created by Thief Toki on 2021/3/15.
//

#import "JMBoomSubmitDatePickerModalView.h"

#import <JMBoomSDKBase/JMBoomSDKBase.h>

@interface JMSubmitDatePickerModalView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) NSDate *originDate;
@property (nonatomic, strong) NSString *todayTitle;
@property (nonatomic, strong) NSString *todayYear;
@property (nonatomic, strong) NSString *todayDate;
@property (nonatomic, strong) NSString *selectedDate;
@property (nonatomic, strong) NSString *selectedHour;
@property (nonatomic, strong) NSString *selectedMinute;
@property (nonatomic, strong) NSArray <NSArray <NSString *>*>*dateSource;

@property (nonatomic, strong) JMCompositeTitleView *titleView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIPickerView *datePicker;
@property (nonatomic, strong) JMCommonButton *confirmButton;
@property (nonatomic, strong) JMCommonButton *cancelButton;

@end

@implementation JMSubmitDatePickerModalView

- (instancetype)initWithTitle:(NSString *)title
                 confirmTitle:(NSString *)confirmTitle
                  cancelTitle:(NSString *)cancelTitle {
    self = [self init];
    if (self) {
        self.title = title;
        self.confirmTitle = confirmTitle;
        self.cancelTitle = cancelTitle;
        
        [self bindModel];
        [self setupUI];
        [self setupUIResponse];
    }
    return self;
}

#pragma mark - bind model

- (void)bindModel {
    self.originDate = [NSDate date];
    self.todayTitle = @"今天";
    self.todayYear = [self.originDate stringValueWithFormat:@"yyyy年"];
    self.todayDate = [self.originDate stringValueWithFormat:@"MM月dd日"];
    
    NSMutableArray *dateArray = [NSMutableArray array];
    for (NSInteger i = 6; i > 0; i--) {
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:-(60*60*24*i)];
        [dateArray addObject:[date stringValueWithFormat:@"MM月dd日"]];
    }
    [dateArray addObject:self.todayTitle];
    
    NSMutableArray *hourArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 24; i++) {
        [hourArray addObject:[NSString stringWithFormat:@"%2zd时", i]];
    }
    
    NSMutableArray *minuteArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 60; i++) {
        [minuteArray addObject:[NSString stringWithFormat:@"%2zd分", i]];
    }
    
    self.dateSource = @[
        dateArray,
        hourArray,
        minuteArray,
    ];
}

#pragma mark - setup UI

- (void)setupUI {
    [super setupUI];
    
    self.boardImageView.image = nil;
    
    [self.contentView addSubview:self.boardImageView];
    [self.contentView addSubview:self.titleView];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.datePicker];
    [self.contentView addSubview:self.confirmButton];
    [self.contentView addSubview:self.cancelButton];
    
    [self.boardImageView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(320, 307);
        make.centerXJM = self.contentView.centerXJM;
        make.centerYJM = self.contentView.centerYJM;
    }];
    
    [self.titleView jm_layout:^(UIView * _Nonnull make) {
        [make sizeToFit];
        make.centerYJM = self.boardImageView.topJM + 24;
        make.centerXJM = self.boardImageView.centerXJM;
    }];
    
    [self.lineView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(320, 1);
        make.topJM = self.boardImageView.topJM + 48;
        make.centerXJM = self.boardImageView.centerXJM;
    }];
    
    [self.datePicker jm_layout:^(UIView * _Nonnull make) {
        CGFloat margin = 10;
        make.sizeJM = CGSizeMake(300, 194 - margin*2);
        make.topJM = self.lineView.bottomJM + margin;
        make.centerXJM = self.boardImageView.centerXJM;
    }];
    
    [self.confirmButton jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(120, 48);
        make.bottomJM = self.boardImageView.bottomJM - 20;
        make.leftJM = self.boardImageView.centerXJM + 10;
    }];
    
    [self.cancelButton jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(120, 48);
        make.bottomJM = self.boardImageView.bottomJM - 20;
        make.rightJM = self.boardImageView.centerXJM - 10;
    }];
    
    [self setupCurrentDate];
}

- (void)setupCurrentDate {
    [self.datePicker selectRow:6 inComponent:0 animated:NO];
    self.selectedDate = @"今天";
    
    NSString *hourString = [self.originDate stringValueWithFormat:@"HH"];
    NSInteger hour = [hourString integerValue];
    [self.datePicker selectRow:hour inComponent:1 animated:NO];
    self.selectedHour = [NSString stringWithFormat:@"%@时", hourString];
    
    NSString *minuteString = [self.originDate stringValueWithFormat:@"mm"];
    NSInteger minute = [minuteString integerValue];
    [self.datePicker selectRow:minute inComponent:2 animated:NO];
    self.selectedMinute = [NSString stringWithFormat:@"%@分", minuteString];
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
    NSString *dateString =
    [NSString stringWithFormat:@"%@%@%@%@",
     self.todayYear,
     ([self.selectedDate isEqualToString:self.todayTitle] ? self.todayDate : self.selectedDate),
     self.selectedHour,
     self.selectedMinute];
    NSDate *date = [NSDate dateWithString:dateString format:@"yyyy年MM月dd日HH时mm分"];
    if ([date compare:self.originDate] == NSOrderedAscending) {
        [self dismissSuccess:@{
            @"date": date,
        }];
    } else {
        [JMToast showToast:@"不能超过当前时间"];
    }
}

- (void)cancelButtonTapped {
    [self dismissCancel];
}

#pragma mark - protocol

#pragma mark UIPickerViewDataSource

// 返回需要展示的列（columns）的数目
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.dateSource.count;
}

// 返回每一列的行（rows）数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dateSource[component].count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    CGFloat width = 0;
    switch (component) {
        case 0:
            width = 120;
            break;
        case 1:
            width = 80;
            break;
        case 2:
            width = 80;
            break;
    }
    return width;
}

#pragma mark UIPickerViewDelegate

// 返回每一行的标题
- (NSAttributedString *)pickerView:(UIPickerView *)pickerView
             attributedTitleForRow:(NSInteger)row
                      forComponent:(NSInteger)component {
    return [[NSAttributedString alloc] initWithString:self.dateSource[component][row]
                                           attributes:@{
        NSFontAttributeName: [UIFont systemFontOfSize:18 weight:UIFontWeightRegular],
        NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1],
    }];
}

// 某一行被选择时调用
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *item = self.dateSource[component][row];
    switch (component) {
        case 0:
            self.selectedDate = item;
            break;
        case 1:
            self.selectedHour = item;
            break;
        case 2:
            self.selectedMinute = item;
            break;
    }
}

#pragma mark - setter

#pragma mark - getter

- (JMCompositeTitleView *)titleView {
    if (!_titleView) {
        _titleView = [[JMCompositeTitleView alloc] init];
        _titleView.titleLabel.text = self.title ?: @"选择时间";
    }
    return _titleView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithRed:233/255.0
                                                    green:233/255.0
                                                     blue:233/255.0
                                                    alpha:1.0];
    }
    return _lineView;
}

- (UIPickerView *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIPickerView alloc] init];
        _datePicker.delegate = self;
        _datePicker.dataSource = self;
    }
    return _datePicker;
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
        [_cancelButton setTitleColor:[[JMBoomSDKResource shared] resourceWithName:JMBRNButtonCancelTitleColor]
                            forState:UIControlStateNormal];
        _cancelButton.backgroundColor = [UIColor clearColor];
        _cancelButton.layer.borderColor = [UIColor colorWithWhite:222/255.0 alpha:1].CGColor;
        _cancelButton.layer.borderWidth = 1;
    }
    return _cancelButton;
}

@end
