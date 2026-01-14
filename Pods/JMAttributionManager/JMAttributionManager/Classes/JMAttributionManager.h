//
//  JMAttributionManager.h
//  JMAttributionManager
//
//  Created by ZhengXianda on 08/25/2021.
//  Copyright (c) 2021 ZhengXianda. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMAttributionManager : NSObject

@property (nonatomic, strong) NSString *attributionToken;
@property (nonatomic, strong) NSString *attributionDetails;

#pragma mark - shared

+ (instancetype)shared;

- (void)requestAttributionInfoWithBlock:(void (^)(NSString *info, NSError *error))completionHandler;

@end

NS_ASSUME_NONNULL_END
