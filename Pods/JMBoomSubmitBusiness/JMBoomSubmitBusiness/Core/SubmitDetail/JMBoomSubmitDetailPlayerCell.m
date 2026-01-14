//
//  JMBoomSubmitDetailPlayerCell.m
//  JMBoomSubmitBusiness
//
//  Created by Thief Toki on 2021/3/11.
//

#import "JMBoomSubmitDetailPlayerCell.h"

#import <JMUIKit/JMUIKit.h>
#import <JMBoomSDKBase/JMBoomSDKBase.h>
#import <SDWebImage/SDWebImage.h>

#import "JMBoomSubmitDetailPlayerItemCell.h"

@implementation JMBoomSubmitDetailPlayerCellModel

- (instancetype)initWithIssue:(NSString *)issue
                    issueTime:(NSInteger)issueTime
                   submitTime:(NSInteger)submitTime
                    issueType:(JMBoomSubmitType)issueType
                  screenshots:(NSArray <NSString *>*)screenshots {
    self = [super init];
    if (self) {
        self.cls = [JMBoomSubmitDetailPlayerCell class];
        
        self.issue = issue;
        self.issueTime = issueTime;
        self.submitTime = submitTime;
        self.item = [[JMBoomSubmitTypeItem alloc] initWithType:issueType];
        self.screenshots = screenshots;
    }
    return self;
}

@end

@interface JMBoomSubmitDetailPlayerCell () <UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) JMBoomSubmitDetailPlayerCellModel *model;

@property (nonatomic, strong) UIView *boardView;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *issueTimeLabel;
@property (nonatomic, strong) UIView *typeBackView;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation JMBoomSubmitDetailPlayerCell

#pragma mark - setup UI

- (void)setupUI {
    [self.contentView addSubview:self.boardView];
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.issueTimeLabel];
    [self.contentView addSubview:self.typeBackView];
    [self.contentView addSubview:self.typeLabel];
    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.timeLabel];
    
    [self.titleLabel jm_layout:^(UIView * _Nonnull make) {
        make.widthJM = kScreenWidth - 88;
        [make sizeToFit];
    }];
    
    self.sizeJM = CGSizeMake(kScreenWidth, self.titleLabel.heightJM + self.collectionView.heightJM + 134);
    self.contentView.frame = CGRectMake(0, 0,
                                        self.widthJM - ((kIsSpecialScreen && kIsLandscape) ? 44*2 : 0),
                                        self.heightJM);
    
    [self.boardView jm_layout:^(UIView * _Nonnull make) {
        CGFloat margin = 15;
        make.sizeJM = CGSizeMake(self.contentView.widthJM - margin*2, self.contentView.heightJM - 13);
        make.topJM = 0;
        make.centerXJM = self.contentView.centerXJM;
        
        CGRect shadowRect = CGRectMake(0, make.heightJM, make.widthJM, 9);
        make.layer.shadowPath = [UIBezierPath bezierPathWithRect:shadowRect].CGPath;
    }];
    [self.iconImageView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(20, 20);
        make.topJM = self.boardView.topJM + 20;
        make.leftJM = self.boardView.leftJM + 15;
    }];
    [self.titleLabel jm_layout:^(UIView * _Nonnull make) {
        make.topJM = self.iconImageView.topJM + 2;
        make.leftJM = self.iconImageView.rightJM + 10;
    }];
    [self.issueTimeLabel jm_layout:^(UIView * _Nonnull make) {
        [make sizeToFit];
        make.topJM = self.titleLabel.bottomJM + 6;
        make.leftJM = self.titleLabel.leftJM;
    }];
    [self.typeBackView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(67, 24);
        make.topJM = self.issueTimeLabel.bottomJM + 8;
        make.leftJM = self.titleLabel.leftJM;
    }];
    [self.typeLabel jm_layout:^(UIView * _Nonnull make) {
        [make sizeToFit];
        make.center = self.typeBackView.center;
    }];
    [self.collectionView jm_layout:^(UIView * _Nonnull make) {
        make.topJM = self.typeBackView.bottomJM;
        make.leftJM = self.titleLabel.leftJM;
    }];
    [self.timeLabel jm_layout:^(UIView * _Nonnull make) {
        [make sizeToFit];
        make.topJM = self.collectionView.bottomJM + 20;
        make.leftJM = self.titleLabel.leftJM;
    }];
}

#pragma mark - setup UI response

- (void)setupUIResponse {
    
}

#pragma mark - bind model

- (void)bindModel {
    self.titleLabel.text = self.model.issue;
    self.typeBackView.backgroundColor = self.model.item.backgroundColor;
    self.typeLabel.text = self.model.item.title;
    self.typeLabel.textColor = self.model.item.titleColor;
    NSString *timeString = [[NSDate dateWithTimeIntervalSince1970:self.model.issueTime] stringValueWithFormat:@"yyyy/MM/dd HH:mm"];
    self.issueTimeLabel.text = [@"异常时间：" stringByAppendingString:timeString];
    self.timeLabel.text = [[NSDate dateWithTimeIntervalSince1970:self.model.submitTime] stringValueWithFormat:@"yyyy/MM/dd HH:mm"];
    
    CGFloat minimumInteritemSpacing = 10;
    CGFloat minimumLineSpacing = 8;
    CGSize itemSize = CGSizeZero;
    CGFloat collectionWidth = 0;
    CGFloat collectionHeight = 0;
    CGFloat topOffset = 12;
    CGFloat margin = 60;
    NSInteger columnCount = 3;
    NSInteger rowCount = ceil(self.model.screenshots.count / 3.0);
    if (rowCount > 0) {
        collectionWidth = kScreenWidth - (margin * 2);
        CGFloat cellWH = (collectionWidth - (minimumInteritemSpacing * (columnCount - 1))) / columnCount;
        collectionHeight = topOffset + rowCount * cellWH + (rowCount - 1) * minimumLineSpacing;
        itemSize = CGSizeMake(cellWH, cellWH);
    }
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumInteritemSpacing = minimumInteritemSpacing;
    layout.minimumLineSpacing = minimumLineSpacing;
    layout.itemSize = itemSize;
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.sizeJM = CGSizeMake(collectionWidth, collectionHeight);
    self.collectionView.contentInset = UIEdgeInsetsMake(topOffset, 0, 0, 0);
    
    [self setupUI];
}

#pragma mark - protocol

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.model.screenshots.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *imagePath = self.model.screenshots[indexPath.row];
    JMBoomSubmitDetailPlayerItemCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JMBoomSubmitDetailPlayerItemCell class])
                                              forIndexPath:indexPath];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imagePath]];
    return cell;
}

#pragma mark - setter

#pragma mark - getter

- (UIView *)boardView {
    if (!_boardView) {
        _boardView = [[UIView alloc] init];
        _boardView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        _boardView.layer.cornerRadius = [[[JMBoomSDKResource shared] resourceWithName:JMBRNCorner] floatValue];
        _boardView.layer.masksToBounds = YES;
        _boardView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.04].CGColor;
        _boardView.layer.shadowOpacity = 1;
        _boardView.layer.shadowRadius = 13;
    }
    return _boardView;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [JMBoomSDKResource imageNamed:@"sug_ic_question"];
    }
    return _iconImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithRed:51/255.0
                                                green:51/255.0
                                                 blue:51/255.0
                                                alpha:1.0];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)issueTimeLabel {
    if (!_issueTimeLabel) {
        _issueTimeLabel = [[UILabel alloc] init];
        _issueTimeLabel.textColor = [UIColor colorWithRed:102/255.0
                                                    green:102/255.0
                                                     blue:102/255.0
                                                    alpha:1.0];
        _issueTimeLabel.font = [UIFont systemFontOfSize:12];
    }
    return _issueTimeLabel;
}

- (UIView *)typeBackView {
    if (!_typeBackView) {
        _typeBackView = [[UIView alloc] init];
        _typeBackView.layer.cornerRadius = [[[JMBoomSDKResource shared] resourceWithName:JMBRNCorner] floatValue];
        _typeBackView.layer.masksToBounds = YES;
    }
    return _typeBackView;
}

- (UILabel *)typeLabel {
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.font = [UIFont systemFontOfSize:12];
    }
    return _typeLabel;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                             collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        
        [_collectionView registerClass:[JMBoomSubmitDetailPlayerItemCell class] forCellWithReuseIdentifier:NSStringFromClass([JMBoomSubmitDetailPlayerItemCell class])];
    }
    return _collectionView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor colorWithRed:153/255.0
                                               green:153/255.0
                                                blue:153/255.0
                                               alpha:1.0];
        _timeLabel.font = [UIFont systemFontOfSize:12];
    }
    return _timeLabel;
}

@end
