//
//  JMAlbumViewController.m
//  JMAssetPicker
//
//  Created by ZhengXianda on 2022/6/7.
//

#import "JMAlbumViewController.h"

#import <JMUtils/JMUtils.h>

#import "JMAssetPickerCore.h"
#import "JMAlbumTableViewCell.h"
#import "JMPickerViewController.h"

#import "PHAssetCollection+JMAssetPicker.h"

@interface JMAlbumViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) JMAssetPickerModel *model;
@property (nonatomic, strong) NSMutableArray <JMTableViewCellModel *>*tableViewModels;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) JMNavigatorView *navigatorView;

@end

@implementation JMAlbumViewController

- (instancetype)initWithImagePickerModel:(JMAssetPickerModel *)model {
    self = [super init];
    if (self) {
        self.model = model;
        
        [self.model fetchAlbums];
    }
    return self;
}

- (void)showPickerViewController:(NSInteger)index animated:(BOOL)animated {
    if (0 <= index && index < self.model.assetCollectionList.count) {
        JMPickerViewController *pickerViewController = [[JMPickerViewController alloc] initWithImagePickerModel:self.model index:index];
        [self.navigationController pushViewController:pickerViewController animated:animated];
    } else {
        JMLog(@"需要 JMPickerViewController 展示的相册不存在");
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self setupUIResponse];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self bindModel];
}

- (void)dismiss {
    [self dismissViewControllerAnimated:YES completion:^{
            
    }];
    [self.navigationController setNavigationBarHidden:NO];
}

#pragma mark - setup UI

- (void)setupUI {
    [self.navigationController setNavigationBarHidden:YES];
    
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:247/255.0 blue:248/255.0 alpha:1.0];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.navigatorView];
    [self.tableView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = self.view.sizeJM;
        make.topJM = 0;
        make.leftJM = 0;
    }];
    [self.navigatorView jm_layout:^(UIView * _Nonnull make) {
        make.topJM = 0;
        make.leftJM = 0;
    }];
    
    [self.tableView reloadData];
}

#pragma mark - setup UI response

- (void)setupUIResponse {
    [self.navigatorView.backButton addTarget:self
                                      action:@selector(backButtonTapped)
                            forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangeStatusBarOrientation:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
}

- (void)backButtonTapped {
    [self dismiss];
}

- (void)didChangeStatusBarOrientation:(NSNotification *)notification{
    [self setupUI];
}

#pragma mark - bind model

- (void)bindModel {
    self.tableViewModels = [NSMutableArray array];
    
    for (PHAssetCollection *collection in self.model.assetCollectionList) {
        JMAlbumTableViewCellModel *model = [[JMAlbumTableViewCellModel alloc] initWithCollection:collection];
        __weak typeof(self) weakSelf = self;
        model.action = ^(NSIndexPath * _Nonnull indexPath) {
            [weakSelf showPickerViewController:indexPath.row animated:YES];
        };
        
        [self.tableViewModels addObject:model];
    }
    
    [self setupUI];
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

#pragma mark - setter

#pragma mark - getter

- (JMNavigatorView *)navigatorView {
    if (!_navigatorView) {
        _navigatorView = [[JMNavigatorView alloc] init];
        _navigatorView.backgroundColor = self.model.core.navigatorBackgroundColor;
        [_navigatorView.backButton setImage:self.model.core.navigatorBackImage forState:UIControlStateNormal];
        [_navigatorView.backButton setImageEdgeInsets:UIEdgeInsetsMake(0, 16, 0, 0)];
        _navigatorView.titleLabel.text = @"相册";
        _navigatorView.titleLabel.font = self.model.core.navigatorTitleFont;
        _navigatorView.titleLabel.textColor = self.model.core.navigatorTitleColor;
    }
    return _navigatorView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        
        _tableView.contentInset = UIEdgeInsetsMake(kFunctionBarHeight, 0, 0, 0);
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.backgroundColor = [UIColor clearColor];
        
        [_tableView registerClass:[JMAlbumTableViewCell class]
           forCellReuseIdentifier:NSStringFromClass([JMAlbumTableViewCell class])];
    }
    return _tableView;
}

@end
