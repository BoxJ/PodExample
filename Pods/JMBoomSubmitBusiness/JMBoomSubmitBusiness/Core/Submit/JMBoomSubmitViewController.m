//
//  JMBoomSubmitViewController.m
//  JMBoomSubmitBusiness
//
//  Created by Thief Toki on 2021/3/11.
//

#import "JMBoomSubmitViewController.h"

#import <JMUtils/JMUtils.h>
#import <JMUIKit/JMUIKit.h>
#import <JMBoomSDKBase/JMBoomSDKBase.h>

#import "JMBoomSubmitOptionCell.h"
#import "JMBoomSubmitDescriptionCell.h"
#import "JMBoomSubmitImageSelectorCell.h"
#import "JMBoomSubmitContactWayCell.h"
#import "JMBoomSubmitSubmitCell.h"
#import "JMBoomSubmitDatePickerModalView.h"

#import "JMBoomSubmitTypeViewController.h"
#import "JMBoomSubmitHistoryViewController.h"

#import "JMBoomSDKRequest+JMBoomSubmitBusiness.h"

@interface JMBoomSubmitViewController ()<
UITableViewDelegate,
UITableViewDataSource,
UIGestureRecognizerDelegate,
JMKeyboardPreviewViewDelegate>

@property (nonatomic, assign) BOOL hasHistory;
@property (nonatomic, strong) JMRktCommonCallback callback;

@property (nonatomic, assign) JMBoomSubmitType submitType;
@property (nonatomic, strong) NSDate *abnormalDate;
@property (nonatomic, strong) NSArray *screenshots;
@property (nonatomic, strong) NSString *logFile;

@property (nonatomic, strong) JMBoomSubmitOptionCellModel *submitTypeCellModel;
@property (nonatomic, strong) JMBoomSubmitOptionCellModel *submitDateCellModel;
@property (nonatomic, strong) JMBoomSubmitDescriptionCellModel *submitDescriptionCellModel;
@property (nonatomic, strong) JMBoomSubmitImageSelectorCellModel *submitImageSelectorCellModel;
@property (nonatomic, strong) JMBoomSubmitContactWayCellModel *submitContactWayCellModel;
@property (nonatomic, strong) JMBoomSubmitSubmitCellModel *submitSubmitCellModel;
@property (nonatomic, strong) NSArray <JMTableViewCellModel *>*tableViewModels;

@property (nonatomic, strong) JMCommonButton *keyboardPreviewConfirmButton;

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *historyButton;
@property (nonatomic, strong) JMModalView *modalView;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation JMBoomSubmitViewController

- (instancetype)initWithHistoryStatus:(BOOL)hasHistory callback:(JMRktCommonCallback)callback {
    self = [super init];
    if (self) {
        self.hasHistory = hasHistory;
        self.callback = callback;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self bindModel];
    [self setupUI];
    [self setupUIResponse];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - submit

- (void)submit {
    if (self.submitType == JMBoomSubmitType_none) { [JMToast showToast:@"请选择问题类型"]; return; }
    if (self.submitDescriptionCellModel.content.length == 0) { [JMToast showToast:@"请填写问题描述"]; return; }
    if (self.submitDescriptionCellModel.content.length < 10) { [JMToast showToast:@"问题描述不得低于10个字"]; return; }
    if (self.submitDescriptionCellModel.content.length > 200) { [JMToast showToast:@"问题描述不得多于200个字"]; return; }
    if (self.submitContactWayCellModel.content.length == 0) { [JMToast showToast:@"请填写联系方式"]; return; }
    
    [JMToast showToastLoading];
    [self uploadImages];
}

- (void)uploadImages {
    __weak typeof(self) weakSelf = self;
    [self.submitImageSelectorCellModel.acmodel selectingAssetImageList:^(NSArray * _Nonnull imageList) {
        [JMBoomSDKBusiness.qiniu uploadImages:imageList
                            callback:^(NSDictionary * _Nullable responseObject,
                                       NSError * _Nullable error) {
            if (error) {
                [JMRktDialog showError:error];
            } else {
                weakSelf.screenshots = responseObject[@"result"];
                if (weakSelf.submitSubmitCellModel.hasLog) {
                    [weakSelf uploadLogs];
                } else {
                    [weakSelf submitSend];
                }
            }
        }];
    }];
}

- (void)uploadLogs {
    [[JMLogger shared] save];
    [JMBoomSDKBusiness.qiniu uploadLogsWithDate:self.abnormalDate
                                       callback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            [JMRktDialog showError:error];
        } else {
            self.logFile = [responseObject[@"result"] firstObject];
            [self submitSend];
        }
    }];
}
     
- (void)submitSend {
    __weak typeof(self) weakSelf = self;
    [JMBoomSDKBusiness.request uploadSubmitWithContact:self.submitContactWayCellModel.content
                                               issue:self.submitDescriptionCellModel.content
                                           issueTime:self.abnormalDate
                                           issueType:self.submitType
                                             logFile:self.logFile
                                         screenshots:self.screenshots
                                            callback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            [JMRktDialog showError:error];
        } else {
            if (weakSelf.callback) weakSelf.callback([JMRktResponse successWithResult:@{
                @"issue":self.submitDescriptionCellModel.content,
                @"issueTime":@(self.abnormalDate.timeIntervalSince1970),
                @"issueType":@(self.submitType),
                @"openId":JMBoomSDKBusiness.info.openId,
            }], nil);
            [weakSelf dismiss];
            [JMToast showToastSuccess:@"提交成功"];
        }
    }];
}

#pragma mark - bind model

- (void)bindModel {
    self.title = @"建议反馈";
    
    self.historyButton.hidden = !self.hasHistory;
    
    self.tableViewModels = @[
        self.submitTypeCellModel,
        self.submitDateCellModel,
        self.submitDescriptionCellModel,
        self.submitImageSelectorCellModel,
        self.submitContactWayCellModel,
        self.submitSubmitCellModel,
    ];
}

#pragma mark - setup UI

- (void)setupUI {
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.historyButton];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.modalView];
    [self.modalView.contentView addSubview:self.tableView];
    
    [self.modalView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = self.view.sizeJM;
        make.center = self.view.center;
    }];
    [self.modalView.contentView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = self.modalView.sizeJM;
        make.center = self.modalView.center;
    }];
    [self.tableView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = self.modalView.contentView.sizeJM;
        make.center = self.modalView.contentView.center;
    }];
    [self.tableView reloadData];
}

#pragma mark - setup UI response

- (void)setupUIResponse {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangeStatusBarOrientation:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
    [self.backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.historyButton addTarget:self action:@selector(historyButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    __weak typeof(self) weakSelf = self;
    self.submitTypeCellModel.action = ^(NSIndexPath * _Nonnull indexPath) {
        JMBoomSubmitTypeViewController *vc = [[JMBoomSubmitTypeViewController alloc] initWithSelectedCallback:^(JMBoomSubmitTypeItem * _Nonnull item) {
            weakSelf.submitType = item.type;
            weakSelf.submitTypeCellModel.content = item.title;
            [weakSelf.tableView beginUpdates];
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [weakSelf.tableView endUpdates];
        }];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    self.submitDateCellModel.action = ^(NSIndexPath * _Nonnull indexPath) {
        [[[JMSubmitDatePickerModalView alloc] initWithTitle:@"选择异常时间"
                                             confirmTitle:@"确定"
                                              cancelTitle:@"取消"]
         show:[JMResponder success:^(NSDictionary *info) {
            weakSelf.abnormalDate = info[@"date"];
            weakSelf.submitDateCellModel.content = weakSelf.submitTimeString;
            [weakSelf.tableView beginUpdates];
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [weakSelf.tableView endUpdates];
        }]];
    };
    self.submitImageSelectorCellModel.update = ^(NSIndexPath * _Nonnull indexPath) {
        [weakSelf.tableView beginUpdates];
        [weakSelf.tableView endUpdates];
    };
    
    [JMKeyboardPreviewView shared].delegate = self;
}

- (void)didChangeStatusBarOrientation:(NSNotification *)notification{
    [self.tableView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = self.modalView.contentView.sizeJM;
        make.center = self.modalView.contentView.center;
    }];
    [self.tableView reloadData];
}

- (void)backButtonTapped {
    [self.view endEditing:YES];
    __weak typeof(self) weakSelf = self;
    JMTipsModalView *tipsModalView =
    [[JMTipsModalView alloc] initWithTitle:@"提示"
                                   message:@"你的反馈未提交，确认退出吗？"
                              confirmTitle:@"确定"
                               cancelTitle:@"取消"];
    tipsModalView.boardImageView.image = nil;
    [tipsModalView show:[JMResponder success:^(NSDictionary *info) {
        [weakSelf dismiss];
    }]];
}

- (void)historyButtonTapped {
    JMBoomSubmitHistoryViewController *vc = [[JMBoomSubmitHistoryViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - protocol

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableViewModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.tableViewModels[indexPath.row] tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.tableViewModels[indexPath.row].cellSize.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.tableViewModels[indexPath.row].action(indexPath);
}

- (UIButton *)confirmButtonForkeyboardPreviewView:(JMKeyboardPreviewView *)keyboardPreviewView {
    return self.keyboardPreviewConfirmButton;
}

#pragma mark - setter

#pragma mark - getter

- (NSString *)submitTimeString {
    NSDate *date = self.abnormalDate;
    if ([date isEqualToDate:NSDate.date.weeDate]) {
        return [@"今天" stringByAppendingString:[date stringValueWithFormat:@"HH:mm"]];
    } else {
        return [date stringValueWithFormat:@"MM月dd日 HH:mm"];
    }
}

- (NSDate *)abnormalDate {
    return _abnormalDate ?: [NSDate date];
}

- (JMBoomSubmitOptionCellModel *)submitTypeCellModel {
    if (!_submitTypeCellModel) {
        _submitTypeCellModel =
        [[JMBoomSubmitOptionCellModel alloc] initWithTitle:@"问题类型"
                                                    subtitle:@""
                                                 placeholder:@"请选择问题类型"
                                                     content:@""
                                                     hasMark:YES];
    }
    return _submitTypeCellModel;
}

- (JMBoomSubmitOptionCellModel *)submitDateCellModel {
    if (!_submitDateCellModel) {
        _submitDateCellModel =
        [[JMBoomSubmitOptionCellModel alloc] initWithTitle:@"异常时间"
                                                    subtitle:@""
                                                 placeholder:@""
                                                     content:self.submitTimeString
                                                     hasMark:YES];
    }
    return _submitDateCellModel;
}

- (JMBoomSubmitDescriptionCellModel *)submitDescriptionCellModel {
    if (!_submitDescriptionCellModel) {
        _submitDescriptionCellModel =
        [[JMBoomSubmitDescriptionCellModel alloc] initWithTitle:@"问题描述"
                                                         subtitle:@""
                                                      placeholder:@"请补充详细问题描述，这样我们会更好的处理哦"
                                                          content:@""
                                                       wordsLimit:200
                                                          hasMark:YES];
    }
    return _submitDescriptionCellModel;
}

- (JMBoomSubmitImageSelectorCellModel *)submitImageSelectorCellModel {
    if (!_submitImageSelectorCellModel) {
        NSInteger limit = 6;
        _submitImageSelectorCellModel =
        [[JMBoomSubmitImageSelectorCellModel alloc] initWithTitle:@"相关截图"
                                                           subtitle:[NSString stringWithFormat:@"(选填，最多%zd张)", limit]
                                                        imagesLimit:limit
                                                               tips:@"充值相关问题必须提供充值相关截图"
                                                            hasMark:NO];
    }
    return _submitImageSelectorCellModel;
}

- (JMBoomSubmitContactWayCellModel *)submitContactWayCellModel {
    if (!_submitContactWayCellModel) {
        _submitContactWayCellModel =
        [[JMBoomSubmitContactWayCellModel alloc] initWithTitle:@"联系方式"
                                                        subtitle:@""
                                                     placeholder:@"建议输入QQ号码"
                                                         content:@""
                                                         hasMark:YES];
    }
    return _submitContactWayCellModel;
}

- (JMBoomSubmitSubmitCellModel *)submitSubmitCellModel {
    if (!_submitSubmitCellModel) {
        __weak typeof(self) weakSelf = self;
        _submitSubmitCellModel =
        [[JMBoomSubmitSubmitCellModel alloc] initWithHasLog:YES
                                                       submit:^{
            [weakSelf submit];
        }];
    }
    return _submitSubmitCellModel;
}

- (JMCommonButton *)keyboardPreviewConfirmButton {
    if (!_keyboardPreviewConfirmButton) {
        _keyboardPreviewConfirmButton = [JMCommonButton buttonWithType:UIButtonTypeCustom];
        _keyboardPreviewConfirmButton.sizeJM = CGSizeMake(80, 36);
        [_keyboardPreviewConfirmButton setTitle:@"完成" forState:UIControlStateNormal];
    }
    return _keyboardPreviewConfirmButton;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.sizeJM = CGSizeMake(88, self.navigationController.navigationBar.heightJM);
        _backButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 68);
        [_backButton setImage:[JMBoomSDKResource imageNamed:@"sug_ic_back_b"] forState:UIControlStateNormal];
    }
    return _backButton;
}

- (UIButton *)historyButton {
    if (!_historyButton) {
        _historyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _historyButton.sizeJM = CGSizeMake(88, self.navigationController.navigationBar.heightJM);
        _historyButton.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
        _historyButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_historyButton setTitle:@"历史反馈" forState:UIControlStateNormal];
        [_historyButton setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]
                             forState:UIControlStateNormal];
    }
    return _historyButton;
}

- (JMModalView *)modalView {
    if (!_modalView) {
        _modalView = [[JMModalView alloc] init];
        [_modalView setupUI];
        [_modalView setupUIResponse];
    }
    return _modalView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        
        [_tableView registerClass:[JMBoomSubmitOptionCell class]
           forCellReuseIdentifier:NSStringFromClass([JMBoomSubmitOptionCell class])];
        [_tableView registerClass:[JMBoomSubmitDescriptionCell class]
           forCellReuseIdentifier:NSStringFromClass([JMBoomSubmitDescriptionCell class])];
        [_tableView registerClass:[JMBoomSubmitImageSelectorCell class]
           forCellReuseIdentifier:NSStringFromClass([JMBoomSubmitImageSelectorCell class])];
        [_tableView registerClass:[JMBoomSubmitContactWayCell class]
           forCellReuseIdentifier:NSStringFromClass([JMBoomSubmitContactWayCell class])];
        [_tableView registerClass:[JMBoomSubmitSubmitCell class]
           forCellReuseIdentifier:NSStringFromClass([JMBoomSubmitSubmitCell class])];
    }
    return _tableView;
}

@end
