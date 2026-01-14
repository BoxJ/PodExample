//
//  JMRktCommonCallback.h
//  Pods
//
//  Created by Thief Toki on 2021/2/4.
//

#ifndef JMRktCommonCallback_h
#define JMRktCommonCallback_h

/// 回调
/// @param responseObject 接口成功的回调数据
/// @param error 接口失败的报错
typedef void(^JMRktCommonCallback)(NSDictionary * _Nullable responseObject, NSError * _Nullable error);

#endif /* JMRktCommonCallback_h */
