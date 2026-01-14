//
//  JMBusiness.h
//  JMBusiness
//
//  Created by ZhengXianda on 11/03/2022.
//  Copyright (c) 2022 ZhengXianda. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <JMBusiness/JMBusinessCallback.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMBusiness : NSObject

#pragma mark - shared

+ (JMBusiness *)shared;

@end

NS_ASSUME_NONNULL_END
