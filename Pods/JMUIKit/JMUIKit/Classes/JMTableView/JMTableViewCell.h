//
//  JMTableViewCell.h
//  JMUIKit
//
//  Created by zhengxianda on 2019/4/2.
//  Copyright © 2019 Jiamian. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

typedef void(^JMTableViewCellEvent)(NSIndexPath * indexPath);

#pragma mark - JMTableViewCell

@interface JMTableViewCell : UITableViewCell

- (void)action;
- (void)reload;
- (void)update;

- (void)setupUI;
- (void)setupUIResponse;
- (void)bindModel;

@end

#pragma mark - JMTableViewCellModel

@interface JMTableViewCellModel : NSObject

@property (nonatomic, strong) Class cls;
@property (nonatomic, assign) CGSize cellSize;

@property (nonatomic, strong) JMTableViewCellEvent action;///<点击事件
@property (nonatomic, strong) JMTableViewCellEvent reload;///<数据刷新事件
@property (nonatomic, strong) JMTableViewCellEvent update;///<UI刷新事件

- (JMTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
