//
//  JMAssetCollectorFlowLayout.m
//  JMAssetCollector
//

#import "JMAssetCollectorFlowLayout.h"
#import "JMAssetCollectorItemCell.h"

#import <JMUtils/JMUtils.h>

@interface JMAssetCollectorFlowLayout () <UIGestureRecognizerDelegate>

@property (nonatomic,readonly) id<JMAssetCollectorDataSource> dataSource;
@property (nonatomic,readonly) id<JMAssetCollectorDelegateFlowLayout> delegate;

@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;

@property (nonatomic, strong) UIView *beingMovedPromptView;
@property (nonatomic, strong) NSIndexPath *movingItemIndexPath;
@property (nonatomic, assign) CGPoint sourceItemCollectionViewCellCenter;

@end

@implementation JMAssetCollectorFlowLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addObserver:self
               forKeyPath:@__STRING(collectionView)
                  options:NSKeyValueObservingOptionNew
                  context:nil];
    }
    return self;
}

- (void)dealloc {
    [self removeObserver:self
              forKeyPath:@__STRING(collectionView)];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@__STRING(collectionView)]) {
        if (self.collectionView) {
            self.collectionView.userInteractionEnabled = YES;
            
            [self addGestureRecognizers];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(applicationWillResignActive:)
                                                         name:UIApplicationWillResignActiveNotification
                                                       object:nil];
        } else {
            [self removeGestureRecognizers];
            
            [[NSNotificationCenter defaultCenter] removeObserver:self
                                                            name:UIApplicationWillResignActiveNotification
                                                          object:nil];
        }
    }
}

- (void)addGestureRecognizers {
    if (!self.longPressGestureRecognizer) {
        self.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGestureRecognizerTriggerd:)];
    }
    self.longPressGestureRecognizer.delegate = self;
    self.longPressGestureRecognizer.cancelsTouchesInView = NO;
    self.longPressGestureRecognizer.minimumPressDuration = 0.1;
    [self.collectionView addGestureRecognizer:self.longPressGestureRecognizer];
    
    if (!self.panGestureRecognizer) {
        self.panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureRecognizerTriggerd:)];
    }
    self.panGestureRecognizer.delegate = self;
    [self.collectionView addGestureRecognizer:self.panGestureRecognizer];
}

- (void)removeGestureRecognizers {
    if (self.longPressGestureRecognizer) {
        if (self.longPressGestureRecognizer.view) {
            [self.longPressGestureRecognizer.view removeGestureRecognizer:self.longPressGestureRecognizer];
        }
        self.longPressGestureRecognizer = nil;
    }
    
    if (self.panGestureRecognizer) {
        if (self.panGestureRecognizer.view) {
            [self.panGestureRecognizer.view removeGestureRecognizer:self.panGestureRecognizer];
        }
        self.panGestureRecognizer = nil;
    }
}

- (void)applicationWillResignActive:(NSNotification *)notificaiton {
    self.panGestureRecognizer.enabled = NO;
    self.panGestureRecognizer.enabled = YES;
}

#pragma mark - override

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *layoutAttributesForElementsInRect = [super layoutAttributesForElementsInRect:rect];
    
    for (UICollectionViewLayoutAttributes *layoutAttributes in layoutAttributesForElementsInRect) {
        [self checkMovingLayoutAttributes:layoutAttributes];
    }
    return layoutAttributesForElementsInRect;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *layoutAttributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    
    [self checkMovingLayoutAttributes:layoutAttributes];
    return layoutAttributes;
}

- (void)checkMovingLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    if (layoutAttributes.representedElementCategory == UICollectionElementCategoryCell) {
        // 隐藏移动中的Cell
        layoutAttributes.hidden = [layoutAttributes.indexPath isEqual:self.movingItemIndexPath];
    }
}

#pragma mark - gesture

- (void)longPressGestureRecognizerTriggerd:(UILongPressGestureRecognizer *)longPress {
    switch (longPress.state) {
        case UIGestureRecognizerStatePossible:
            break;
        case UIGestureRecognizerStateBegan: {
            self.movingItemIndexPath = [self.collectionView indexPathForItemAtPoint:[longPress locationInView:self.collectionView]];
            
            // 判断是否可以移动
            if ([self.dataSource respondsToSelector:@selector(collectionView:canMoveItemAtIndexPath:)]) {
                if (![self.dataSource collectionView:self.collectionView canMoveItemAtIndexPath:self.movingItemIndexPath]) {
                    self.movingItemIndexPath = nil;
                    return;
                }
            }
            
            // 通知代理“拖动即将开始”
            if ([self.delegate respondsToSelector:@selector(collectionView:layout:willBeginDraggingItemAtIndexPath:)]) {
                [self.delegate collectionView:self.collectionView layout:self willBeginDraggingItemAtIndexPath:self.movingItemIndexPath];
            }
            
            // 获取目标Cell
            JMAssetCollectorItemCell *sourceCell = (JMAssetCollectorItemCell *)[self.collectionView cellForItemAtIndexPath:self.movingItemIndexPath];
            self.sourceItemCollectionViewCellCenter = sourceCell.center;
            
            // 获取Cell拖动状态的容器
            CGFloat bulk = 5;
            self.beingMovedPromptView = [[UIView alloc] initWithFrame:CGRectOffset(sourceCell.frame, -bulk, -bulk)];
            self.beingMovedPromptView.widthJM += 2*bulk;
            self.beingMovedPromptView.heightJM += 2*bulk;
            [self.collectionView addSubview:self.beingMovedPromptView];
            
            // 获取目标Cell快照
            UIView *snapshotView = [sourceCell snapshotView];
            [self.beingMovedPromptView addSubview:snapshotView];
            
            // 渲染目标Cell变大的效果
            snapshotView.frame = self.beingMovedPromptView.bounds;
            [self invalidateLayout];
            
            // 通知代理“拖动开始”
            if ([self.delegate respondsToSelector:@selector(collectionView:layout:didBeginDraggingItemAtIndexPath:)]) {
                [self.delegate collectionView:self.collectionView layout:self didBeginDraggingItemAtIndexPath:self.movingItemIndexPath];
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            NSIndexPath *movingItemIndexPath = self.movingItemIndexPath;
            
            if (!self.movingItemIndexPath) break;
            
            // 通知代理“拖动即将结束”
            if ([self.delegate respondsToSelector:@selector(collectionView:layout:willEndDraggingItemAtIndexPath:)]) {
                [self.delegate collectionView:self.collectionView layout:self willEndDraggingItemAtIndexPath:movingItemIndexPath];
            }
            
            // 重置标识属性
            self.movingItemIndexPath = nil;
            self.sourceItemCollectionViewCellCenter = CGPointZero;
            
            // 渲染目标位置的Cell
            self.longPressGestureRecognizer.enabled = NO;
            typeof(self) __weak weakSelf = self;
            [UIView animateWithDuration:0.1
                                  delay:0
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:^{
                weakSelf.beingMovedPromptView.center = [weakSelf layoutAttributesForItemAtIndexPath:movingItemIndexPath].center;
            }
                             completion:^(BOOL finished) {
                weakSelf.longPressGestureRecognizer.enabled = YES;
                
                // 移除Cell拖动状态的容器
                [weakSelf.beingMovedPromptView removeFromSuperview];
                weakSelf.beingMovedPromptView = nil;
                [weakSelf invalidateLayout];
                
                // 通知代理“拖动结束”
                if ([weakSelf.delegate respondsToSelector:@selector(collectionView:layout:didEndDraggingItemAtIndexPath:)]) {
                    [weakSelf.delegate collectionView:weakSelf.collectionView layout:weakSelf didEndDraggingItemAtIndexPath:weakSelf.movingItemIndexPath];
                }
            }];
        }
            break;
        case UIGestureRecognizerStateFailed:
            break;
        default:
            break;
    }
}

- (void)panGestureRecognizerTriggerd:(UIPanGestureRecognizer *)pan {
    switch (pan.state) {
        case UIGestureRecognizerStatePossible:
            break;
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged: {
            CGPoint panTranslation = [pan translationInView:self.collectionView];
            self.beingMovedPromptView.center =
            CGPointMake(self.sourceItemCollectionViewCellCenter.x + panTranslation.x,
                        self.sourceItemCollectionViewCellCenter.y + panTranslation.y);
            
            // 判断拖动目标是否可用
            NSIndexPath *sourceIndexPath = self.movingItemIndexPath;
            NSIndexPath *destinationIndexPath = [self.collectionView indexPathForItemAtPoint:self.beingMovedPromptView.center];
            if ((destinationIndexPath == nil) || [sourceIndexPath isEqual:destinationIndexPath]) {
                return;
            }
            if ([self.dataSource respondsToSelector:@selector(collectionView:itemAtIndexPath:canMoveToIndexPath:)] && [self.dataSource collectionView:self.collectionView itemAtIndexPath:sourceIndexPath canMoveToIndexPath:destinationIndexPath] == NO) {
                return;
            }
            // 通知代理“即将移动到目标位置”
            if ([self.dataSource respondsToSelector:@selector(collectionView:itemAtIndexPath:willMoveToIndexPath:)]) {
                [self.dataSource collectionView:self.collectionView itemAtIndexPath:sourceIndexPath willMoveToIndexPath:destinationIndexPath];
            }
            
            // 更新目标位置
            self.movingItemIndexPath = destinationIndexPath;
            
            // 更新UI
            typeof(self) __weak weakSelf = self;
            [self.collectionView performBatchUpdates:^{
                if (sourceIndexPath && destinationIndexPath) {
                    [weakSelf.collectionView deleteItemsAtIndexPaths:@[sourceIndexPath]];
                    [weakSelf.collectionView insertItemsAtIndexPaths:@[destinationIndexPath]];
                }
            } completion:^(BOOL finished) {
                // 通知代理“已经移动到目标位置”
                if ([weakSelf.dataSource respondsToSelector:@selector(collectionView:itemAtIndexPath:didMoveToIndexPath:)]) {
                    [weakSelf.dataSource collectionView:weakSelf.collectionView itemAtIndexPath:sourceIndexPath didMoveToIndexPath:destinationIndexPath];
                }
            }];
        }
            break;
        case UIGestureRecognizerStateEnded:
            break;
        case UIGestureRecognizerStateCancelled:
            break;
        case UIGestureRecognizerStateFailed:
            break;
        default:
            break;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isEqual:self.panGestureRecognizer]) {
        return self.movingItemIndexPath != nil;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer isEqual:self.longPressGestureRecognizer]) {
        return [otherGestureRecognizer isEqual:self.panGestureRecognizer];
    }
    if ([gestureRecognizer isEqual:self.panGestureRecognizer]) {
        return [otherGestureRecognizer isEqual:self.longPressGestureRecognizer];
    }
    return NO;
}

#pragma mark - getter

- (id<JMAssetCollectorDataSource>)dataSource {
    return (id<JMAssetCollectorDataSource>)self.collectionView.dataSource;
}

- (id<JMAssetCollectorDelegateFlowLayout>)delegate {
    return (id<JMAssetCollectorDelegateFlowLayout>)self.collectionView.delegate;
}

@end
