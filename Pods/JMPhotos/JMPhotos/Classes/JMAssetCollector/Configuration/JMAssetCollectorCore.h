//
//  JMAssetCollectorCore.h
//  JMImagePickerController_Example
//
//  Created by ZhengXianda on 2022/9/28.
//  Copyright © 2022 ZhengXianda. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMAssetCollectorCore : NSObject

@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, strong) UIImage *addImage;
@property (nonatomic, strong) UIImage *deleteImage;
@property (nonatomic, strong) UIImage *videoPlayImage;

@property (nonatomic, assign) UIEdgeInsets displayInsets;///< 网格展示时的嵌入值（四边边距）
@property (nonatomic, assign) NSInteger displayColumnNumber;///< 网格展示时的列数目
@property (nonatomic, assign) NSInteger displayColumnSpace;///< 网格展示时的列数目
@property (nonatomic, assign) CGFloat displayWidth;/// <网格展示页面宽度
@property (nonatomic, assign, readonly) CGFloat displayHeight;/// <网格展示页面高度

@property (nonatomic, assign, readonly) CGSize assetSize;///< 网格展示时缩略图高度，通过列数目和间隔计算
@property (nonatomic, assign) UIEdgeInsets assetInsets;///< 网格展示时的元素的边距
@property (nonatomic, assign) UIImage *assetPlaceholder;///< 网格展示时的占位图

@property (nonatomic, assign) NSInteger selectedCountLimit; ///< 选中素材上限
@property (nonatomic, assign) BOOL selectingCeiling; ///< 选中素材已达到上限

@end

NS_ASSUME_NONNULL_END
