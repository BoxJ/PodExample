//
//  JMAssetCollectorCore.m
//  JMImagePickerController_Example
//
//  Created by ZhengXianda on 2022/9/28.
//  Copyright © 2022 ZhengXianda. All rights reserved.
//

#import "JMAssetCollectorCore.h"

#import <JMUIKit/JMUIKit.h>

@implementation JMAssetCollectorCore

- (instancetype)init {
    self = [super init];
    if (self) {
        self.displayInsets = UIEdgeInsetsZero;
        self.displayColumnNumber = 3;
        self.displayColumnSpace = 0;
        self.displayWidth = kScreenWidth;
        self.assetInsets = UIEdgeInsetsZero;
    }
    return self;
}

- (CGFloat)displayHeight {
    NSInteger rowCount = ceilf((float)self.selectedCountLimit / (float)self.displayColumnNumber);
    return rowCount * self.assetSize.height + (rowCount - 1) + self.displayColumnSpace + self.displayInsets.top + self.displayInsets.bottom;
}

- (CGSize)assetSize {
    CGFloat assetHeight = (((self.displayWidth - self.displayInsets.left - self.displayInsets.right) + self.displayColumnSpace) / self.displayColumnNumber) - self.displayColumnSpace;
    return CGSizeMake(assetHeight, assetHeight);
}

@end
