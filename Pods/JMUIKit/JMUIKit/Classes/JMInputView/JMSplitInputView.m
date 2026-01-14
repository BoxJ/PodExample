//
//  JMSplitInputView.m
//  JMUIKit
//
//  Created by Thief Toki on 2020/8/7.
//

#import "JMSplitInputView.h"

#import "UIView+JMLayout.h"

@implementation JMSplitInputView

- (instancetype)initWithMaximalLength:(NSInteger)maximalLength {
    self = [super init];
    if (self) {
        self.maximalLength = maximalLength;
        
        [self setupUI];
        [self setupUIResponse];
    }
    return self;
}

- (void)clean {
    self.shadowTextField.text = @"";
    [self configCollectionViewWithInputString:@""];
}

#pragma mark - setup UI

- (void)setupUI {
    [self addSubview:self.shadowTextField];
    [self addSubview:self.displayCollectionView];
    [self addSubview:self.editButton];
    
    [self.displayCollectionView jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = CGSizeMake(self.maximalLength*(41+6), 48);
        make.centerXJM = self.widthJM/2;
        make.centerYJM = self.heightJM/2;
    }];
    
    [self.editButton jm_layout:^(UIView * _Nonnull make) {
        make.sizeJM = self.displayCollectionView.sizeJM;
        make.centerXJM = self.displayCollectionView.centerXJM;
        make.centerYJM = self.displayCollectionView.centerYJM;
    }];
    
    [self.displayCollectionView reloadData];
}

- (void)configCollectionViewWithInputString:(NSString *)inputString {
    for (NSUInteger i = 0; i < self.maximalLength; i++) {
        UICollectionViewCell *cell = [self.displayCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        for (UIView *subview in cell.contentView.subviews) {
            [subview removeFromSuperview];
        }
        
        [self configCell:cell withInputString:inputString atIndex:i];
    }
}

- (void)configCell:(UICollectionViewCell *)cell withInputString:(NSString *)inputString atIndex:(NSUInteger)index {
    if (inputString.length > index) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(splitInputView:displayViewWith:forIndex:)]) {
            UIView *displayView = [self.delegate splitInputView:self
                                                displayViewWith:[inputString substringWithRange:NSMakeRange(index, 1)]
                                                       forIndex:index];
            [cell.contentView addSubview:displayView];
            [displayView jm_layout:^(UIView * _Nonnull make) {
                make.centerXJM = cell.contentView.widthJM/2;
                make.centerYJM = cell.contentView.heightJM/2;
            }];
        }
    } else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(splitInputView:placeholderViewForIndex:)]) {
            UIView *placeholderView = [self.delegate splitInputView:self
                                            placeholderViewForIndex:index];
            [cell.contentView addSubview:placeholderView];
            [placeholderView jm_layout:^(UIView * _Nonnull make) {
                make.centerXJM = cell.contentView.widthJM/2;
                make.centerYJM = cell.contentView.heightJM/2;
            }];
        }
    }
}

#pragma mark - setup UI response

- (void)setupUIResponse {
    [self.editButton addTarget:self
                        action:@selector(editButtonTapped)
              forControlEvents:UIControlEventTouchUpInside];
}

- (void)editButtonTapped {
    [self.shadowTextField becomeFirstResponder];
}

#pragma mark - protocol

- (BOOL)textField:(JMKeyboardPreviewLinkTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger index = range.location;
    BOOL isInput = range.length == 0;
    if (index >= self.maximalLength && isInput) return NO;
    
    [self configCollectionViewWithInputString:[textField.text stringByReplacingCharactersInRange:range withString:string]];
    return YES;
}

- (BOOL)textFieldShouldReturn:(JMKeyboardPreviewLinkTextField *)textField {
    return NO;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(41+6, 48);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.maximalLength;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])
                                              forIndexPath:indexPath];
    
    [self configCell:cell withInputString:self.shadowTextField.text atIndex:indexPath.item];
    
    return cell;
}

#pragma mark - setter

#pragma mark - getter

- (JMKeyboardPreviewLinkTextField *)shadowTextField {
    if (!_shadowTextField) {
        _shadowTextField = [[JMKeyboardPreviewLinkTextField alloc] init];
        _shadowTextField.delegate = self;
        _shadowTextField.hidden = YES;
    }
    return _shadowTextField;
}

- (UICollectionView *)displayCollectionView {
    if (!_displayCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        
        _displayCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _displayCollectionView.delegate = self;
        _displayCollectionView.dataSource = self;
        _displayCollectionView.scrollEnabled = NO;
        _displayCollectionView.backgroundColor = [UIColor clearColor];
        [_displayCollectionView registerClass:[UICollectionViewCell class]
                   forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    }
    return _displayCollectionView;
}

- (UIButton *)editButton {
    if (!_editButton) {
        _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _editButton;
}

@end
