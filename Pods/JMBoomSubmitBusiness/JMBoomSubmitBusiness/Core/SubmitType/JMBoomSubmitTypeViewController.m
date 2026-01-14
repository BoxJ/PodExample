//
//  JMBoomSubmitTypeViewController.m
//  JMBoomSubmitBusiness
//
//  Created by Thief Toki on 2021/3/11.
//

#import "JMBoomSubmitTypeViewController.h"

#import <JMUIKit/JMUIKit.h>
#import <JMBoomSDKBase/JMBoomSDKBase.h>

#import "JMBoomSubmitTypeOptionCell.h"

@interface JMBoomSubmitTypeViewController ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong) void(^selectedCallback)(JMBoomSubmitTypeItem *item);
@property (nonatomic, strong) NSArray <JMTableViewCellModel *>*tableViewModels;

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation JMBoomSubmitTypeViewController

- (instancetype)initWithSelectedCallback:(void(^)(JMBoomSubmitTypeItem *item))selectedCallback {
    self = [super init];
    if (self) {
        self.selectedCallback = selectedCallback;
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
    self.title = @"问题类型";
    
    self.tableViewModels = @[
        [[JMBoomSubmitTypeOptionCellModel alloc] initWithType:JMBoomSubmitType_idea],
        [[JMBoomSubmitTypeOptionCellModel alloc] initWithType:JMBoomSubmitType_bug],
        [[JMBoomSubmitTypeOptionCellModel alloc] initWithType:JMBoomSubmitType_nature],
        [[JMBoomSubmitTypeOptionCellModel alloc] initWithType:JMBoomSubmitType_login],
        [[JMBoomSubmitTypeOptionCellModel alloc] initWithType:JMBoomSubmitType_recharge],
        [[JMBoomSubmitTypeOptionCellModel alloc] initWithType:JMBoomSubmitType_others],
    ];
}

#pragma mark - setup UI

- (void)setupUI {
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.view.backgroundColor = [UIColor whiteColor];
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
    JMBoomSubmitTypeOptionCellModel *model = (JMBoomSubmitTypeOptionCellModel *)self.tableViewModels[indexPath.row];
    if (self.selectedCallback) self.selectedCallback(model.item);
    [self.navigationController popViewControllerAnimated:YES];
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
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        
        [_tableView registerClass:[JMBoomSubmitTypeOptionCell class]
           forCellReuseIdentifier:NSStringFromClass([JMBoomSubmitTypeOptionCell class])];
    }
    return _tableView;
}

@end
