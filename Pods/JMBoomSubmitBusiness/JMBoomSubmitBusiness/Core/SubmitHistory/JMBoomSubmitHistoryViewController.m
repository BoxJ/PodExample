//
//  JMBoomSubmitHistoryViewController.m
//  JMBoomSubmitBusiness
//
//  Created by Thief Toki on 2021/3/11.
//

#import "JMBoomSubmitHistoryViewController.h"

#import <JMRktCommon/JMRktCommon.h>
#import <JMBoomSDKBase/JMBoomSDKBase.h>

#import "JMBoomSubmitHistoryOptionCell.h"
#import "JMBoomSubmitDetailViewController.h"

#import "JMBoomSDKRequest+JMBoomSubmitBusiness.h"

@interface JMBoomSubmitHistoryViewController ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray <JMTableViewCellModel *>*tableViewModels;

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *tableViewFooter;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL canLoadMore;

@end

@implementation JMBoomSubmitHistoryViewController

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
    self.title = @"历史反馈";
    
    [self refresh];
}

- (void)refresh {
    self.tableViewModels = [NSMutableArray array];
    if (!self.isLoading) {
        self.isLoading = YES;
        [self queryHistoryWithSubmitId:0];
    }
}

- (void)loadMore {
    if (self.canLoadMore && !self.isLoading) {
        self.isLoading = YES;
        JMBoomSubmitHistoryOptionCellModel *lastModel = (JMBoomSubmitHistoryOptionCellModel *)self.tableViewModels.lastObject;
        [self queryHistoryWithSubmitId:lastModel.submitId];
    }
}

- (void)queryHistoryWithSubmitId:(NSInteger)submitId {
    __weak typeof(self) weakSelf = self;
    [JMBoomSDKBusiness.request querySubmitHistoryListWithId:submitId
                                                   callback:^(NSDictionary * _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            [JMRktDialog showError:error];
        } else {
            NSArray *submitList = responseObject[@"result"];
            self.canLoadMore = submitList.count == 20;

            NSMutableArray *newTableViewModels = [NSMutableArray array];
            for (NSDictionary *submit in submitList) {
                JMBoomSubmitHistoryOptionCellModel *cellModel =
                [[JMBoomSubmitHistoryOptionCellModel alloc] initWithId:[submit[@"feedbackId"] integerValue]
                                                             createdOn:[submit[@"createdOn"] integerValue]/1000.0
                                                            issueTitle:submit[@"issueTitle"]
                                                                  type:(JMBoomSubmitType)[submit[@"issueType"] integerValue]
                                                           issueStatus:[submit[@"replyStatus"] boolValue]];
                [newTableViewModels addObject:cellModel];
            }
            
            if (weakSelf.tableViewModels.count == 0) {
                [weakSelf.tableViewModels addObjectsFromArray:newTableViewModels];
                [weakSelf.tableView reloadData];
            } else {
                [weakSelf.tableView beginUpdates];
                for (JMBoomSubmitHistoryOptionCellModel *cellModel in newTableViewModels) {
                    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:weakSelf.tableViewModels.count
                                                                   inSection:0];
                    [weakSelf.tableViewModels addObject:cellModel];
                    
                    [weakSelf.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
                [weakSelf.tableView endUpdates];
            }
        }
        self.isLoading = NO;
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
    JMBoomSubmitHistoryOptionCellModel *model = (JMBoomSubmitHistoryOptionCellModel *)self.tableViewModels[indexPath.row];
    [self.navigationController pushViewController:[[JMBoomSubmitDetailViewController alloc] initWithSubmitId:model.submitId]
                                         animated:YES];
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
        _tableView.tableFooterView = self.tableViewFooter;
        _tableView.contentInset = UIEdgeInsetsMake(20, 0, 13, 0);
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        
        [_tableView registerClass:[JMBoomSubmitHistoryOptionCell class]
           forCellReuseIdentifier:NSStringFromClass([JMBoomSubmitHistoryOptionCell class])];
    }
    return _tableView;
}

- (UILabel *)tableViewFooter {
    if (!_tableViewFooter) {
        _tableViewFooter = [[UILabel alloc] init];
        _tableViewFooter.heightJM = 33;
        _tableViewFooter.font = [UIFont systemFontOfSize:12];
        _tableViewFooter.text = @"没有更多内容了";
        _tableViewFooter.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        _tableViewFooter.textAlignment = NSTextAlignmentCenter;
    }
    return _tableViewFooter;
}

@end
