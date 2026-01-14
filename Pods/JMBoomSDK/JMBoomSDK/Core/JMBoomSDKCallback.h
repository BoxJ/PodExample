//
//  JMBoomSDKCallback.h
//  JMBoomSDK
//
//  Created by ZhengXianda on 10/31/2022.
//  Copyright (c) 2022 ZhengXianda. All rights reserved.
//

#ifndef JMBoomSDKCallback_h
#define JMBoomSDKCallback_h

/// 回调
/// @param responseObject 接口成功的回调数据
/// @param error 接口失败的报错
typedef void(^JMBoomSDKCallback)(NSDictionary * _Nullable responseObject, NSError * _Nullable error);

#endif /* JMBoomSDKCallback_h */
