//
//  JMBoomSubmitDetailViewController.m
//  JMBoomSubmitBusiness
//
//  Created by Thief Toki on 2021/3/11.
//

#import "JMBoomSubmitDetailViewController.h"

#import <JMBoomSDKBase/JMBoomSDKBase.h>

#import "JMBoomSubmitDetailTipsCell.h"
#import "JMBoomSubmitDetailServiceCell.h"
#import "JMBoomSubmitDetailPlayerCell.h"

#import "JMBoomSDKRequest+JMBoomSubmitBusiness.h"

@interface JMBoomSubmitDetailViewController ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, assign) NSInteger submitId;
@property (nonatomic, strong) NSMutableArray <JMTableViewCellModel *>*tableViewModels;

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation JMBoomSubmitDetailViewController

- (instancetype)initWithSubmitId:(NSInteger)submitId {
    self = [super init];
    if (self) {
        self.submitId = submitId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self bindModel];
    [self setupUI];
    [self setupUIResponse];
}

- (void)viewWillAppear:(BOOL)animated {
    [self setupUI];
}

- (void)dismiss {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - bind model

- (void)bindModel {
    self.title = @"反馈详情";
    
    [self refresh];
}

- (void)refresh {
    self.tableViewModels = [NSMutableArray array];
    [self queryDetailWithSubmitId:self.submitId];
}

- (void)loadMore {
    
}

- (void)queryDetailWithSubmitId:(NSInteger)submitId {
    __weak typeof(self) weakSelf = self;
    [JMBoomSDKBusiness.request querySubmitHistoryDeiatlWithId:submitId
                                                     callback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            [JMRktDialog showError:error];
        } else {
            NSDictionary *submit = responseObject[@"result"];

            NSDictionary *reply = submit[@"replyRes"];
            NSString *replyStatus = submit[@"replyStatus"];
            if (replyStatus && replyStatus.boolValue) {
                JMBoomSubmitDetailServiceCellModel *service =
                [[JMBoomSubmitDetailServiceCellModel alloc] initWithDescribe:reply[@"describe"]
                                                                          name:reply[@"name"]
                                                                         reply:reply[@"reply"]
                                                                     replyTime:[reply[@"replyTime"] integerValue]/1000.0];
                [weakSelf.tableViewModels addObject:service];
            } else {
                JMBoomSubmitDetailTipsCellModel *tips =
                [[JMBoomSubmitDetailTipsCellModel alloc] initWithTitle:@"请不要着急哦，我们将以最快的速度回复您！"];
                [weakSelf.tableViewModels addObject:tips];
            }
            
            JMBoomSubmitDetailPlayerCellModel *player =
            [[JMBoomSubmitDetailPlayerCellModel alloc] initWithIssue:submit[@"issue"]
                                                             issueTime:[submit[@"issueTime"] integerValue]/1000.0
                                                            submitTime:[submit[@"createdOn"] integerValue]/1000.0
                                                             issueType:(JMBoomSubmitType)[submit[@"issueType"] integerValue]
                                                           screenshots:submit[@"screenshots"]];
            
            
            [weakSelf.tableViewModels addObject:player];
            [weakSelf.tableView reloadData];
        }
    }];
}

#pragma mark - setup UI

- (void)setupUI {
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:247/255.0 blue:248/255.0 alpha:1.0];
    self.navigationController.navigationBar.shadowImage = [JMBoomSDKResource imageNamed:@"sug_ic_line"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backButton];
    
    [self.view addSubview:self.tableView];
    [self.tableView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = self.view.sizeJM;
        make.topJM = 0;
        make.leftJM = 0;
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
}

- (void)didChangeStatusBarOrientation:(NSNotification *)notification{
    [self setupUI];
}

- (void)backButtonTapped {
    [self dismiss];
}

#pragma mark - protocol

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat distanceToBottom = scrollView.contentSize.height - (scrollView.heightJM + scrollView.contentOffset.y);
    if (distanceToBottom < 300) {
        [self loadMore];
    }
}

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
    
}

#pragma mark - setter

#pragma mark - getter

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.sizeJM = CGSizeMake(88, self.navigationController.navigationBar.heightJM);
        _backButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 68);
        _backButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_backButton setImage:[JMBoomSDKResource imageNamed:@"sug_ic_back_b"] forState:UIControlStateNormal];
        [_backButton setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]
                             forState:UIControlStateNormal];
    }
    return _backButton;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.contentInset = UIEdgeInsetsMake(20, 0, 13, 0);
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        
        [_tableView registerClass:[JMBoomSubmitDetailServiceCell class]
           forCellReuseIdentifier:NSStringFromClass([JMBoomSubmitDetailServiceCell class])];
        [_tableView registerClass:[JMBoomSubmitDetailPlayerCell class]
           forCellReuseIdentifier:NSStringFromClass([JMBoomSubmitDetailPlayerCell class])];
        [_tableView registerClass:[JMBoomSubmitDetailTipsCell class]
           forCellReuseIdentifier:NSStringFromClass([JMBoomSubmitDetailTipsCell class])];
    }
    return _tableView;
}

@end
