//
//  JMRktQiniuItem.h
//  JMRktQiniu
//
//  Created by ZhengXianda on 2022/10/13.
//

#import <Foundation/Foundation.h>

#import <JMRktQiniu/JMRktQiniuType.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMRktQiniuItem : NSObject

///本地文件名
@property (nonatomic, strong) NSString *name;
///本地路径
@property (nonatomic, strong) NSString *path;
///在七牛中显示的文件名
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *mimeType;
@property (nonatomic, assign) JMRktQiniuBucketType bucketType;
@property (nonatomic, assign) JMRktQiniuSceneType sceneType;

@end

NS_ASSUME_NONNULL_END
