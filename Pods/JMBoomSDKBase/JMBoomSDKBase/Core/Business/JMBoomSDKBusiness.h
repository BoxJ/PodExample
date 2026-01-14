//
//  JMBoomSDKBusiness.h
//  JMBoomSDK
//
//  Created by ZhengXianda on 10/31/2022.
//  Copyright (c) 2022 ZhengXianda. All rights reserved.
//

#import <JMBusiness/JMBusiness.h>

#import <JMBoomSDKBase/JMBoomSDKConfig.h>
#import <JMBoomSDKBase/JMBoomSDKInfo.h>
#import <JMBoomSDKBase/JMBoomSDKInfo+Agreement.h>
#import <JMBoomSDKBase/JMBoomSDKRequest.h>
#import <JMBoomSDKBase/JMBoomSDKWeb.h>
#import <JMBoomSDKBase/JMBoomSDKQiniu.h>
#import <JMBoomSDKBase/JMBoomSDKEvent.h>
#import <JMBoomSDKBase/JMBoomSDKReport.h>

#import <JMQiYuCustomer/JMQiYuCustomer.h>
#import <JMBoomSDKBase/JMBoomSDKRisk.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomSDKBusiness : JMBusiness

#pragma mark - shared

+ (JMBoomSDKBusiness *)shared;

+ (JMBoomSDKConfig *)config;
+ (JMBoomSDKInfo *)info;
+ (JMBoomSDKRequest *)request;
+ (JMBoomSDKWeb *)web;
+ (JMBoomSDKQiniu *)qiniu;
+ (JMBoomSDKEvent *)event;

+ (JMQiYuCustomer *)qiYuCustomer;   //客服
+ (JMBoomSDKRisk *)risk;            //反外挂

@end

NS_ASSUME_NONNULL_END
