//
//  JMRequestCallback.h
//  Pods
//
//  Created by Thief Toki on 2020/6/24.
//

#ifndef JMRequestCallback_h
#define JMRequestCallback_h

/// 回调
/// @param responseObject 接口成功的回调数据
/// @param error 接口失败的报错
typedef void(^JMRequestCallback)(NSDictionary * _Nullable responseObject, NSError * _Nullable error);

#endif /* JMRequestCallback_h */
