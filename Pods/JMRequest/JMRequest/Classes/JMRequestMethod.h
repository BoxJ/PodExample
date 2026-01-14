//
//  JMDataProviderMethod.h
//  JMNetworking
//
//  Created by zhengxianda on 2018/12/17.
//  Copyright © 2018 Toki. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, JMRequestMethodType) {
    JMRequestMethodType_GET,
    JMRequestMethodType_POST,
    JMRequestMethodType_POST_JSON,
    JMRequestMethodType_HEAD,
    JMRequestMethodType_PUT,
    JMRequestMethodType_PATCH,
    JMRequestMethodType_DELETE,
};

NS_ASSUME_NONNULL_BEGIN

@interface JMRequestMethod : NSObject

+ (NSString *)stringWithRequestMethod:(JMRequestMethodType)method;
+ (BOOL)isEncodingParametersInURIWithRequestMethod:(JMRequestMethodType)method;

@end

NS_ASSUME_NONNULL_END
