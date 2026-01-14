//
//  JMAssetPickerCore.m
//  JMAssetPicker
//
//  Created by ZhengXianda on 2022/6/7.
//

#import "JMAssetPickerCore.h"

#import <JMUIKit/JMUIKit.h>

@implementation JMAssetPickerCore

#pragma mark - album

- (CGFloat)albumHeight {
    NSInteger albumHeight = _albumHeight > 0 ? _albumHeight : 70;
    return albumHeight;
}

#pragma mark - asset

- (UIEdgeInsets)pickerInsets {
    UIEdgeInsets pickerInsets =
    _pickerInsets.top > 0
    || _pickerInsets.bottom > 0
    || _pickerInsets.left > 0
    || _pickerInsets.right > 0
    ? _pickerInsets : UIEdgeInsetsMake(10, 10, 10, 10);
    
    return pickerInsets;
}

- (NSInteger)columnNumber {
    NSInteger columnNumber = _columnNumber > 0 ? _columnNumber : 3;
    return columnNumber;
}

- (NSInteger)columnSpace {
    NSInteger columnSpace = _columnSpace > 0 ? _columnSpace : 10;
    return columnSpace;
}

- (CGSize)assetSize {
    CGFloat assetHeight = (((kScreenWidth - self.pickerInsets.left - self.pickerInsets.right) + self.columnSpace) / self.columnNumber) - self.columnSpace;
    return CGSizeMake(assetHeight, assetHeight);
}

- (PHFetchOptions*)assetOptions {
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    
    NSMutableArray *mediaTypeList = [NSMutableArray array];
    if (self.allowPickingImage) [mediaTypeList addObject:@(PHAssetMediaTypeImage)];
    if (self.allowPickingVideo) [mediaTypeList addObject:@(PHAssetMediaTypeVideo)];
    
    NSMutableString *predicate = [NSMutableString string];
    for (NSNumber *mediaType in mediaTypeList) {
        if (predicate.length > 0) {
            [predicate appendFormat:@" OR "];
        }
        [predicate appendFormat:@"mediaType == %@", mediaType];
    }
    option.predicate = [NSPredicate predicateWithFormat:predicate];
    
    option.sortDescriptors = @[
        [NSSortDescriptor sortDescriptorWithKey:@"creationDate"
                                      ascending:self.sortAscendingByCreationDate]
    ];
    
    return option;
}

#pragma mark - picker

- (NSInteger)selectedCountLimit {
    NSInteger selectedCountLimit = _selectedCountLimit > 0 ? _selectedCountLimit : 9;
    return selectedCountLimit;
}

- (NSInteger)selectedImageCountLimit {
    NSInteger selectedImageCountLimit = _selectedImageCountLimit > 0 ? _selectedImageCountLimit : self.selectedCountLimit;
    return selectedImageCountLimit;
}

- (NSInteger)selectedVideoCountLimit {
    NSInteger selectedVideoCountLimit = _selectedVideoCountLimit > 0 ? _selectedVideoCountLimit : self.selectedCountLimit;
    return selectedVideoCountLimit;
}


@end
