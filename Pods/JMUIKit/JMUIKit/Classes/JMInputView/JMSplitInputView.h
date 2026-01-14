//
//  JMSplitInputView.h
//  JMUIKit
//
//  Created by Thief Toki on 2020/8/7.
//

#import <UIKit/UIKit.h>

#import <JMUIKit/JMKeyboardPreviewLinkTextField.h>

@class JMSplitInputView;

NS_ASSUME_NONNULL_BEGIN

@protocol JMSplitInputViewDelegate <NSObject>

- (UIView *)splitInputView:(JMSplitInputView *)splitInputView displayViewWith:(NSString *)string forIndex:(NSUInteger)index;
- (UIView *)splitInputView:(JMSplitInputView *)splitInputView placeholderViewForIndex:(NSUInteger)index;

@end

@interface JMSplitInputView : UIView <
UITextFieldDelegate,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource
>

@property (nonatomic, weak) id<JMSplitInputViewDelegate> delegate;

@property (nonatomic, assign) NSInteger maximalLength;

@property (nonatomic, strong) JMKeyboardPreviewLinkTextField *shadowTextField;
@property (nonatomic, strong) UICollectionView *displayCollectionView;
@property (nonatomic, strong) UIButton *editButton;

- (instancetype)initWithMaximalLength:(NSInteger)maximalLength;
- (void)clean;

@end

NS_ASSUME_NONNULL_END
