//
//  JMBusinessCallback.h
//  Pods
//
//  Created by ZhengXianda on 11/3/22.
//

#ifndef JMBusinessCallback_h
#define JMBusinessCallback_h

/// 回调
/// @param responseObject 接口成功的回调数据
/// @param error 接口失败的报错
typedef void(^JMBusinessCallback)(NSDictionary * _Nullable responseObject, NSError * _Nullable error);

#endif /* JMBusinessCallback_h */
