//
//  JMTableViewCell.m
//  JMUIKit
//
//  Created by zhengxianda on 2019/4/2.
//  Copyright © 2019 Jiamian. All rights reserved.
//

#import "JMTableViewCell.h"

#import "UIView+JMLayout.h"

#pragma mark - JMTableViewCell

@interface JMTableViewCell ()

@property (nonatomic, strong) JMTableViewCellModel *model;

@end

#pragma mark - JMTableViewCellModel

@interface JMTableViewCellModel ()

@property (nonatomic, weak) JMTableViewCell *tableViewCell;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

#pragma mark - JMTableViewCell

@implementation JMTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setupUI];
        [self setupUIResponse];
    }
    return self;
}

- (void)configWithModel:(JMTableViewCellModel *)model {
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

#pragma mark - JMTableViewCellModel

@implementation JMTableViewCellModel

- (JMTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self.cls)
                                                            forIndexPath:indexPath];
    [cell configWithModel:self];
    
    self.tableViewCell = cell;
    self.tableView = tableView;
    self.indexPath = indexPath;
    
    return cell;
}

#pragma mark - getter

- (CGSize)cellSize {
    return self.tableViewCell.sizeJM;
}

- (JMTableViewCellEvent)action {
    if (!_action) {
        _action = ^(NSIndexPath * indexPath) { };
    }
    return _action;
}

- (JMTableViewCellEvent)reload {
    if (!_reload) {
        _reload = ^(NSIndexPath * indexPath) { };
    }
    return _reload;
}

- (JMTableViewCellEvent)update {
    if (!_update) {
        _update = ^(NSIndexPath * indexPath) { };
    }
    return _update;
}

@end
