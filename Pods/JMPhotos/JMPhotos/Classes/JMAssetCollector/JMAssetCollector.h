//
//  JMAssetCollector.h
//  JMAssetCollector
//
//  Created by ZhengXianda on 09/30/2022.
//  Copyright (c) 2022 ZhengXianda. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class JMAssetCollectorModel;
@interface JMAssetCollector : UIView

- (instancetype)initWithModel:(JMAssetCollectorModel *)model;
- (void)configModel:(JMAssetCollectorModel *)model;

- (void)reload;

@end

NS_ASSUME_NONNULL_END
