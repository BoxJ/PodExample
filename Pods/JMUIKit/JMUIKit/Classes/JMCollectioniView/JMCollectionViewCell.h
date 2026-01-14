//
//  JMCollectionViewCell.h
//  JMUIKit
//
//  Created by ZhengXianda on 2022/6/15.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

typedef void(^JMCollectionViewCellEvent)(NSIndexPath * indexPath);

#pragma mark - JMCollectionViewCell

@interface JMCollectionViewCell : UICollectionViewCell

- (void)action;
- (void)reload;
- (void)update;

- (void)setupUI;
- (void)setupUIResponse;
- (void)bindModel;

@end

#pragma mark - JMCollectionViewCellModel

@interface JMCollectionViewCellModel : NSObject

@property (nonatomic, strong) Class cls;
@property (nonatomic, assign) CGSize cellSize;

@property (nonatomic, strong) JMCollectionViewCellEvent action;///<点击事件
@property (nonatomic, strong) JMCollectionViewCellEvent reload;///<数据刷新事件
@property (nonatomic, strong) JMCollectionViewCellEvent update;///<UI刷新事件

- (JMCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
