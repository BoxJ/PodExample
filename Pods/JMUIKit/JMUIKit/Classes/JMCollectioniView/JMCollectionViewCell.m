//
//  JMCollectionViewCell.m
//  JMUIKit
//
//  Created by ZhengXianda on 2022/6/15.
//

#import "JMCollectionViewCell.h"

#import "UIView+JMLayout.h"

#pragma mark - JMCollectionViewCell

@interface JMCollectionViewCell ()

@property (nonatomic, strong) JMCollectionViewCellModel *model;

@end

#pragma mark - JMCollectionViewCellModel

@interface JMCollectionViewCellModel ()

@property (nonatomic, weak) JMCollectionViewCell *collectionViewCell;
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

#pragma mark - JMCollectionViewCell

@implementation JMCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self setupUI];
        [self setupUIResponse];
    }
    return self;
}

- (void)configWithModel:(JMCollectionViewCellModel *)model {
    BOOL checkModelType = [model.cls isEqual:self.class];
    NSString *checkModelTips = [NSString stringWithFormat:@"%@ Model 格式错误", NSStringFromClass(self.class)];
    NSAssert(checkModelType, checkModelTips);
    
    self.model = model;
    [self bindModel];
}

#pragma mark - action

- (void)action {
    if (self.model.action) {
        self.model.action(self.model.indexPath);
    }
}

- (void)reload {
    if (self.model.reload) {
        self.model.reload(self.model.indexPath);
    }
}

- (void)update {
    if (self.model.update) {
        self.model.update(self.model.indexPath);
    }
}

#pragma mark - setup UI

- (void)setupUI {
    
}

#pragma mark - setup UI response

- (void)setupUIResponse {
    
}

#pragma mark - bind model

- (void)bindModel {
    
}

@end

#pragma mark - JMCollectionViewCellModel

@implementation JMCollectionViewCellModel

- (JMCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JMCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(self.cls)
                                                                           forIndexPath:indexPath];
    [cell configWithModel:self];
    
    self.collectionViewCell = cell;
    self.collectionView = collectionView;
    self.indexPath = indexPath;
    
    return cell;
}

#pragma mark - getter

- (CGSize)cellSize {
    return self.collectionViewCell.sizeJM;
}

- (JMCollectionViewCellEvent)action {
    if (!_action) {
        _action = ^(NSIndexPath * indexPath) { };
    }
    return _action;
}

- (JMCollectionViewCellEvent)reload {
    if (!_reload) {
        _reload = ^(NSIndexPath * indexPath) { };
    }
    return _reload;
}

- (JMCollectionViewCellEvent)update {
    if (!_update) {
        _update = ^(NSIndexPath * indexPath) { };
    }
    return _update;
}

@end

