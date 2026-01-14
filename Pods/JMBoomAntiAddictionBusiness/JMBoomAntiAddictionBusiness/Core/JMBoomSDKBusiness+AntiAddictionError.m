//
//  JMBoomSDKBusiness+AntiAddictionError.m
//  JMBoomSDK
//
//  Created by Thief Toki on 2021/2/7.
//

#import "JMBoomSDKBusiness+AntiAddictionError.h"

@implementation JMBoomSDKBusiness (AntiAddictionError)

- (BOOL)errorIsAntiAddiction:(NSError *)error {
    return error.code >= 40000 && error.code <= 40100;
}

@end
