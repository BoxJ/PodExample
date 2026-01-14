//
//  JMDataProviderMethod.m
//  JMNetworking
//
//  Created by zhengxianda on 2018/12/17.
//  Copyright © 2018 Toki. All rights reserved.
//

#import "JMRequestMethod.h"

@implementation JMRequestMethod

+ (NSString *)stringWithRequestMethod:(JMRequestMethodType)method {
    NSString *methodString = @"Unknow Method";
    switch (method) {
        case JMRequestMethodType_GET: {
            methodString = @"GET";
            break;
        }
        case JMRequestMethodType_POST: {
            methodString = @"POST";
            break;
        }
        case JMRequestMethodType_POST_JSON: {
            methodString = @"POST";
            break;
        }
        case JMRequestMethodType_HEAD: {
            methodString = @"HEAD";
            break;
        }
        case JMRequestMethodType_PUT: {
            methodString = @"PUT";
            break;
        }
        case JMRequestMethodType_PATCH: {
            methodString = @"PATCH";
            break;
        }
        case JMRequestMethodType_DELETE: {
            methodString = @"DELETE";
            break;
        }
    }
    return methodString;
}

+ (BOOL)isEncodingParametersInURIWithRequestMethod:(JMRequestMethodType)method {
    BOOL isEncodingParametersInURI = YES;
    switch (method) {
        case JMRequestMethodType_POST_JSON: {
            isEncodingParametersInURI = NO;
            break;
        }
        default: {
            isEncodingParametersInURI = YES;
            break;
        }
    }
    return isEncodingParametersInURI;
}

@end
