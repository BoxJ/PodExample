//
//  JMAlbumTableViewCell.h
//  JMAssetPicker
//
//  Created by ZhengXianda on 2022/6/7.
//

#import <JMUIKit/JMUIKit.h>

#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMAlbumTableViewCellModel : JMTableViewCellModel

@property (nonatomic, strong) PHAssetCollection *collection;

- (instancetype)initWithCollection:(PHAssetCollection *)collection;

@end

@interface JMAlbumTableViewCell : JMTableViewCell

@end

NS_ASSUME_NONNULL_END
