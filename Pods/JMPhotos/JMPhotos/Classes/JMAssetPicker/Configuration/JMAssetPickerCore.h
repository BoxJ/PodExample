//
//  JMAssetPickerCore.h
//  JMAssetPicker
//
//  Created by ZhengXianda on 2022/6/7.
//

#import <Foundation/Foundation.h>

#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMAssetPickerCore : NSObject

#pragma mark - Album

/// 相册Cell高度
@property (nonatomic, assign) CGFloat albumHeight;

/// 仅展示最近添加相册
@property (nonatomic, assign) BOOL isRecentsOnly;

/// 对照片排序，按创建时间升序。
/// 默认设置为YES，最新的照片会显示在最后面，内部的拍照按钮会排在末尾。
/// 如果设置为NO，最新的照片会显示在最前面，内部的拍照按钮会排在第一个。
@property (nonatomic, assign) BOOL sortAscendingByCreationDate;

#pragma mark - Asset

@property (nonatomic, assign) BOOL allowCamera;///< 允许使用相机
@property (nonatomic, assign) BOOL allowCameraPhoto;///< 允许使用相机拍照
@property (nonatomic, assign) BOOL allowCameraVideo;///< 允许使用相机录像
@property (nonatomic, assign) BOOL allowDownloadFromICloud;///< 允许从iCloud下载
@property (nonatomic, assign) BOOL allowPickingImage;///< 允许选择图片
@property (nonatomic, assign) BOOL allowPickingVideo;///< 允许选择视频
@property (nonatomic, assign) BOOL allowPickingOriginal;///< 允许选择原图
@property (nonatomic, assign) BOOL allowPickingMultipleType;///< 允许选择多种类型的资源

@property (nonatomic, assign) CGSize sizeLimitMin;///< 图片标准尺寸下限
@property (nonatomic, assign) BOOL isSizeLimitValid;///< 图片标准尺寸是否生效，默认：NO；YES：不符合标准的图片不显示；NO：不符合标准的图片显示；

@property (nonatomic, assign) UIEdgeInsets pickerInsets;///< 网格展示时的嵌入值（四边边距）
@property (nonatomic, assign) NSInteger columnNumber;///< 网格展示时的列数目
@property (nonatomic, assign) NSInteger columnSpace;///< 网格展示时的列数目
@property (nonatomic, assign, readonly) CGSize assetSize;///< 网格展示时缩略图高度，通过列数目和间隔计算

@property (nonatomic, strong, readonly) PHFetchOptions *assetOptions;///< asset筛选标准的实例

#pragma mark - utils

#pragma mark 导航栏

@property (nonatomic, strong) UIColor *navigatorBackgroundColor;///< 导航栏背景色
@property (nonatomic, strong) UIColor *navigatorBackgroundColorTranslucent;///< 导航栏半透明状态下的背景色
@property (nonatomic, strong) UIImage *navigatorBackImage;///< 导航栏返回按钮
@property (nonatomic, strong) UIFont *navigatorTitleFont;///< 导航栏中标题文字字体
@property (nonatomic, strong) UIColor *navigatorTitleColor;///< 导航栏中标题文字颜色
@property (nonatomic, strong) UIImage *navigatorSelectedCountIdleImage;///< 导航栏中图像选中数量闲置图标
@property (nonatomic, strong) UIImage *navigatorSelectedCountActiveImage;///< 导航栏中图像选中数量激活图标

#pragma mark 工具栏

@property (nonatomic, strong) UIColor *toolBackgroundColor;///< 工具栏背景色
@property (nonatomic, strong) UIColor *toolBackgroundColorTranslucent;///< 工具栏半透明状态下的背景色
@property (nonatomic, strong) UIFont *toolPreviewContentFont;///< 工具栏中图像预览按钮文字字体
@property (nonatomic, strong) UIColor *toolPreviewContentColor;///< 工具栏中图像预览按钮文字颜色
@property (nonatomic, strong) UIImage *toolOriginalSelectedImage;///< 工具栏中图像使用原图图标
@property (nonatomic, strong) UIImage *toolOriginalUnselectedImage;///< 工具栏中图像不使用原图图标
@property (nonatomic, strong) UIFont *toolOriginalContentFont;///< 工具栏中图像原图按钮文字字体
@property (nonatomic, strong) UIColor *toolOriginalContentColor;///< 工具栏中图像原图按钮文字颜色
@property (nonatomic, strong) UIFont *toolFinishContentFont;///< 工具栏中图像完成按钮文字字体
@property (nonatomic, strong) UIColor *toolFinishContentColor;///< 工具栏中图像完成按钮文字颜色
@property (nonatomic, strong) UIImage *toolSelectedCountIdleImage;///< 工具栏中图像选中数量闲置图标
@property (nonatomic, strong) UIImage *toolSelectedCountActiveImage;///< 工具栏中图像选中数激活图标

#pragma mark - picker

@property (nonatomic, assign) NSInteger selectedCountLimit; ///< 选中素材上限
@property (nonatomic, assign) NSInteger selectedImageCountLimit; ///< 选中图片上限
@property (nonatomic, assign) NSInteger selectedVideoCountLimit; ///< 选中视频上限
@property (nonatomic, assign) BOOL selectingCeiling; ///< 选中素材已达到上限
@property (nonatomic, assign) BOOL selectingImageCeiling; ///< 选中图片已达到上限
@property (nonatomic, assign) BOOL selectingVideoCeiling; ///< 选中视频已达到上限

@property (nonatomic, strong) UIImage *cameraImage;///< 相册中相机按钮图像素材
@property (nonatomic, strong) UIImage *pickerSelectedImage;///< 相册中图像素材选中素材
@property (nonatomic, strong) UIImage *pickerUnselectedImage;///< 相册中图像素材未选中素材
@property (nonatomic, strong) UIImage *pickerVideoImage;///< 相册中视频标记图标

#pragma mark - preview

@property (nonatomic, strong) UIImage *videoPlayImage;///< 预览中视频播放按钮

@end

NS_ASSUME_NONNULL_END
